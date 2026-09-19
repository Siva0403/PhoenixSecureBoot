
/*
    This is a sample application for our secure bootloader
    project        : PhoenixSecureBoot
    Owner          : Siva Surya Narayana
*/

#include "stm32f4xx.h"

#define LED_PIN 13U

static void application_led_init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN;

    GPIOC->MODER &= ~(3UL << (LED_PIN * 2U));
    GPIOC->MODER |=  (1UL << (LED_PIN * 2U));

    GPIOC->OTYPER &= ~(1UL << LED_PIN);
    GPIOC->OSPEEDR &= ~(3UL << (LED_PIN * 2U));
    GPIOC->PUPDR &= ~(3UL << (LED_PIN * 2U));
}

static void application_led_on(void)
{
    GPIOC->ODR &= ~(1UL << LED_PIN);
}

static void application_led_off(void)
{
    GPIOC->ODR |= (1UL << LED_PIN);
}

int main(void)
{
    application_led_init();

    while (1)
    {
        // application_led_on();
    }
}