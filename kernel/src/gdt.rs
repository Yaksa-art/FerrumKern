// SPDX-License-Identifier: MIT OR Apache-2.0
// FerrumKern -- kernel/src/gdt.rs : Stage 1 GDT stub.

/// Initialize the GDT (stub for Stage 1).
/// SAFETY: call once on boot CPU in ring 0, interrupts disabled.
pub fn init() {
    // TODO(Stage 1): flat code/data segments + TSS.
}
