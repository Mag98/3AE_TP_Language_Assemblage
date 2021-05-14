		

;************************************************************************
	THUMB	
	REQUIRE8
	PRESERVE8
;************************************************************************

	include REG_UTILES.inc


;************************************************************************
; 					IMPORT/EXPORT Système
;************************************************************************

	IMPORT ||Lib$$Request$$armlib|| [CODE,WEAK]




; IMPORT/EXPORT de procédure   
	IMPORT Barrette1
	IMPORT Barrette2
	IMPORT Barrette3

	IMPORT Init_Cible
	IMPORT DriverGlobal
	IMPORT Tempo
	IMPORT DriverReg
	IMPORT DriverPile
		
		
	

	EXPORT main
	
;*******************************************************************************


;*******************************************************************************
	AREA  mesdonnees, data, readwrite

M DCW 10


;*******************************************************************************
	
	AREA  moncode, code, readonly
		


;*******************************************************************************
; Procédure principale et point d'entrée du projet
;*******************************************************************************
main  	PROC 
;*******************************************************************************

		
	MOV R0,#1
	BL Init_Cible;
		
	;***************************;
	;Test DriverPile
	;***************************;
	;LDR R11, =Barrette1
	;PUSH {R11}
	;BL DriverPile 
	;POP {R11}
	;MOV R0,#500
	;BL Tempo 
	
	;R1 représente le nombre de clignotements
	MOV R12, #0 

	
inf LDR R11, =Barrette3
	BL DriverReg   ;allumera la barette3

	LDR R0, =GPIOBASEA 
	LDRH R2, [R0, #OffsetInput] ;R2 prend la valeur du capteur
	
	LDR R0, =M
	LDRSH R3, [R0]
		
Si	CMP R12, R3 ;Vérification R12 < M
	BEQ infini
		
S	TST R2, #(0x1 << 8) ;Vérif capteur != 1
	BEQ infini
		
		; Si capteur différent de 1 ou R1 < M
		
	MOV R0,#500
	BL Tempo 
		
	LDR R11, =Barrette1
	BL DriverReg   ;allumera la barette1
	ADD R12, #1
	
	MOV R0,#500
	BL Tempo 
		
	B inf



		
infini		B infini			 ; boucle inifinie terminale...




		ENDP

	END

;*******************************************************************************
