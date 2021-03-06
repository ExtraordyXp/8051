;Program: WAP to display string �ETI LABS� on OLED using lookup table
OLED_ADDR EQU 78H
OLED_NCMD EQU 00H
OLED_NDATA EQU 40H
	
EXTRN CODE (OLED_INIT)	;import OLED functions
EXTRN CODE (OLED_CMD)
EXTRN CODE (OLED_DATA)
EXTRN CODE (OLED_SETCUR)
EXTRN CODE (OLED_CLEAR)
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
	ACALL OLED_INIT	;initialize OLED
	MOV R4,#0
	MOV R5,#0
	ACALL OLED_SETCUR	;set cursor to (0,0)
	ACALL I2C_START
	MOV A,#OLED_ADDR	;OLED address
	ACALL I2C_SENDBYTE
	MOV A,#OLED_NDATA	;send data
	ACALL I2C_SENDBYTE
	MOV R0,#40
	MOV DPTR,#STRING
AGAIN:	CLR A	;display "ETI LABS"
	MOVC A,@A+DPTR
	ACALL I2C_SENDBYTE
	INC DPTR
	DJNZ R0,AGAIN
	ACALL I2C_STOP
	SJMP $

STRING: DB 0x7F, 0x49, 0x49, 0x49, 0x41	;E
DB 0x01, 0x01, 0x7F, 0x01, 0x01	;T
DB 0x00, 0x41, 0x7F, 0x41, 0x00	;I
DB 0x00, 0x00, 0x00, 0x00, 0x00	;' '
DB 0x7F, 0x40, 0x40, 0x40, 0x40	;L
DB 0x7C, 0x12, 0x11, 0x12, 0x7C	;A
DB 0x7F, 0x49, 0x49, 0x49, 0x36	;B
DB 0x46, 0x49, 0x49, 0x49, 0x31	;S
END