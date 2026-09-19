#ifndef BOOTLOADER_H
#define BOOTLOADER_H

#include <stdint.h>
#include "wolfssl/wolfcrypt/sha256.h"

#define SRAM_START       0x20000000UL
#define SRAM_END         0x20018000UL

#define APPLICATION_ADDRESS         0x08010000UL
#define APPLICATION_END             0x08080000UL
#define APPLICATION_MAX_SIZE        (420*1024)      //420KB
#define APPLICATION_METADATA_ADDR   0x0807FC00UL    // 1kb meta data from flash memory ending
#define APPLICATION_MAGIC_NUMBER    0x50484F58UL

typedef void (*application_entry_t)(void);

typedef struct application_metadata_t
{
    uint32_t    appmagic;
    uint32_t    appsize;
    uint8_t     apphash[WC_SHA256_DIGEST_SIZE];

}application_metadata;

uint8_t bootloader_validate_application (void);
void    bootloader_jump_to_application  (void);
uint8_t bootloader_test_application_hash(void);

#endif