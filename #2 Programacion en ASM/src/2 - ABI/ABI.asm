extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  MOV EAX, EDI
  RET

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  PUSH RBP ;pila alineada
  MOV RBP, RSP ;strack frame armado
  PUSH R12
  PUSH R13	; preservo no volatiles, al ser 2 la pila queda alineada

  MOV R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  MOV R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  MOV EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  MOV ESI, R12D
  call sumar_c

  MOV EDI, EAX
  MOV ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  POP R13 ;restauramos los registros no volátiles
  POP R12
  POP RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de RETorno
  RET


alternate_sum_4_using_c_alternative:
  ;prologo
  PUSH RBP ;pila alineada
  MOV RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  MOV [RBP-8], RCX ; guardo x4 en la pila

  PUSH RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  POP RDX ;recupero x3
  
  MOV EDI, EAX
  MOV ESI, EDX
  call sumar_c

  MOV EDI, EAX
  MOV ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  POP RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de RETorno
  RET


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
; parametros
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
; x5 --> R8D
; x6 --> R9D
; x8 --> [RBP+24] 16 + 8 = 24
; x7 --> [RBP+16] ya que RBP+8 está ocupado por el call
alternate_sum_8:
  ; prólogo
  PUSH RBP ; ahora la pila está alineada
  MOV RBP, RSP ; El SP anterior, ahora es mi BP

  ; Dejamos el RSP alineado, reservando además, espacio.
  sub RSP, 64

  ; Antes de llamar a otras funciones, queremos guardar los valores de x3 a x6 en la pila. x7 y x8 ya lo están
  MOV [RBP - 24], EDX ; x3
  MOV [RBP - 32], ECX ; x4
  MOV [RBP - 40], R8D ; x5
  MOV [RBP - 48], R9D ; x6

  ; Hagamos x1 - x2. los parámetros se pasan por EDI y ESI, ya están ahí, 
  ; Por lo tanto simplemente llamamos a la funcion restar_c
  call restar_c
  ; Recibimos el resultado por el registro EAX, ya que restar_c es una funcion que devuelve algo de 32 bits
  ; EAX = x1 - x2. Como queremos hacer EAX + x3, ponemos EAX en EDI y x3 en ESI. 

  MOV EDI, EAX
  MOV ESI, [RBP - 24]
  call sumar_c

  ; Ahora EAX = x1 - x2 + x3. Ahora queremos restarle x4, entonces ponemos EAX en EDI y x4 en ESI
  MOV EDI, EAX
  MOV ESI, [RBP - 32]  
  call restar_c

  ; Ahora EAX = x1 - x2 + x3 - x4. Ahora queremos sumarle x5, entonces ponemos EAX en EDI y x5 en ESI.
  MOV EDI, EAX
  MOV ESI, [RBP - 40]
  call sumar_c

  ; Ahora EAX = x1 - x2 + x3 - x4 + x5. Ahora queremos restarle x6, entonces ponemos EAX en EDI y x6 en ESI
  MOV EDI, EAX
  MOV ESI, [RBP - 48]
  call restar_c

  ; Ahora EAX = x1 - x2 + x3 - x4 + x5 - x6. Ahora queremos sumarle x7, entonces ponemos EAX en EDI y x7 en ESI
  MOV EDI, EAX
  MOV ESI, [RBP + 16]

  call sumar_c

  ; Ahora EAX = x1 - x2 + x3 - x4 + x5 - x6 + x7. Ahora queremos restarle x8, entonces ponemos EAX en EDI y x8 en ESI
  MOV EDI, EAX
  MOV ESI, [RBP + 24]

  call restar_c

  ; Ya tenemos la cuenta hecha, y el resultado está en EAX. Como vamos a hacer RET, queremos dejar todo como estaba antes.
  ; En particular, el RBP lo queremos dejar como estaba antes, y el RSP igual. Por convención, el valor de RETorno debe estar en RAX (ya lo está)
  MOV RSP, RBP
  POP RBP
  RET


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
; RDI --> destination
; ESI --> x1
; XMM0 --> f1
product_2_f:

  ; Casteamos XMM0 de float32 a double
  CVTSS2SD XMM0, XMM0

  ; Convertimos x1 a float
  CVTSI2SD XMM1, RSI
  
  ; Ahora multiplicamos XMM1 (RSI) por XMM0 (f1)
  MULSD XMM0, XMM1

  ; Ahora tenemos el resultado en XMM0.
  ; Como destination es un puntero a un uint32_t, queremos convertir XMM0 a un entero de 32 bits.
  CVTTSD2SI ESI, XMM0
  
  MOV [RDI], ESI

	RET



; extern void product_9_f(double * destination
; , uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
; , uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
; , uint32_t x9, float f9);
; registros y pila: destination[RDI], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;   , x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;   , x9[?], f9[?]

; destination  --> RDI
; x1           --> ESI
; f1           --> XMM0
; x2           --> EDX
; f2           --> XMM1
; x3           --> ECX
; f3           --> XMM2
; x4           --> R8D
; f4           --> XMM3
; x5           --> R9D
; f5           --> XMM4
; x6           --> [RBP+16]
; f6           --> XMM5
; x7           --> [RBP+24]
; f7           --> XMM6
; x8           --> [RBP+32]
; f8           --> XMM7
; x9           --> [RBP+40]
; f9           --> [RBP+48]
global product_9_f
product_9_f:
    ; prólogo
    PUSH    RBP                 ; pila alineada
    MOV     RBP, RSP
    sub     RSP, 16

    ; convertimos los flotantes de cada registro xmm en doubles
    CVTSS2SD    XMM0, XMM0
    CVTSS2SD    XMM1, XMM1
    CVTSS2SD    XMM2, XMM2
    CVTSS2SD    XMM3, XMM3
    CVTSS2SD    XMM4, XMM4
    CVTSS2SD    XMM5, XMM5
    CVTSS2SD    XMM6, XMM6
    CVTSS2SD    XMM7, XMM7

    ; multiplicamos los doubles en XMM0 <- XMM0 * XMM1, XMM0 * XMM2 , ...
    MULSD       XMM0, XMM1
    MULSD       XMM0, XMM2
    MULSD       XMM0, XMM3
    MULSD       XMM0, XMM4
    MULSD       XMM0, XMM5
    MULSD       XMM0, XMM6
    MULSD       XMM0, XMM7

    ; Ahora queremos multiplicar XMM0 por f9, que está en [RBP+16]
    ; Ponemos f9 en XMM7 y multiplicamos
    CVTSS2SD    XMM7, dword [RBP+48]
    MULSD       XMM0, XMM7

    ; convertimos los enteros en doubles y los multiplicamos por XMM0.
    ; Convertimos desde x1 hasta x5.
    CVTSI2SD    XMM1, RSI
    CVTSI2SD    XMM2, RDX
    CVTSI2SD    XMM3, RCX
    CVTSI2SD    XMM4, R8
    CVTSI2SD    XMM5, R9

    ; Multiplicamos x1 hasta x5 por XMM0
    MULSD       XMM0, XMM1
    MULSD       XMM0, XMM2
    MULSD       XMM0, XMM3
    MULSD       XMM0, XMM4
    MULSD       XMM0, XMM5

    ; Convertimos desde x6 hasta x9 y multiplicamos al mismo tiempo
    MOV         EAX, dword [RBP+16]
    CVTSI2SD    XMM1, RAX
    MULSD       XMM0, XMM1

    MOV         EAX, dword [RBP+24]
    CVTSI2SD    XMM1, RAX
    MULSD       XMM0, XMM1

    MOV         EAX, dword [RBP+32]
    CVTSI2SD    XMM1, RAX
    MULSD       XMM0, XMM1

    MOV         EAX, dword [RBP+40]
    CVTSI2SD    XMM1, RAX
    MULSD       XMM0, XMM1

    ; Ponemos el valor en donde apunta el puntero destination
    MOVSD       [RDI], XMM0

    ; epílogo
    MOV     RSP, RBP
    POP     RBP
    RET
