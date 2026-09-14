#ifndef BOOTLOADER_H
#define BOOTLOADER_H

#include <stdint.h>

#define APPLICATION_ADDRESS  0x08010000UL

uint8_t bootloader_validate_application (void);
void    bootloader_jump_to_application  (void);

#endif