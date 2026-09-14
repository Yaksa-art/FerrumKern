.PHONY: all build iso run clean init-limine

all: build

build iso run clean:
	$(MAKE) -C kernel $@

init-limine:
	mkdir -p third_party
	curl -L https://github.com/limine-bootloader/limine/archive/refs/heads/trunk.tar.gz -o /tmp/limine.tar.gz
	tar -xzf /tmp/limine.tar.gz -C third_party
