// SPDX-License-Identifier: MIT OR Apache-2.0
// FerrumKern -- kernel/src/mm.rs : Stage 2 memory stub.

/// Early memory init (stub).
/// SAFETY: call once on boot CPU in ring 0 before heap/page use.
pub fn init() {
    // TODO(Stage 2): memmap parse, frame allocator, paging, heap.
}
