# 0 ".\\device\\system_stm32f4xx.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 ".\\device\\system_stm32f4xx.c"
# 48 ".\\device\\system_stm32f4xx.c"
# 1 ".\\device\\stm32f4xx.h" 1
# 49 ".\\device\\system_stm32f4xx.c" 2
# 137 ".\\device\\system_stm32f4xx.c"
uint32_t SystemCoreClock = 16000000;
const uint8_t AHBPrescTable[16] = {0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 6, 7, 8, 9};
const uint8_t APBPrescTable[8] = {0, 0, 0, 0, 1, 2, 3, 4};
# 167 ".\\device\\system_stm32f4xx.c"
void SystemInit(void)
{
# 182 ".\\device\\system_stm32f4xx.c"
  SCB->VTOR = FLASH_BASE;

}
# 222 ".\\device\\system_stm32f4xx.c"
void SystemCoreClockUpdate(void)
{
  uint32_t tmp, pllvco, pllp, pllsource, pllm;


  tmp = RCC->CFGR & RCC_CFGR_SWS;

  switch (tmp)
  {
    case 0x00:
      SystemCoreClock = ((uint32_t)16000000);
      break;
    case 0x04:
      SystemCoreClock = ((uint32_t)25000000);
      break;
    case 0x08:




      pllsource = (RCC->PLLCFGR & RCC_PLLCFGR_PLLSRC) >> 22;
      pllm = RCC->PLLCFGR & RCC_PLLCFGR_PLLM;

      if (pllsource != 0)
      {

        pllvco = (((uint32_t)25000000) / pllm) * ((RCC->PLLCFGR & RCC_PLLCFGR_PLLN) >> 6);
      }
      else
      {

        pllvco = (((uint32_t)16000000) / pllm) * ((RCC->PLLCFGR & RCC_PLLCFGR_PLLN) >> 6);
      }

      pllp = (((RCC->PLLCFGR & RCC_PLLCFGR_PLLP) >>16) + 1 ) *2;
      SystemCoreClock = pllvco/pllp;
      break;
    default:
      SystemCoreClock = ((uint32_t)16000000);
      break;
  }


  tmp = AHBPrescTable[((RCC->CFGR & RCC_CFGR_HPRE) >> 4)];

  SystemCoreClock >>= tmp;
}
