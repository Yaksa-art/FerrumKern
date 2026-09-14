/*
 * SPDX-License-Identifier: MIT OR Apache-2.0
 * FerrumKern -- kernel/c/fb.c : framebuffer helper stub (M0).
 */
#include <stdint.h>

void fk_fb_fill(uint32_t color) { (void)color; }
void fk_fb_bar(uint32_t x, uint32_t y, uint32_t w, uint32_t h, uint32_t color) {
    (void)x; (void)y; (void)w; (void)h; (void)color;
}
