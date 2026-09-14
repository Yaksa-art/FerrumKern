# FerrumKern

[![License MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE-MIT)
[![Build](https://img.shields.io/badge/build-make_run-green.svg)](Makefile)

**Железо, которому доверяешь. Iron you can trust.**

Open-source ядро с нуля: Rust-first (`no_std`), C только для драйверов, загрузка через Limine, запуск в QEMU.

## Этапы (пошагово)

### Этап 0 — Boot (мы здесь)
- [x] Скелет репозитория
- [x] `kmain` на Rust: serial `hello FerrumKern` + заливка framebuffer `0x1a1a2e`
- [ ] Сборка ISO и запуск в QEMU с OVMF
- [ ] Лог в serial как критерий готовности

### Этап 1 — GDT / IDT / исключения
- GDT, IDT, обработчики исключений с дампом регистров
- Перевод PIC, задел под APIC

### Этап 2 — Память
- Физический аллокатор (bitmap по memmap от Limine)
- 4-уровневый paging, HHDM, heap (`linked_list_allocator`)

### Этап 3 — Планировщик
- Таймер (PIT/HPET), cooperative → preemptive потоки
- Переключение контекста на ASM

### Этап 4 — Syscall + userspace
- `syscall`/`sysret`, ring 3, ELF-лоадер, `write/exit/yield`

### Этап 5 — VFS
- VFS-слой, ramfs/initramfs, `/dev/serial`, `/dev/fb`

### Этап 6 — Сеть
- virtio-net скелет, ARP/ICMP, сокет-заглушка

### Этап 7 — SMP
- Парсинг MADT, запуск AP-ядер, per-CPU планировщик

## Быстрый старт (WSL2 Ubuntu)

```bash
# 1. Зависимости
sudo apt update
sudo apt install -y qemu-system-x86 ovmf build-essential clang lld nasm mtools xorriso git make

# 2. Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup target add x86_64-unknown-none

# 3. Запуск
make run
```

Ожидаешь в serial: `hello FerrumKern`

## Структура

```
FerrumKern/
  kernel/src/main.rs   # точка входа kmain
  kernel/c/string.c    # freestanding memcpy/memset/strcmp
  kernel/linker.ld     # higher-half 0xffffffff80000000
  kernel/Makefile      # build/iso/run/clean
  boot/limine.conf     # конфиг загрузчика
  docs/design.md       # дизайн-документ
  Makefile             # верхний уровень
```

## Лицензия

Dual MIT OR Apache-2.0, см. `LICENSE-MIT`.
