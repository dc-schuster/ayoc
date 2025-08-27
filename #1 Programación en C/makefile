CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = soluciones

all: $(TARGET)

$(TARGET): soluciones.o
	$(CC) $(CFLAGS) $^ -o $@

soluciones.o: soluciones.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o $(TARGET)

.PHONY: all clean
