/*
 * SPDX-License-Identifier: MIT OR Apache-2.0
 * FerrumKern -- kernel/c/uart.c : COM1 0x3F8 16550 helper.
 */
#include <stdint.h>

#define FK_COM1 0x3F8u

static inline void fk_outb(uint16_t port, uint8_t v) {
    __asm__ volatile("outb %0, %1" :: "a"(v), "Nd"(port));
}
static inline uint8_t fk_inb(uint16_t port) {
    uint8_t r;
    __asm__ volatile("inb %1, %0" : "=a"(r) : "Nd"(port));
    return r;
}
void fk_uart_init(void) {
    fk_outb(FK_COM1 + 1, 0x00);
    fk_outb(FK_COM1 + 3, 0x80);
    fk_outb(FK_COM1 + 0, 0x03);
    fk_outb(FK_COM1 + 1, 0x00);
    fk_outb(FK_COM1 + 3, 0x03);
    fk_outb(FK_COM1 + 2, 0xC7);
    fk_outb(FK_COM1 + 4, 0x0B);
}
void fk_uart_putc(char c) {
    while ((fk_inb(FK_COM1 + 5) & 0x20) == 0) {}
    fk_outb(FK_COM1, (uint8_t)c);
}
void fk_uart_write(const char *buf, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        if (buf[i] == '\n') fk_uart_putc('\r');
        fk_uart_putc(buf[i]);
    }
}
