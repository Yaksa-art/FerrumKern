# FerrumKern Design Doc

Rust-first hobby kernel, C for drivers.

## 1. Goals
Learn OS basics on x86_64. Rust `no_std` core, C only for low-level drivers. Limine boot, reproducible WSL2 + QEMU builds.

## 2. Arch
OVMF → Limine → kernel ELF. Rust `no_main`, panic halts. C: `-ffreestanding -nostdlib`, only `stddef.h`/`stdint.h`, `fk_` prefix, static link.

## 3. Memory Map
- HHDM от Limine, direct map
- Kernel phys ~0x100000, virt base `0xFFFFFFFF80000000`
- Heap 16M init → slab/buddy (этап 2)
- Стеки per-CPU 16K с guard-страницей

## 4. Boot Flow
OVMF → Limine → ELF → BSS → GDT/IDT (этап 1) → serial → PMM/paging/heap (этап 2) → sched (3) → syscall (4) → VFS (5) → net (6) → SMP (7).

## 5. Roadmap
См. README — этапы 0–7.

## 6. Style
Rust: `cargo fmt`, `cargo clippy -- -D warnings`, `SAFETY:`-комментарии. C: C17, `-Wall -Wextra -Werror`. Коммиты: Conventional Commits.

## 7. License
MIT OR Apache-2.0.
