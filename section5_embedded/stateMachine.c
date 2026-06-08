#include <stdint.h>

typedef enum {
    BUTTON_RELEASED,
    BUTTON_PRESSED,
    BUTTON_TRANSITION
} ButtonState_t;

/**
 * @brief Filtrira mehanicki sum (debounce) s digitalnog pina.
 * @param raw_pin_state Trenutno stanje pina (0 = pritisnuto, 1 = otpusteno).
 * @return Sluzbeno, stabilizirano stanje gumba.
 */
ButtonState_t debounce_button(uint8_t raw_pin_state) {
    static ButtonState_t stabilno_stanje = BUTTON_RELEASED;
    static uint8_t uzastopna_ocitanja = 0;

    // Provjera jel doslo do promjene 
    if ((raw_pin_state == 0 && stabilno_stanje == BUTTON_RELEASED) ||
        (raw_pin_state == 1 && stabilno_stanje == BUTTON_PRESSED)) {
        
        uzastopna_ocitanja++;
        
        // Ako ostane 3 zaredom prihvaca se promjena
        if (uzastopna_ocitanja >= 3) {
            stabilno_stanje = (raw_pin_state == 0) ? BUTTON_PRESSED : BUTTON_RELEASED;
            uzastopna_ocitanja = 0;
            return stabilno_stanje;
        }
    
        return BUTTON_TRANSITION;
    } else {
        uzastopna_ocitanja = 0;
        return stabilno_stanje;
    }
}