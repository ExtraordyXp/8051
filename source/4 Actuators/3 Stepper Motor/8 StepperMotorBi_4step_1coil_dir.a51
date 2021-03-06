;Program: Control direction of rotation of bipolar stepper motor using single coil 4 steps
Stepper EQU P2	;P2.3-P2.0
PB_CW EQU P3.2
PB_CCW EQU P3.5
ORG 00H
MAIN:
	JNB PB_CW,STEPPER_CW
	JNB PB_CCW,STEPPER_CCW
	AJMP MAIN
STEPPER_CW:	MOV Stepper,#11111011B	;steps for bipolar stepper CW
	ACALL DELAY
	MOV Stepper,#11111110B
	ACALL DELAY
	MOV Stepper,#11110111B
	ACALL DELAY
	MOV Stepper,#11111101B
	ACALL DELAY
	AJMP MAIN
STEPPER_CCW:	MOV Stepper,#11111101B	;steps for bipolar stepper CCW
	ACALL DELAY
	MOV Stepper,#11110111B
	ACALL DELAY
	MOV Stepper,#11111110B
	ACALL DELAY
	MOV Stepper,#11111011B
	ACALL DELAY
	AJMP MAIN
	
DELAY:	;Function for delay
		MOV R1, #10
LOOP1:	MOV R2, #200
LOOP:	DJNZ R2, LOOP
		DJNZ R1, LOOP1
RET
END