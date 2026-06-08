# Kompajler i stroge zastavice prema dokumentu
CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -Werror -O2

# Ciljani objektni moduli s tvojim točnim imenima datoteka
TARGETS = memoryManipulation.o stateMachine.o

# Defaultno pravilo
all: $(TARGETS)

# Prevođenje Task 1 modula (zastavica -c blokira traženje main funkcije)
memoryManipulation.o: memoryManipulation.c
	$(CC) $(CFLAGS) -c memoryManipulation.c -o memoryManipulation.o

# Prevođenje Task 2 modula
stateMachine.o: stateMachine.c
	$(CC) $(CFLAGS) -c stateMachine.c -o stateMachine.o

# Obavezno Clean pravilo za potpuno brisanje artefakata
clean:
	rm -f *.o