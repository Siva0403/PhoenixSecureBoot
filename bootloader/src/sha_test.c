#include "wolfssl/wolfcrypt/sha256.h"
#include "stm32f4xx.h"
#include "sha_test.h"

int sha256_test(void)
{
    Sha256 sha256;
    byte digest[WC_SHA256_DIGEST_SIZE];

    const byte test_data[] = "abc";

    const byte expected_digest[WC_SHA256_DIGEST_SIZE] =
    {
        0xBA, 0x78, 0x16, 0xBF,
        0x8F, 0x01, 0xCF, 0xEA,
        0x41, 0x41, 0x40, 0xDE,
        0x5D, 0xAE, 0x22, 0x23,
        0xB0, 0x03, 0x61, 0xA3,
        0x96, 0x17, 0x7A, 0x9C,
        0xB4, 0x10, 0xFF, 0x61,
        0xF2, 0x00, 0x15, 0xAD
    };

    if (wc_InitSha256(&sha256) != 0)
    {
        return 0;
    }

    if (wc_Sha256Update(&sha256,
                        test_data,
                        sizeof(test_data) - 1U) != 0)
    {
        return 0;
    }

    if (wc_Sha256Final(&sha256, digest) != 0)
    {
        return 0;
    }

    for (uint32_t i = 0U; i < WC_SHA256_DIGEST_SIZE; i++)
    {
        if (digest[i] != expected_digest[i])
        {
            return 0;
        }
    }

    return 1;
}