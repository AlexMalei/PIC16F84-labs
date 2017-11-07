
;------------------------------------------------------
; EMBEDDED SYSTEMS
; Practical Work #1
;------------------------------------------------------
; This is a source file of the program which finds the
; maximal element from the given array of numbers.
;------------------------------------------------------
; File      :   max.asm
; Author    :   Alexander A. Ivaniuk
; Date      :   10.10.2004
;------------------------------------------------------
#include "p16f84.inc" 

c_adr set 0x30  ; the starting address of the array, a constant
v_ptr equ 0x2F  ; the pointer to the current element in array, a variable
v_min equ 0x2D  ; the maximal number in array, a variable
v_swap1 equ 0x2C
v_swap2 equ 0x2B
v_addsum equ 0x20
v_subsum equ 0x21
c_num set 0x14   ; the number of elements in array, a constant 


BEGIN:
	BCF STATUS, 0x5 ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF v_ptr   
	CLRF v_min 
	GOTO OUTLOOP2 ;pointer of exersice;

; EXERCISE 1
MININIT:
	MOVF v_ptr,0 
	ADDLW c_adr
	MOVWF FSR
	MOVF INDF,0
	MOVWF v_min

LOOP1:
	MOVF v_min,0 
	SUBWF INDF,0
	BTFSC STATUS,0
	GOTO SKIP1
		
	MOVF INDF,0
	MOVWF v_min 
	
SKIP1:
	INCF FSR, 0x1
	MOVLW c_num
	ADDLW c_adr
	SUBWF FSR,0
	BTFSS STATUS,0
	GOTO LOOP1
	GOTO CLEAR

; EXERCISE 2
OUTLOOP2: 
	MOVLW c_adr
	MOVWF FSR
	INCF FSR, 0x1

INLOOP2: 
	MOVF INDF,0
	MOVWF v_swap1 
	DECF FSR, 0x1
	MOVF INDF, 0
	INCF FSR, 0x1
	SUBWF v_swap1, 0 
	BTFSC STATUS,0 
	GOTO SKIP2

	DECF FSR, 0x1
	MOVF INDF,0
	MOVWF v_swap2
	MOVF v_swap1, 0
	MOVWF INDF
	INCF FSR, 0x1
	MOVF v_swap2, 0
	MOVWF INDF

SKIP2:
	INCF FSR, 0x1
	MOVF v_ptr, 0
	SUBLW c_num
	ADDLW c_adr
	SUBWF FSR, 0
	BTFSS STATUS, 0
	GOTO INLOOP2
	
	;Outloop2 continue
	INCF v_ptr, 0x1	
	MOVLW c_num
	SUBWF v_ptr, 0
	BTFSS STATUS, 0 
	GOTO OUTLOOP2
	GOTO CLEAR

; EXERCISE 3
OUTLOOP3: 
	MOVLW c_adr
	MOVWF FSR
	INCF FSR, 0x1

INLOOP3: 
	MOVF INDF,0
	MOVWF v_swap1 
	DECF FSR, 0x1
	MOVF v_swap1, 0
	SUBWF INDF, 0
	INCF FSR, 0x1
	BTFSC STATUS,0
	GOTO SKIP3

	DECF FSR, 0x1
	MOVF INDF,0
	MOVWF v_swap2
	MOVF v_swap1, 0
	MOVWF INDF
	INCF FSR, 0x1
	MOVF v_swap2, 0
	MOVWF INDF

SKIP3:
	INCF FSR, 0x1
	MOVF v_ptr, 0
	SUBLW c_num
	ADDLW c_adr
	SUBWF FSR, 0
	BTFSS STATUS, 0
	GOTO INLOOP3

	INCF v_ptr, 0x1	
	MOVLW c_num
	SUBWF v_ptr, 0
	BTFSS STATUS, 0
	GOTO OUTLOOP3
	GOTO CLEAR

;ADDITIONAL_TASK
ADDINIT:
	CLRF v_subsum
	CLRF v_addsum
	MOVF v_ptr,0 
	ADDLW c_adr
	MOVWF FSR

LOOPA:
	MOVLW 0x7F  
	SUBWF INDF, 0
	BTFSC STATUS, 0
	GOTO SUB 
	
ADD:
	MOVF INDF, 0
	ADDWF v_addsum, 0x1
	GOTO NEXT
SUB:
	MOVF INDF, 0
	ADDWF v_subsum, 0x1

NEXT:
	INCF FSR, 0x1
	MOVLW c_num
	ADDLW c_adr
	SUBWF FSR,0
	BTFSS STATUS,0
	GOTO LOOPA

CLEAR:
	CLRF v_ptr
	CLRF v_min
 
	end
