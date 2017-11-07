#include "p16f84.inc"

v_length equ 0x10 ; lenght in string 
v_processed equ 0x11 ; number of next symbol for read 
v_eeprom_value equ 0x12


c_arr_adr_1 set 0x30 ; array starting address
c_num_1 set 0x5  ; number symbols in string

c_arr_adr_2 set 0x40
c_num_2 set 0x6 


    ORG 0x2100
    DE 0x42, 0x53, 0x55, 0x49, 0x52
	ORG 0x0

BEGIN:
	GOTO MAIN

READ_STRING_FROM_EEPROM:
	
	
	BCF STATUS, 0x5 ;a set bank0
	
;///// read memory adress for EEPROM //////
	CLRW 
	MOVLW v_processed 
	MOVWF FSR		 
	MOVF INDF, 0


;///// read value from EEPROM ////////////
	MOVWF EEADR     
 	BSF STATUS, 0x5 
	BSF EECON1, 0x0 
	BCF STATUS, 0x5 
	MOVF EEDATA, 0  



;///// write value to memory /////////////
	MOVWF v_eeprom_value
	CLRW
	ADDLW c_arr_adr_1
	ADDWF v_processed, 0
	MOVWF FSR
	MOVF v_eeprom_value,0
	MOVWF INDF


	INCF v_processed
	MOVLW v_processed 
	MOVWF FSR
	MOVF INDF, 0

	
	SUBWF v_length, 0 
	BTFSC STATUS, 0x2
	GOTO END_READ_FROM_EEPROM	  
	
	GOTO READ_STRING_FROM_EEPROM 

WRITE_ARRAY_TO_EEPROM:	

START_INITIALIZE_ARRAY:
	
	MOVLW c_arr_adr_2		
	ADDWF v_processed, 0	
	MOVWF FSR				
	MOVF v_processed, 0	
	MOVWF INDF				

	INCF v_processed	
	MOVF v_processed,0 ; 

	ADDLW 0x1
	SUBWF v_length, 0 
	BTFSS STATUS, 0x0
	GOTO START_WRITE_TO_EEPROM	 
					  			 
	GOTO START_INITIALIZE_ARRAY

START_WRITE_TO_EEPROM:
	
	CLRF v_processed

START_CYCLE:

	MOVLW c_arr_adr_2
	ADDWF v_processed,0
	MOVWF FSR
	MOVF INDF, 0
	MOVWF v_eeprom_value


	BCF STATUS, 0x5	; EEADR, EEDATA -> bank0
	MOVF v_processed, 0
	MOVWF EEADR
	MOVF v_eeprom_value 
	MOVWF EEDATA
	
	BSF STATUS, 0x5  ; EECON1 EECON2 -> bank1

	BCF INTCON, 0x7 ; GIE -> disable ints

	BSF EECON1, 0x2; WREN
	MOVLW 0x55
	MOVWF EECON2
	MOVLW 0xAA		;only this sequence initiate writing(see datasheet)
	MOVWF EECON2	
	BSF EECON1, 0x1 ; WR

WRITE_SYMBOL_EECON_CYCLE:
	BTFSS EECON1, 0x1 ;WR
	GOTO END_WRITE_SYMBOL_CYCLE
	GOTO WRITE_SYMBOL_EECON_CYCLE

END_WRITE_SYMBOL_CYCLE:	
	BSF INTCON, 0x7 ; GIE bit
	
	INCF v_processed	
	MOVF v_processed,0 ; 

	SUBWF v_length, 0 ; check that we processed all string
	BTFSS STATUS, 0x2
	GOTO START_CYCLE

	GOTO ENDMAIN


MAIN:
	
	CLRW 
	ADDLW c_num_1		 
	MOVWF v_length       
	CLRF v_processed	
	
	GOTO READ_STRING_FROM_EEPROM

END_READ_FROM_EEPROM:

	CLRW 
	ADDLW c_num_2		 
	MOVWF v_length      
	CLRF v_processed	

	GOTO WRITE_ARRAY_TO_EEPROM

ENDMAIN:
	
	NOP	

END