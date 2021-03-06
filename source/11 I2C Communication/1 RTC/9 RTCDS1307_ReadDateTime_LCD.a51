;Program: WAP to read the time and date from RTC DS1307 and display on LCD
E EQU P2.7
RS EQU P2.6
LCD EQU P0
	
EXTRN CODE (I2C_INIT)	;import i2c functions
EXTRN CODE (I2C_RSTART)
EXTRN CODE (I2C_START)
EXTRN CODE (I2C_STOP)
EXTRN CODE (I2C_SENDBYTE)
EXTRN CODE (I2C_SENDACK)
EXTRN CODE (I2C_SENDNACK)
EXTRN CODE (I2C_RECBYTE)

SEG_MAIN SEGMENT CODE
	ORG 0
	LJMP MAIN
	
	RSEG SEG_MAIN
MAIN:
	ACALL LCD_INIT
AGAIN:	ACALL I2C_START
	MOV A,#0D0H	;DS1307 address write
	ACALL I2C_SENDBYTE
	MOV A,#00H	;start location
	ACALL I2C_SENDBYTE
	ACALL I2C_STOP
	ACALL I2C_START
	MOV A,#0D1H	;DS1307 address read
	ACALL I2C_SENDBYTE
	MOV R0,#30H	;start address to store bytes
	MOV R1,#7	;count for receving bytes
AGAIN1:	ACALL I2C_RECBYTE	;recieve byte
	MOV @R0,A
	ACALL I2C_SENDACK
	INC R0
	DJNZ R1,AGAIN1	;next byte
	ACALL I2C_STOP
	MOV R4,#80H	;display on LCD
	ACALL LCD_COMMAND
	MOV A,32H
	ACALL LCD_BCD
	MOV R4,#':'
	ACALL LCD_DATA
	MOV A,31H
	ACALL LCD_BCD
	MOV R4,#':'
	ACALL LCD_DATA
	MOV A,30H
	ACALL LCD_BCD
	MOV R4,#0C0H
	ACALL LCD_COMMAND
	MOV A,36H
	ACALL LCD_BCD
	MOV R4,#'/'
	ACALL LCD_DATA
	MOV A,35H
	ACALL LCD_BCD
	MOV R4,#'/'
	ACALL LCD_DATA
	MOV A,34H
	ACALL LCD_BCD
	SJMP AGAIN

LCD_INIT:
	CLR E
	CLR RS
	MOV R4, #38H	;Use 2 lines and 5�7 matrix for LCD
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV R4, #0CH	;LCD ON, Cursor ON, Cursor blink ON
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

LCD_BCD:	;display BCD number on LCD
	MOV R1,A
	SWAP A
	ANL A,#0FH
	ADD A,#30H
	MOV R4, A
	ACALL LCD_DATA
	MOV A,R1
	ANL A,#0FH
	ADD A,#30H
	MOV R4, A
	ACALL LCD_DATA
RET

DELAY:	;Function for delay
		MOV R7, #200
LOOP11:	MOV R6, #200
LOOP12:	DJNZ R6, LOOP12
		DJNZ R7, LOOP11
RET
END