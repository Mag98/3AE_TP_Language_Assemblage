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
	LDR R1, =GPIOBASEA 
	;set(slck)
	MOV R2, #(0x01 <<5)
	STRH R2, [R1,#OffsetSet]
	
	MOV R3, #0 ; curseur de la boucle 
	MOV R4, #48
	LDR R0, =ValCourante 
	LDRH R5, [R0]
	
	;je mets lavaleur de Barrette1 dans R6
	;LDR R0, =Barrette1
	;LDRH R6, [R0]
	
FOR_48 	CMP R3, R4
	BEQ END_FOR_48 
	;LDRB R5, [R6,R3] 
	;je mets lavaleur de Barrette1 dans R6
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
	PUSH{R0}
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
	POP{R0}
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
	LDRB R5, [R0,R3]
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

	BX LR 
	ENDP




	

;**************************************************************************
	END