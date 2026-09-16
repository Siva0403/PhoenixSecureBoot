
/* 
    *This is a bootloader implementation for STM32F4xx it checks application validity*
    This bootloader uses a small memory footprint and is designed to be secure. 
    It performs the following checks before jumping to the application:
    1. Checks if the application is present at the specified address.

    Future Scope   : secure bootloader and recovery 
    project        : PhoenixSecureBoot
    Owner          : Siva Surya Narayana 
*/

#include "bootloader.h"
#include "stm32f4xx.h"
#include "sha_test.h"

#define LED_PIN 13

static void bootloader_led_init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN;

    GPIOC->MODER &= ~(3 << (LED_PIN * 2));
    GPIOC->MODER |=  (1 << (LED_PIN * 2));

    GPIOC->OTYPER &= ~(1 << LED_PIN);
    GPIOC->OSPEEDR &= ~(3 << (LED_PIN * 2));
    GPIOC->PUPDR &= ~(3 << (LED_PIN * 2));
}

static void bootloader_led_on(void)
{
    GPIOC->ODR &= ~(1 << LED_PIN);
}

static void bootloader_led_off(void)
{
    GPIOC->ODR |= (1 << LED_PIN);
}

int main(void)
{

        SCB->CFSR = 0xFFFFFFFFUL;
    SCB->HFSR = 0xFFFFFFFFUL;
    SCB->DFSR = 0xFFFFFFFFUL;
    bootloader_led_init();

    bootloader_led_on();

    for (volatile uint32_t i = 0; i < 200000U; i++)
    {

    }

    bootloader_led_off();

    if (sha256_test() == 0)
{
    /*
     * SHA-256 test failed.
     * Stay here with LED ON.
     */
    bootloader_led_on();

    while (1)
    {
    }
}

    // Check if the application is valid before jumping to it
    // Check msp, reset handler, and application presence

    if(bootloader_validate_application() == 0U)
    {
        // Application is not valid, stay in bootloader mode and blink the LED
        while (1)
        {
            bootloader_led_on();

            for (volatile uint32_t i = 0; i < 200000U; i++)
            {
            }

            bootloader_led_off();

            for (volatile uint32_t i = 0; i < 200000U; i++)
            {
            }
        }
    }

   bootloader_jump_to_application();

}