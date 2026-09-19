#include "bootloader.h"
#include "stm32f4xx.h"

#define HASH_CHUNK_SIZE 1024U

static uint8_t bootloader_calculate_application_hash(uint32_t image_size, uint8_t hash[WC_SHA256_DIGEST_SIZE])
{
    Sha256 sha256;
    const uint8_t *application =(const uint8_t *)APPLICATION_ADDRESS;
    uint32_t remaining = image_size;

    if (wc_InitSha256(&sha256) != 0)
    {
        return 0U;
    }

    while (remaining > 0U)
    {
        uint32_t chunk_size;

        if (remaining > HASH_CHUNK_SIZE)
        {
            chunk_size = HASH_CHUNK_SIZE;
        }
        else
        {
            chunk_size = remaining;
        }

        if (wc_Sha256Update(&sha256,application,chunk_size) != 0)
        {
            return 0U;
        }

        application += chunk_size;
        remaining   -= chunk_size;
    }

    if (wc_Sha256Final(&sha256, hash) != 0)
    {
        return 0U;
    }

    return 1U;
}

uint8_t bootloader_test_application_hash(void)
{
    const application_metadata *metadata = (const application_metadata *)APPLICATION_METADATA_ADDR;

    uint8_t calculated_hash[WC_SHA256_DIGEST_SIZE];

    if (bootloader_calculate_application_hash( metadata->appsize, calculated_hash) == 0U)
    {
        return 0U;
    }

    for (uint32_t i = 0U; i < WC_SHA256_DIGEST_SIZE; i++)
    {
        if (calculated_hash[i] != metadata->apphash[i])
        {
            return 0U;
        }
    }

    return 1U;
}

static uint8_t bootloader_validate_app_meta_data(const application_metadata *app_meta_data)
{
    if((app_meta_data->appsize <=  APPLICATION_MAX_SIZE) && (app_meta_data->appmagic == APPLICATION_MAGIC_NUMBER))
    {
        return 1;
    }

    return 0;

}

static uint8_t bootloader_validate_msp(uint32_t msp)
{
    /*
     * Initial MSP must point into SRAM.
     *
     * 0x20018000 is accepted because it is the
     * initial stack pointer value (_estack).
     */
    if ((msp >= SRAM_START) && (msp <= SRAM_END))
    {
        return 1U;
    }

    return 0U;
}

static uint8_t bootloader_validate_reset_handler(uint32_t reset_handler)
{
    /*
     * Cortex-M executes code in Thumb state.
     * Therefore bit 0 must be set.
     */
    if ((reset_handler & 1UL) == 0UL)
    {
        return 0U;
    }

    /*
     * Remove Thumb-state bit before checking
     * the actual code address.
     */
    uint32_t reset_address = reset_handler & ~1UL;

    /*
     * Reset_Handler must point inside the
     * application Flash region.
     */
    if ((reset_address >= APPLICATION_ADDRESS) &&
        (reset_address < APPLICATION_END))
    {
        return 1U;
    }

    return 0U;
}

static uint8_t bootloader_application_present(uint32_t app_msp,
                                               uint32_t app_reset)
{
    /*
     * Erased Flash contains 0xFFFFFFFF.
     *
     * If both vector-table entries are erased,
     * there is no application image.
     */
    if ((app_msp == 0xFFFFFFFFUL) && (app_reset == 0xFFFFFFFFUL))
    {
        return 0U;
    }

    return 1U;
}

uint8_t bootloader_validate_application(void)
{
    uint32_t app_msp;
    uint32_t app_reset;

    /*
     * Read the application's vector table.
     */
    app_msp   = *(volatile uint32_t *)APPLICATION_ADDRESS;
    app_reset = *(volatile uint32_t *)(APPLICATION_ADDRESS + 4U);

    const application_metadata *metadata = (const application_metadata *)APPLICATION_METADATA_ADDR;

    /*
    *   Step 1: Is Meta present!1
    */
    if (bootloader_validate_app_meta_data(metadata) == 0U)
    {
        return 0U;
    }

    /*
     * Step 2: Is an application present?
     */
    if (bootloader_application_present(app_msp, app_reset) == 0U)
    {
        return 0U;
    }

    /*
     * Step 3: Is the application's stack pointer valid?
     */
    if (bootloader_validate_msp(app_msp) == 0U)
    {
        return 0U;
    }

    /*
     * Step 4: Is the application's Reset_Handler valid?
     */
    if (bootloader_validate_reset_handler(app_reset) == 0U)
    {
        return 0U;
    }

    /*
     * All structural checks passed.
     */
    return 1U;
}

void bootloader_jump_to_application(void)
{
    uint32_t app_msp;
    uint32_t app_reset;
    application_entry_t application_entry;

    /*
     * Read application vector table.
     */
    app_msp   = *(volatile uint32_t *)APPLICATION_ADDRESS;
    app_reset = *(volatile uint32_t *)(APPLICATION_ADDRESS + 4U);

    application_entry = (application_entry_t)app_reset;

    /*
     * Disable bootloader interrupts before handing over control.
     */
    __disable_irq();

    /*
     * Tell Cortex-M that the application's vector
     * table is now located at APPLICATION_ADDRESS.
     */
    SCB->VTOR = APPLICATION_ADDRESS;

    __DSB();
    __ISB();

    /*
     * Load application's initial stack pointer.
     */
    __set_MSP(app_msp);

    /*
     * Enter application's Reset_Handler.
     */
    application_entry();

    while (1)
    {
        // Control should never return here, but if it does, loop forever.
    }
}