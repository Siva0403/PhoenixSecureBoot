cmake_minimum_required(VERSION 3.20)

project(PhoenixSecureBoot C ASM)

set(CMAKE_C_STANDARD 11)

set(STM32_CUBE_F4
    "D:/Embedded/Projects/STM32CubeF4"
)

set(STM32_CMSIS_CORE
    "${STM32_CUBE_F4}/Drivers/CMSIS/Core"
)

set(STM32_CMSIS_DEVICE
    "${STM32_CUBE_F4}/Drivers/CMSIS/Device/ST/STM32F4xx"
)

add_subdirectory(bootloader)
add_subdirectory(application)