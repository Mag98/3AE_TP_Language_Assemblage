		

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

		
		
	

	EXPORT main
	
;*******************************************************************************


;*******************************************************************************
	AREA  mesdonnees, data, readwrite

	


;*******************************************************************************
	
	AREA  moncode, code, readonly
		


;*******************************************************************************
; Procédure principale et point d'entrée du projet
;*******************************************************************************
main  	PROC 
;*******************************************************************************

		
		MOV R0,#1
		BL Init_Cible;
		
		BL DriverGlobal   ;allumera la barette3
		
		;MOV R0,#5
		;BL Tempo 

		;LDR R11, =Barrette3
		;BL DriverReg
		
infini		B infini			 ; boucle inifinie terminale...




		ENDP

	END

;*******************************************************************************
