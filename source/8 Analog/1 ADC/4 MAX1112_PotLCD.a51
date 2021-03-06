;Program: Read potentiometer output using MAX1112  channel 1 and display it on LCD
E EQU P2.7
RS EQU P2.6
LCD EQU P0
ADC_DIN EQU P3.4
ADC_DOUT EQU P3.6
ADC_SCLK EQU P3.5
ORG 00H
	ACALL LCD_INIT
BACK:	MOV A,#9EH	;select channel 1 of ADC
	MOV R3,#8
CTRL_WORD:	RLC A	;sending bits
	MOV ADC_DIN,C
	CLR ADC_SCLK
	ACALL DELAY
	SETB ADC_SCLK
	ACALL DELAY
	DJNZ R3,CTRL_WORD
	CLR ADC_SCLK
	SETB ADC_DOUT
	
	SETB ADC_SCLK	;receiving adc data bits
	ACALL DELAY
	CLR ADC_SCLK
	ACALL DELAY
	MOV R3,#8
ADC_DATA:	SETB ADC_SCLK
	ACALL DELAY
	CLR ADC_SCLK
	ACALL DELAY
	MOV C,ADC_DOUT
	RLC A
	DJNZ R3,ADC_DATA
	MOV R4, #80H	;convert to ASCII
	ACALL LCD_COMMAND	;and display on LCD
	MOV B,#10
	DIV AB
	MOV R3,B
	MOV B,#10
	DIV AB
	ADD A,#30H
	MOV R4, A
	ACALL LCD_DATA
	MOV A,B
	ADD A,#30H
	MOV R4, A
	ACALL LCD_DATA
	MOV A,R3
	ADD A,#30H
	MOV R4, A
	ACALL LCD_DATA
	ACALL DELAY
	ACALL DELAY
	ACALL DELAY
	ACALL DELAY
	ACALL DELAY
	SJMP BACK

LCD_INIT:
	CLR E
	CLR RS
	MOV R4, #38H	;Use 2 lines and 5�7 matrix for LCD
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV R4, #0CH	;LCD ON, Cursor OFF
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV R4, #01H	;LCD clear
	ACALL LCD_COMMAND
	ACALL DELAY
RET

LCD_COMMAND:	;Function for LCD command
	CLR RS
	MOV LCD, R4
	SETB E
	ACALL DELAY
	CLR E
RET
	
LCD_DATA:	;Function for LCD data
	SETB RS
	MOV LCD, R4
	SETB E
	ACALL DELAY
	CLR E
RET
	
DELAY:	;Function for delay
		MOV R7, #200
LOOP1:	MOV R6, #200
LOOP:	DJNZ R6, LOOP
		DJNZ R7, LOOP1
RET
END