set(BOOTLOADER_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/bootloader.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/sha_test.c

    ${PROJECT_SOURCE_DIR}/device/system_stm32f4xx.c
    ${PROJECT_SOURCE_DIR}/startup/startup_stm32f401xe.s
)

# ---------------------------------------------------------
# wolfCrypt - minimal SHA-256 library
# ---------------------------------------------------------

set(WOLFSSL_DIR
    ${PROJECT_SOURCE_DIR}/third_party/wolfssl
)

add_library(wolfcrypt_sha256 STATIC
    ${WOLFSSL_DIR}/wolfcrypt/src/sha256.c
)

target_include_directories(wolfcrypt_sha256 PRIVATE
    ${WOLFSSL_DIR}
)

target_compile_definitions(wolfcrypt_sha256 PRIVATE
    WOLFSSL_USER_SETTINGS
)

add_executable(phoenix_bootloader
    ${BOOTLOADER_SOURCES}
)

target_link_libraries(phoenix_bootloader PRIVATE
    wolfcrypt_sha256
)

target_include_directories(phoenix_bootloader PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
    ${PROJECT_SOURCE_DIR}/device
    ${WOLFSSL_DIR}
)

target_compile_definitions(phoenix_bootloader PRIVATE
    STM32F401xE
    WOLFSSL_USER_SETTINGS
)

target_compile_options(phoenix_bootloader PRIVATE
    -mcpu=cortex-m4
    -mthumb
    -ffunction-sections
    -fdata-sections
    -Wall
    -Wextra
)

target_link_options(phoenix_bootloader PRIVATE
    -T${PROJECT_SOURCE_DIR}/linker/bootloader.ld
    -mcpu=cortex-m4
    -mthumb
    -Wl,--gc-sections
    -Wl,-Map=${CMAKE_BINARY_DIR}/phoenix_bootloader.map
)