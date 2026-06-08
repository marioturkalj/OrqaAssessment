Section 6: Digital Design & Hardware Description Languages (VHDL) 
Task: Vending Machine Control Logic

1. Architectural Overview
Zadatak implementiran pomoću konačnog automata stanja, a prati se unešeni kredit, odabir proizvoda, vraćanje kusura te upravlja procesom isporuke proizvoda. Kad se proizvod isporučuje stanje se zaključava i ignoriraju se svi novi zahtjevi do povratka u IDLE stanje. Cijene se računaju prema zadanoj formuli u predlošku, a neispravne operacije bacaju kod pogreške.

2. Assumptions & Trade-offs
Svi novčani iznosi pohranjuju se u centima radi jednostavnije implementacije.
Maksimalni kredit ograničen je na 50 EUR.
Za mjerenje vremena isporuke koristi se brojač taktova.

Odabrana je jednostavna FSM arhitektura radi preglednosti i lakše sinteze, uz nešto veći broj stanja u odnosu na kombinacijsku implementaciju.

3. Verification Steps
Testbench pokriva sljedeće:
normalan unos kovanica i kupnju proizvoda,
prekoračenje maksimalnog kredita,
neispravan unos kovanice,
neispravan odabir proizvoda,
povrat ostatka novca,
pokušaj kupnje, povratka kusura ili ubacivanje novca tijekom isporuke proizvoda,
provjeru trajanja isporuke od 5 sekundi
