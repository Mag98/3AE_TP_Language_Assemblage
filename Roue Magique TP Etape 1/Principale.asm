		

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

		
		MOV R0,#0
		BL Init_Cible;
		LDR R1, =GPIOBASEB
		; pour allumer la LED avec le registre 
		;SET(PortB.Set)16= ?(0x01 << 10)
		MOV R2, #(0x01 << 10)
		STRH R2, [R1,#OffsetSet]
	
		; pour �teindre la LED avec le registre 
		; RESET(PortB.Reset)16= ?(0x01 << 10)
		MOV R2, #(0x01 << 10)
		STRH R2, [R1,#OffsetReset]
		
		; pour allumer la led avec le registre output
		LDRH R3, [R1,#OffsetOutput]
		
		ORR R4, R3, R2
		STRH  R4, [R1 , #OffsetOutput]
		
inf		B inf			 ; boucle inifinie terminale...




		ENDP

	END

;*******************************************************************************
