# FerrumKern Roadmap

> Each stage ends with a QEMU `-serial stdio` log pasted into the PR. No log = no merge.

| Stage | Goal | Tasks | Exit criteria |
|-------|------|-------|---------------|
| 0 — Boot | Limine boot + serial hello | `_start`, COM1 0x3F8, `kprintln!` | `hello FerrumKern` in serial, no triple fault |
| 1 — GDT/IDT | GDT/IDT + PIC + exceptions | GDT+IDT, PIC remap, PF/GP handlers | `[stage1] idt ok, tick=100` |
| 2 — Memory | Paging + allocator + heap | 4-level paging, bitmap frames, heap | `[stage2] mem ok` |
| 3 — Sched | Timer + threads | ctx switch, tasks, yield | `[stage3] tasks A/B interleaved` |
| 4 — Userspace | Rings + syscalls + ELF | ring3, write/exit, loader | `[stage4] user: hello from ring3` |
| 5 — VFS | VFS + ramfs | VFS layer, initramfs | `[stage5] vfs ok` |
| 6 — Net | virtio-net | ARP/ICMP, sockets | `[stage6] net ok` |
| 7 — SMP | AP boot + polish | APIC, per-CPU, CI green | `[stage7] smp: N CPUs up` on `-smp 4` |
