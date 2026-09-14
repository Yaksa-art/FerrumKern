# Contributing to FerrumKern / Как контрибьютить

> Short version: fork → branch `feat-*` → `cargo fmt` + `clippy` → one change per PR → QEMU serial log in PR → be kind.

## EN
1. **Fork**, clone your fork.
2. **Branch:** `feat-<short-name>` (fix: `fix-<short-name>`).
3. **Style:**
   ```sh
   cargo fmt --manifest-path kernel/Cargo.toml
   cargo clippy --manifest-path kernel/Cargo.toml --target x86_64-unknown-none -- -D warnings
   gcc -fsyntax-only -ffreestanding -Wall -Wextra kernel/c/string.c kernel/c/uart.c kernel/c/fb.c
   ```
4. **One change per PR.**
5. **QEMU serial log in PR** — paste `-serial stdio` boot log + command.
6. **Be kind.** Review code, not people.

## RU
1. **Форк**, клонируй.
2. **Ветка:** `feat-<имя>`.
3. **Стиль** — команды выше перед пушем.
4. **Одно изменение на PR.**
5. **Serial-лог QEMU в PR.**
6. **Будь добр.**
