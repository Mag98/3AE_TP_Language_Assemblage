;***************************************************************************
	THUMB	
	REQUIRE8
	PRESERVE8

;**************************************************************************
;  Fichier Vierge.asm
; Auteur : V.MAHOUT
; Date :  12/11/2013
;**************************************************************************

;***************IMPORT/EXPORT**********************************************
	IMPORT Barrette1 
	IMPORT Barrette3

	EXPORT DriverGlobal
	EXPORT Tempo
	EXPORT DriverReg
	IMPORT DataSend
	EXPORT DriverPile
	EXPORT CopieTVI
	IMPORT TVI
	EXPORT Allume_LED
	EXPORT Eteint_LED
;**************************************************************************



;***************CONSTANTES*************************************************

	include REG_UTILES.inc 

;**************************************************************************


;***************VARIABLES**************************************************
	 AREA  MesDonnees, data, readwrite
;**************************************************************************
ValCourante DCW 1 


;**************************************************************************



;***************CODE*******************************************************
   	AREA  moncode, code, readonly
;**************************************************************************




Allume_LED PROC
		PUSH {R1,R2}
		; pour allumer la LED avec le registre 
		LDR R1, =GPIOBASEB
		MOV R2, #(0x01 << 10)
		STRH R2, [R1,#OffsetSet]
		POP {R1,R2}
		BX LR ;Pour sortir de la fonction 
		
		ENDP


Eteint_LED PROC
		PUSH {R1,R2}
		LDR R1, =GPIOBASEB
		MOV R2, #(0x01 << 10)
		STRH R2, [R1,#OffsetReset]
		POP {R1,R2}
		BX LR
		
		ENDP

;########################################################################
; Procédure DriverGlobal
;########################################################################
;
; Paramètre entrant  : ???
; Paramètre sortant  : ???
; Variables globales : ???
; Registres modifiés : ???
;------------------------------------------------------------------------

DriverGlobal PROC
	PUSH{R1,R2,R3,R4,R0,R5,R6,R7,R8,R9,R10}
	LDR R1, =GPIOBASEA 
	;set(slck)
	MOV R2, #(0x01 <<5)
	STRH R2, [R1,#OffsetSet]
	
	MOV R3, #0 ; curseur de la boucle 
	MOV R4, #48
	LDR R0, =ValCourante 
	LDRH R5, [R0]
	

	
FOR_48 	CMP R3, R4
	BEQ END_FOR_48 
	;LDRB R5, [R6,R3] 
	;je mets la valeur de Barrette1 dans R6
	LDR R0, =Barrette3
	LDRH R6, [R0]
	LDRB R5, [R0,R3]
	;MOV R6, #(0x01 << 24)
	;LDR R5, [R4,R5]
	LSL R5 , #24
			
	MOV R7, #0
	MOV R8, #12
	
FOR_12 	CMP R7,R8  
	BEQ END_FOR_12 
	
	;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;test de la condition sur le poids fort    
	TST R5, #(0x01<<31)
	BEQ ELSE


IF 	
	;set(sin)
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetSet]
	B EndIf
 	
ELSE 	;reset sin
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetReset]
	B EndIf

EndIf	LSL R5, #1

	;set(slck)
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetSet]

	ADD R7, #1
	B FOR_12
END_FOR_12

	ADD R3, #1 
	B FOR_48
END_FOR_48	

;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;dataSend = 0 
	LDR R0, =DataSend
	STRH R10, [R0]
	MOV R10, #0
	STRH R10 , [R0]

	POP{R1,R2,R3,R4,R0,R5,R6,R7,R8,R9,R10}
	BX LR 
	ENDP

;########################################################################
; Procédure Tempo
;########################################################################
;
; Paramètre entrant  : -
; Paramètre sortant  : -
; Variables globales : -
; Registres modifiés : R0
;------------------------------------------------------------------------	

Tempo PROC
	PUSH{R0,R2,R3,R5}
	MOV R1, #0 
	MOV R5, #10
	MUL R0, R5
	
FOR_ONE CMP R1,R0
	BEQ END_ONE
		
	MOV R2, #0 
	MOV R3, #1500

FOR_TWO CMP R2,R3
	BEQ END_TWO
	NOP
	ADD R2, #1
	B FOR_TWO
END_TWO
	ADD R1, #1 
	B FOR_ONE
END_ONE
	POP{R0,R2,R3,R5}
	BX LR
	ENDP


;########################################################################
; Procédure DriverReg
;########################################################################
;
; Paramètre entrant  : R11
; Paramètre sortant  : ???
; Variables globales : ???
; Registres modifiés : ???
;------------------------------------------------------------------------

DriverReg PROC
	PUSH{R1,R2,R3,R4,R0,R5,R6,R7,R8,R9,R10}
	LDR R1, =GPIOBASEA 
	;set(slck)
	MOV R2, #(0x01 <<5)
	STRH R2, [R1,#OffsetSet]
	
	MOV R3, #0 ; curseur de la boucle 
	MOV R4, #48
	LDR R0, =ValCourante 
	LDRH R5, [R0]
	
FOR_48_REG 
	CMP R3, R4
	BEQ END_FOR_48_REG 
	
	;je mets la valeur de Barrette1 dans R6
	LDRH R6, [R11]
	LDRB R5, [R11,R3] 
	LSL R5 , #24
			
	MOV R7, #0
	MOV R8, #12
	
FOR_12_REG
 	CMP R7,R8  
	BEQ END_FOR_12_REG
	
	;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;test de la condition sur le poids fort    
	TST R5, #(0x01<<31)
	BEQ ELSE_REG


IF_REG 	
	;set(sin)
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetSet]
	B EndIf_REG
 	
ELSE_REG 	;reset sin
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetReset]
	B EndIf_REG

EndIf_REG
	LSL R5, #1

	;set(slck)
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetSet]

	ADD R7, #1
	B FOR_12_REG
END_FOR_12_REG

	ADD R3, #1 
	B FOR_48_REG
END_FOR_48_REG	

;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;dataSend = 0 
	LDR R0, =DataSend
	STRH R10, [R0]
	MOV R10, #0
	STRH R10 , [R0]

	POP{R1,R2,R3,R4,R0,R5,R6,R7,R8,R9,R10}
	
	BX LR 
	ENDP



;########################################################################
; Procédure DriverPile
;########################################################################
;
; Paramètre entrant  : Pile
; Paramètre sortant  : ???
; Variables globales : ???
; Registres modifiés : ???
;------------------------------------------------------------------------

DriverPile PROC
	PUSH{R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10}
	LDR R1, =GPIOBASEA 
	MOV R2, #(0x01 <<5)
	STRH R2, [R1,#OffsetSet]
	
	MOV R3, #0 ; curseur de la boucle 
	MOV R4, #48
	LDR R0, =ValCourante 
	LDRH R5, [R0]
	
FOR_48_PILE
	CMP R3, R4
	BEQ END_FOR_48_PILE
	
	;je mets la valeur de Barrette1 dans R6
	LDRH R6, [R11]
	LDRB R5, [R11,R3] 
	LSL R5 , #24
			
	MOV R7, #0
	MOV R8, #12
	
FOR_12_PILE
 	CMP R7,R8  
	BEQ END_FOR_12_PILE
	
	;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;test de la condition sur le poids fort    
	TST R5, #(0x01<<31)
	BEQ ELSE_PILE


IF_PILE
	;set(sin)
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetSet]
	B EndIf_PILE
 	
ELSE_PILE	;reset sin
	MOV R9, #(0x01 << 7)
	STRH R9, [R1, #OffsetReset]
	B EndIf_PILE

EndIf_PILE
	LSL R5, #1

	;set(slck)
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetSet]

	ADD R7, #1
	B FOR_12_PILE
END_FOR_12_PILE

	ADD R3, #1 
	B FOR_48_PILE
END_FOR_48_PILE

;reset(sclk) 
	MOV R2, #(0x01 << 5)
	STRH R2, [R1,#OffsetReset]

	;dataSend = 0 
	LDR R0, =DataSend
	STRH R10, [R0]
	MOV R10, #0
	STRH R10 , [R0]

	POP{R1,R2,R3,R4,R5,R6,R7,R8,R9,R10}
	
	BX LR 
	ENDP

;########################################################################
; Procédure CopieTVI
;########################################################################
;
; Paramètre entrant  : 
; Paramètre sortant  : ???
; Variables globales : ???
; Registres modifiés : ???
;------------------------------------------------------------------------

CopieTVI PROC
	PUSH{R1,R2,R4}
	MOV R1, #0
	MOV R2, #1024
	
	MOV R4, #(0x0)
	
	
For_Copie	
	CMP R1, R2
	BEQ Fin
	LDR  R5, [R4]    ; on met ce qu'il y a dans l'adresse R4 dans R5
	STR R5, [R3]  ; on met ce qu'il y a dans R5 dans l'adresse R3
	ADD R1, #4
	ADD R3, #4 ; pointe sur la TVI vide
	ADD R4, #4 ; pointe sur le tableau plein
	B For_Copie 
Fin		
	LDR R3, =TVI
	LDR R4 , =SCB_VTOR
	STR R3, [R4]  ; R3 contient l'adresse de la TVI
	
	POP{R1,R2,R4}
	BX LR
	ENDP	
;**************************************************************************
	END