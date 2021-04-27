		

;************************************************************************
	THUMB	
	REQUIRE8
	PRESERVE8
;************************************************************************

	include REG_UTILES.inc


;************************************************************************
; 					IMPORT/EXPORT Syst�me
;************************************************************************

	IMPORT ||Lib$$Request$$armlib|| [CODE,WEAK]




; IMPORT/EXPORT de proc�dure           

	IMPORT Init_Cible
	IMPORT Allume_LED
	IMPORT Eteint_LED
	

	EXPORT main
	
;*******************************************************************************


;*******************************************************************************
	AREA  mesdonnees, data, readwrite

OldEtat DCW 3
Nb 		DCW 5


;*******************************************************************************
	
	AREA  moncode, code, readonly
		


;*******************************************************************************
; Proc�dure principale et point d'entr�e du projet
;*******************************************************************************
main  	PROC 
;*******************************************************************************



		
		MOV R0,#0
		BL Init_Cible;
		
		; pour allumer la led avec le registre output
		;LDRH R3, [R1,#OffsetOutput]
		
		;ORR R4, R3, R2
		;STRH  R4, [R1 , #OffsetOutput]
		
		; pour �teindre la led avec output
		;LDRH R3, [R1,#OffsetOutput]
		
		;MVN R6, R2
		;AND R4, R3, R6
		;STRH  R4, [R1 , #OffsetOutput]


;**********************************************************
;D�tection front montant
;**********************************************************


		LDR R6, = OldEtat
		;LDRSH R3, [R0]
		LDR R0, =Nb
		LDRSH R11, [R0]
		
		LDR R0, =GPIOBASEA
 	  	LDRH R3, [R0, #OffsetInput] ;R3 repr�sente OldEtat
		STR R3, [R6]
		AND R3, #(0x1<<8)
		
		MOV R10, #0 ;R10 repr�sente le nombre de tours actuels

inf 	LDR R0, =GPIOBASEA
 	  	LDRH R7, [R0, #OffsetInput] ;R7 repr�sente l'�tat actuel du capteur
		
		LDR R0, =GPIOBASEB
 	  	LDRH R8, [R0, #OffsetOutput] ;R8 repr�sente l'�tat de la LED
		

Si		LDRSH R3, [R6]
		AND R7, #(0x1<<8)

		SUBS R9, R7, R3
		BEQ Sortie ;Si R7 et R3 sont �gales

Oui		TST R7, #(0x1 << 8) ;Si R7 front montant
		BEQ Sortie ;Cas d'un front descendant

T_Oui	TST R8, #(0x1 <<10) 
		BEQ Eteinte ;La LED est eteinte

Allume 	BL Eteint_LED
		ADD R10, #1
		B Sortie

Eteinte BL Allume_LED	
		ADD R10, #1



Sortie	     ; Cr�er une variable qui m�morise l'�tat pr�c�dent et qu'on compare � l'�tat actuel
		STR R7, [R6] 

		CMP R11, R10
		BNE Suite
		BL Allume_LED
		
		
		
		BEQ infini ;Quand on a fait N tours
		
Suite	B inf	
		
infini  B infini


;inf		LDR R0, =GPIOBASEA
;		LDRH R0, [R0,#OffsetInput]

;Si		TST R0, #(0x1 << 8)
;		BEQ T_Non

;T_Oui	BL Allume_LED
;		B Sortie

;T_Non	BL Eteint_LED

;Sortie	B inf			 ; boucle inifinie terminale...




		ENDP

	END

;*******************************************************************************
