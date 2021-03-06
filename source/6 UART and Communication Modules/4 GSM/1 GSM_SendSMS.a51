;Program: Send an SMS using GSM
ORG 00H
	MOV TMOD,#20H	;timer 1 mode 2
	MOV TH1,#0FDH	;9600 baud
	MOV SCON,#50H	;enable UART
	SETB TR1	;enable timer 1
MAIN:
	MOV DPTR,#TEXT_MODE	;text mode (AT+CMGF=1)
NEXT:	CLR A
	MOVC A,@A+DPTR
	CJNE A,#0x0D,SEND_MODE
	MOV A,#0x0D
	ACALL Tx_data
	SJMP MOB_NUM
SEND_MODE:	ACALL Tx_data
	INC DPTR
	SJMP NEXT
MOB_NUM:	MOV DPTR,#MOBILE_NUMBER	;mobile number (AT+CMGS="number")
NEXT1:	CLR A
	MOVC A,@A+DPTR
	CJNE A,#0x0D,SEND_NUM
	MOV A,#0x0D
	ACALL Tx_data
	SJMP SMS_TXT
SEND_NUM:	ACALL Tx_data
	INC DPTR
	SJMP NEXT1
SMS_TXT:	MOV DPTR,#MOBILE_NUMBER	;SMS text
NEXT2:	CLR A
	MOVC A,@A+DPTR
	CJNE A,#0x1A,SEND_TEXT
	MOV A,#0x1A
	ACALL Tx_data
	SJMP HERE
SEND_TEXT:	ACALL Tx_data
	INC DPTR
	SJMP NEXT2
HERE:	AJMP HERE

Tx_data:	;UART send
	CLR TI
    MOV SBUF,A
WAIT:	JNB TI,WAIT
RET

TEXT_MODE: DB "AT+CMGF=1",0x0D
MOBILE_NUMBER: DB "AT+CMGS=",34,"+918527136215",34,0x0D
SMS_TEXT: DB "Hello",0x1A
END