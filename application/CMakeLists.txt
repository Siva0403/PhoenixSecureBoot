set(APPLICATION_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.c

    ${PROJECT_SOURCE_DIR}/device/system_stm32f4xx.c
    ${PROJECT_SOURCE_DIR}/startup/startup_stm32f401xe.s
)

add_executable(phoenix_application
    ${APPLICATION_SOURCES}
)

target_include_directories(phoenix_application PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
    ${PROJECT_SOURCE_DIR}/device
)

target_compile_definitions(phoenix_application PRIVATE
    STM32F401xE
)

target_compile_options(phoenix_application PRIVATE
    -mcpu=cortex-m4
    -mthumb
    -ffunction-sections
    -fdata-sections
    -Wall
    -Wextra
)

target_link_options(phoenix_application PRIVATE
    -T${PROJECT_SOURCE_DIR}/linker/application.ld
    -mcpu=cortex-m4
    -mthumb
    -Wl,--gc-sections
    -Wl,-Map=${CMAKE_BINARY_DIR}/phoenix_application.map
)