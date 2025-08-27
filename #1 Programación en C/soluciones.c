
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>

// Helpers para otras funciones
void print_int_array(const int *a, size_t n) {
    printf("[");
    for (size_t i = 0; i < n; ++i){
        printf("%d", a[i]);
        if (i + 1 < n) printf(", ");
    }
    printf("]\n");
}

// Fin helpers

int snippet_1() {
    printf("Hola Orga!\n");
    return 0;    
}

int snippet_2() {
    char c = 100;
    short s = -8712;
    int i = 123456;
    long l = 1234567890;

    printf("char(%lu): %d \n", sizeof(c),c);
    printf("short(%lu): %d \n", sizeof(s),s);
    printf("int(%lu): %d \n", sizeof(i),i);
    printf("long(%lu): %ld \n", sizeof(l),l);

    return 0;
}

void ejercicio_3() {

    puts("== Enteros (con modificadores) ==");
    printf("%-22s %zu bytes\n", "char",                 sizeof(char));           // char puede ser signed o unsigned según la implementación
    printf("%-22s %zu bytes\n", "signed char",          sizeof(signed char));
    printf("%-22s %zu bytes\n", "unsigned char",        sizeof(unsigned char));

    printf("%-22s %zu bytes\n", "short",                sizeof(short));
    printf("%-22s %zu bytes\n", "unsigned short",       sizeof(unsigned short));

    printf("%-22s %zu bytes\n", "int",                  sizeof(int));
    printf("%-22s %zu bytes\n", "unsigned",             sizeof(unsigned));

    printf("%-22s %zu bytes\n", "long",                 sizeof(long));
    printf("%-22s %zu bytes\n", "unsigned long",        sizeof(unsigned long));

    printf("%-22s %zu bytes\n", "long long",            sizeof(long long));
    printf("%-22s %zu bytes\n", "unsigned long long",   sizeof(unsigned long long));

    puts("\n== Punto flotante ==");
    printf("%-22s %zu bytes\n", "float",                sizeof(float));
    printf("%-22s %zu bytes\n", "double",               sizeof(double));
    printf("%-22s %zu bytes\n", "long double",          sizeof(long double));

    puts("\n== Booleano ==");
    printf("%-22s %zu bytes\n", "bool",                 sizeof(bool));

    puts("\n== Punteros ==");
    printf("%-22s %zu bytes\n", "void *",               sizeof(void *));
    printf("%-22s %zu bytes\n", "char *",               sizeof(char *));
    printf("%-22s %zu bytes\n", "int *",                sizeof(int *));
}

void ejercicio_4() {
    printf("Signed: int8_t (%lu bytes)\nUnsinged: uint8_t (%lu bytes)\n", sizeof(int8_t), sizeof(uint8_t));
    printf("Signed: int16_t (%lu bytes)\nUnsigned: uint16_t (%lu bytes)\n", sizeof(int16_t), sizeof(uint16_t));
    printf("Signed: int32_t (%lu bytes)\nUnsigned: uint32_t (%lu bytes)\n", sizeof(int32_t), sizeof(uint32_t));
    printf("Signed: int64_t (%lu bytes)\nUnsigned: uint64_t (%lu bytes)\n\n\n", sizeof(int64_t), sizeof(uint64_t));
}

void snippet_8() {
    int mensaje_secreto[] = {116, 104, 101, 32, 103, 105, 102, 116, 32, 111,
    102, 32, 119, 111, 114, 100, 115, 32, 105, 115, 32, 116, 104, 101, 32,
    103, 105, 102, 116, 32, 111, 102, 32, 100, 101, 99, 101, 112, 116, 105,
    111, 110, 32, 97, 110, 100, 32, 105, 108, 108, 117, 115, 105, 111, 110};

    size_t length = sizeof(mensaje_secreto) / sizeof(int);
    char decoded[length];

    for (size_t i = 0; i < length; i++) {
        decoded[i] = (char) (mensaje_secreto[i]); // casting de int a char
    }

    for (size_t i = 0; i < length; i++) {
        printf("%c", decoded[i]);
    }

}

void ejercicio_5(void) {
    float  como_float  = 0.1f;  // literal float
    double como_double = 0.1;   // literal double

    // Mostrar con precisión para notar diferencias
    printf("float  (%%f):  %.9f\n",  como_float);      // ~6-7 dígitos útiles
    printf("double (%%f):  %.17f\n", como_double);     // ~15-16 dígitos útiles

    // Opcional: forma hexadecimal (muestra la representación binaria)
    printf("float  (%%a):  %a\n",  (double) como_float); // float se promueve a double en printf
    printf("double (%%a):  %a\n",  como_double);

    // Cast a int (trunca hacia 0)
    printf("(int)float  -> %d\n", (int) como_float);
    printf("(int)double -> %d\n", (int) como_double);
}

void ejercicio_7() {
    int a = 5;
    int b = 3;
    int c = 2;
    int d = 1;

    printf("%d\n", a + b * c / d);
    printf("%d\n", a % b);
    printf("%d\n", ~a);
    printf("%d\n", a >> 1);
    printf("%d\n", a << 1);
}

void ejercicio_8() { 
    int i_mas = 0;
    int mas_i = 0;

    printf("i++: %d (i++ devuelve i, luego incrementa)\n++i: %d (++i incrementa, luego devuelve)\n", i_mas++, ++mas_i);
}

void ejercicio_9(int32_t palabra_1, int32_t palabra_2) {

    // Agarramos los 3 bits mas altos de una palabra de 32 bits
    uint32_t shift_1 = ((uint32_t)palabra_1 >> 29) & 0x7u;
    
    // Preparamos una flag
    int flag = shift_1 == ((uint32_t)palabra_2 & 0x7u);

    // Comparamos
    if (flag) {
        printf("Los 3 bits mas altos de la palabra uno son iguales a los 3 bits mas bajos de la palabra 2\n");
    } else {
        printf("No coinciden\n");
    }
    
}

// void ejercicio_12(int *a, size_t n, size_t length) {

// }

void ejercicio_13() {
    int tiradas = 6e6;
    int resultados[6] = {0};

    while (tiradas > 0) {
        int tirada = rand() % 6;
        resultados[tirada] = resultados[tirada] + 1; 
        tiradas--;
    }

    print_int_array(resultados, 6);
}

int ejercicio_15(int n) {
    int result = 1;
    while (n > 0) {
        result = result * n;
        n--;
    }
    return result;
}

// Hasta acá la guía básica. Ahora empieza la guía avanzada.


int main() {
    
}
