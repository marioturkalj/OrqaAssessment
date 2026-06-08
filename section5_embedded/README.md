Embedded C & RTOS Fundamentals

- Task 1: Memory-Mapped Hardware Bit Manipulation

1. Architectural Overview
U prvom zadatku se koriste obične bitwise operacije (Set, Clear, Toggle) na 32-bitnom registru koji se nalazi na zadanoj adresi. 
Koristio sam operatore |=, &= ~ te ^= jer oni mijenjaju samo bit koji smo zadali, a ostale ne.

2. Assumptions & Trade-offs
Assumptions: Registar je širine 32 bita, a fokus zadatka je manipulacija pojedinim bitovima bez mijenjanja ostatka registra.
Trade-offs: Prednost direktnog pristupa registru je jednostavnost i brza manipulacija pojedinim bitovima, dok je nedostatak slabija čitljivost koda.

3. Verification Steps
U ovome zadatku provjereno je jesu li bitwise operacije davale očekivane rezultate te da li se mijenja samo traženi bit registra.

---

- Task 2: High-Reliability Button Debounce State Machine

1. Architectural Overview
Ovaj problem bouncea sam riješio preko State Machine logike koja se izvršava svakih 5ms. 
Funkcija prati stabilno stanje pina te broj jednakih i uzastopnih očitanja pina. 
Promjena stanja se prihvaća nakon 3 uzastopna i jednaka uzorka pa se tako izbjegava lažni trigger uzorkovan bounceom.

2. Assumptions & Trade-offs
Assumptions:
0 = pressed, 1 = released to je active-low logika, funkcija se izvršava svakih 5 ms, nema hardware debounce mehanizma

Trade-offs:
Korišten je state machine pristup umjesto delay-based debounce metode jer ne blokira izvođenje programa i omogućuje periodičko provjeravanje stanja tipke.

3. Verification Steps
Provjereni su sljedeći slučajevi:
stabilan pritisak - BUTTON_PRESSED,
stabilno otpuštanje - BUTTON_RELEASED,
bounce sekvence (0-1-0-1) ne uzrokuju promjenu stanja,
dugo držanje tipke održava stabilno stanje
