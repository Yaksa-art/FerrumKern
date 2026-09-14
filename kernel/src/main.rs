// Copyright (c) FerrumKern Contributors
// SPDX-License-Identifier: MIT OR Apache-2.0
#![no_std]
#![no_main]

use core::fmt::Write;
use limine::request::FramebufferRequest;
use limine::{BaseRevision, RequestsEndMarker, RequestsStartMarker};
use x86_64::instructions::{hlt, port::PortWriteOnly};

#[used]
static _START: RequestsStartMarker = RequestsStartMarker::new();
#[used]
static BASE_REVISION: BaseRevision = BaseRevision::new();
#[used]
static FB_REQ: FramebufferRequest = FramebufferRequest::new();
#[used]
static _END: RequestsEndMarker = RequestsEndMarker::new();

struct Serial;
impl Serial {
    fn b(b: u8) {
        // SAFETY: COM1 data port write, standard x86 I/O in kernel context.
        unsafe { PortWriteOnly::new(0x3F8).write(b) }
    }
    fn s(s: &str) {
        for b in s.bytes() {
            Self::b(b);
        }
    }
}
impl Write for Serial {
    fn write_str(&mut self, s: &str) -> core::fmt::Result {
        Serial::s(s);
        Ok(())
    }
}

#[unsafe(no_mangle)]
unsafe extern "C" fn kmain() -> ! {
    assert!(BASE_REVISION.is_supported());
    Serial::s("hello FerrumKern\r\n");
    if let Some(resp) = FB_REQ.response() {
        for fb in resp.framebuffers() {
            if fb.bpp() != 32 {
                continue;
            }
            let (w, h, pitch) = (
                fb.width() as usize,
                fb.height() as usize,
                fb.pitch() as usize,
            );
            let addr = fb.addr() as *mut u8;
            for y in 0..h {
                let bar = y < 48;
                let (r, g, b) = if bar {
                    (0x6bu8, 0x4au8, 0x3au8)
                } else {
                    (0x2eu8, 0x1au8, 0x1au8)
                };
                for x in 0..w {
                    let px = addr.add(y * pitch + x * 4);
                    px.write_volatile(b);
                    px.add(1).write_volatile(g);
                    px.add(2).write_volatile(r);
                    px.add(3).write_volatile(0xFF);
                }
            }
        }
        Serial::s("fb: ok 0x1a1a2e\r\n");
    }
    loop {
        hlt();
    }
}

#[panic_handler]
fn panic(info: &core::panic::PanicInfo) -> ! {
    Serial::s("PANIC\r\n");
    let _ = writeln!(Serial, "{}", info);
    loop {
        hlt();
    }
}
