		

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
; Proc�dure principale et point d'entr�e du projet
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
