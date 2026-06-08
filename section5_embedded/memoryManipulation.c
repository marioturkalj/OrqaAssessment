//Rješenje za Embedded C & RTOS Fundamentals

#include <stdint.h>

#define TARGET_ADDRESS 0x40021004

void configure_hardware_register(void) {
    //const onemogućili pokazivanje druge adrese, a volatile ne optimizira čitanje i pisanje 
    volatile uint32_t *const ctrl_reg = (volatile uint32_t *)TARGET_ADDRESS;

    // 1. Postavljanje 3. bita na 1 (Set)
    *ctrl_reg |= (1UL << 3);

    // 2. Prisilno brisanje 10. bita na 0 (Clear)
    *ctrl_reg &= ~(1UL << 10);

    // 3. Prebacivanje 15. bita u suprotno stanje (Toggle)
    *ctrl_reg ^= (1UL << 15);
}