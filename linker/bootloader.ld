/* PhoenixSecureBoot
 *
 * STM32F411CEU6
 *
 * SecureBootloader memory layout:
 * Flash: 0x08000000 - 0x0800FFFF
 * RAM:   0x20000000 - 0x2001FFFF
 */

ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 96K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    .text :
    {
        . = ALIGN(4);

        KEEP(*(.isr_vector))

        *(.text)
        *(.text*)

        *(.rodata)
        *(.rodata*)

        . = ALIGN(4);
        _etext = .;
    } > FLASH

        .init :
    {
        . = ALIGN(4);
        KEEP(*(.init))
        . = ALIGN(4);
    } > FLASH

    .fini :
    {
        . = ALIGN(4);
        KEEP(*(.fini))
        . = ALIGN(4);
    } > FLASH

    .data :
    {
        . = ALIGN(4);

        _sdata = .;

        *(.data)
        *(.data*)

        . = ALIGN(4);

        _edata = .;
    } > RAM AT > FLASH

    _sidata = LOADADDR(.data);

    .bss :
    {
        . = ALIGN(4);

        _sbss = .;

        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);

        _ebss = .;
    } > RAM

    PROVIDE(end = .);

    ASSERT(
        LOADADDR(.data) + SIZEOF(.data) <= ORIGIN(FLASH) + LENGTH(FLASH),
        "Bootloader FLASH overflow"
    )
}