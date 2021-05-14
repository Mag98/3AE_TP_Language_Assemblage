		

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
	IMPORT CopieTVI
	EXPORT TVI
	IMPORT Allume_LED
	IMPORT Eteint_LED	
	

	EXPORT main
	
;*******************************************************************************


;*******************************************************************************
	AREA  mesdonnees, data, readwrite, align= 9

TVI SPACE 1024

;*******************************************************************************
	
	AREA  moncode, code, readonly
		
OldEtat DCW 3
Nb 	EQU 5

;*******************************************************************************
; Procédure principale et point d'entrée du projet
;*******************************************************************************
main  	PROC 
;*******************************************************************************

		
	MOV R0,#2
	BL Init_Cible
		
	LDR R3, =TVI
	BL CopieTVI 
	
	;detection de passage devant le capteur
Etat_LED 	
	LDR R0, =GPIOBASEA 
	
infini B infini ; boucle infinie terminale ...




		ENDP

	END

;*******************************************************************************
