# FerrumKern - kernel Makefile
TARGET := x86_64-unknown-none
PROFILE := release
CRATE_ELF := target/$(TARGET)/$(PROFILE)/ferrumkern
SYSROOT := ../sysroot
KERNEL_ELF := $(SYSROOT)/kernel.elf
ISO := ../ferrumkern.iso
QEMU := qemu-system-x86_64
QEMU_FLAGS := -m 512M -cdrom $(ISO) -serial stdio -no-reboot -no-shutdown
OVMF_CODE ?= /usr/share/OVMF/OVMF_CODE.fd
OVMF_VARS ?= /usr/share/OVMF/OVMF_VARS.fd

.PHONY: build iso run clean

build:
	cd $(CURDIR) && cargo build --release
	mkdir -p $(SYSROOT)
	cp $(CRATE_ELF) $(KERNEL_ELF)

iso: build
	mkdir -p $(SYSROOT)
	cp ../boot/limine.conf $(SYSROOT)/limine.conf
ifdef LIMINE_DIR
	mkdir -p $(SYSROOT)/boot/limine
	cp $(LIMINE_DIR)/limine-bios.sys $(LIMINE_DIR)/limine-bios-cd.bin $(LIMINE_DIR)/limine-uefi-cd.bin $(SYSROOT)/boot/limine/
	mkdir -p $(SYSROOT)/EFI/BOOT
	cp $(LIMINE_DIR)/BOOTX64.EFI $(SYSROOT)/EFI/BOOT/
endif
	xorriso -as mkisofs -b boot/limine/limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot boot/limine/limine-uefi-cd.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		$(SYSROOT) -o $(ISO)
ifdef LIMINE_DIR
	$(LIMINE_DIR)/limine bios-install $(ISO)
endif

run: iso
	$(QEMU) $(QEMU_FLAGS) \
		-drive if=pflash,format=raw,readonly=on,file=$(OVMF_CODE) \
		-drive if=pflash,format=raw,file=$(OVMF_VARS)

clean:
	cargo clean
	rm -rf $(KERNEL_ELF) $(ISO)
