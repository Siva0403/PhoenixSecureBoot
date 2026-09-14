# ARM Cortex-M Toolchain File for CMake
# Sets up the ARM GCC cross-compiler for STM32 microcontrollers

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify the cross compiler
find_program(ARM_CC arm-none-eabi-gcc REQUIRED)
find_program(ARM_CXX arm-none-eabi-g++ REQUIRED)
find_program(ARM_OBJCOPY arm-none-eabi-objcopy REQUIRED)
find_program(ARM_OBJDUMP arm-none-eabi-objdump REQUIRED)
find_program(ARM_SIZE arm-none-eabi-size REQUIRED)
find_program(ARM_GDB arm-none-eabi-gdb REQUIRED)

set(CMAKE_C_COMPILER ${ARM_CC})
set(CMAKE_CXX_COMPILER ${ARM_CXX})
set(CMAKE_ASM_COMPILER ${ARM_CC})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Disable compiler checks for embedded
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_ASM_COMPILER_WORKS TRUE)

# Common compile flags for ARM Cortex-M
set(ARM_COMMON_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard -Wall -Wextra -ffunction-sections -fdata-sections")

set(CMAKE_C_FLAGS_INIT "${ARM_COMMON_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS_INIT "${ARM_COMMON_FLAGS} -std=c++17")
set(CMAKE_ASM_FLAGS_INIT "${ARM_COMMON_FLAGS}")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections -Wl,-u,_printf_float")

# Set default build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Custom targets for post-build
function(add_bin_target target_name target_elf)
    add_custom_command(TARGET ${target_elf} POST_BUILD
        COMMAND ${ARM_OBJCOPY} -O binary ${target_elf} ${target_elf%.elf}.bin
        COMMAND ${ARM_SIZE} ${target_elf}
        COMMENT "Generating binary and showing size for ${target_name}"
    )
endfunction()

function(add_hex_target target_name target_elf)
    add_custom_command(TARGET ${target_elf} POST_BUILD
        COMMAND ${ARM_OBJCOPY} -O ihex ${target_elf} ${target_elf%.elf}.hex
        COMMENT "Generating Intel HEX for ${target_name}"
    )
endfunction()
