;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ���  
    ;����
    NEWLINE DB 13,10,'$'
    ;��ʾ��Ϣ
    STRHELLO DB 0AH,0DH,'-----BEGIN-----',0AH,0DH,'$'
    STRCONTINUE DB 0AH,0DH,'CONTINUE?(Y/N)',0AH,0DH,'$'
    TESTWORDD DB 0AH,0DH,'######',0AH,0DH,'$'
    STR1 DB 0AH,0DH,'INPUT NUMBER1:',0AH,0DH,'$'
    STR2 DB 0AH,0DH,'INPUT NUMBER2:',0AH,0DH,'$'
    STR3 DB 0AH,0DH,'OUTPUT NUMBER1 BY BINARY:',0AH,0DH,'$'
    STR4 DB 0AH,0DH,'OUTPUT NUMBER2 BY BINARY:',0AH,0DH,'$'
    STR5 DB 0AH,0DH,'JUDGE NUMBER1 IS EVEN:',0AH,0DH,'$'
    STR6 DB 0AH,0DH,'JUDGE NUMBER2 IS EVEN:',0AH,0DH,'$'
    STR7 DB 0AH,0DH,'OVER',0AH,0DH,'$'
    WARN DB 0AH,0DH,'ILLEGAL NUMBER, PLEASE ENTER AGAIN:',0AH,0DH,'$'
    ;�������
    NUM DW 2 DUP(?)
    STRINN DB 5,?,5 DUP('?')
    A DW ?
    D DW ?
    F DW ?
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    DW 20H DUP(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

MAIN PROC FAR
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
   
BBGG:
	;�����ʾ��Ϣ
	LEA DX,STRHELLO
	MOV AH,09H
	INT 21H
REIN:	;��һ����
 	;�����ʾstr1
    LEA DX,STR1
    MOV AH,09H
    INT 21H
    ;����input������������
    CALL INPUT	;�������CL��Ϊ0ffh
    ;���CL��0ffh��˵�����������������
    CMP CL,0FFH
    JZ REIN
    MOV AX,NUM
    MOV NUM+2,AX
REINN:	;�ڶ�����
    ;�����ʾstr2
    LEA DX,STR2
    MOV AH,09H
    INT 21H
    ;����input������������
    CALL INPUT
    CMP CL,0FFH
    JZ REINN
    ;��ʾ��Ϣ
    LEA DX,STR3;
    MOV AH,09H
    INT 21H
    ;ת�����ƣ���ڲ���bx
    MOV BX,NUM+2
    CALL BIN
    ;��ʾ��Ϣ
    LEA DX,STR4
    MOV AH,09H
    INT 21H
    ;ת�����ƣ���ڲ���bx
    MOV BX,NUM
    CALL BIN
    ;��ʾ��Ϣ
    LEA DX,STR5
    MOV AH,09H
    INT 21H
    ;��ڲ���bx���ж��Ƿ�Ϊż��
    MOV BX,NUM+2
    CALL OUSHU
    ;��ʾ��Ϣ
    LEA DX,STR6
    MOV AH,09H
    INT 21H
    ;��ڲ���bx���ж��Ƿ�Ϊż��
    MOV BX,NUM
    CALL OUSHU
    
 	;�������������str7
    LEA DX,STR7
    MOV AH,09H
    INT 21H
    
    ;�ж��Ƿ�Ҫ����ѭ��ִ�г���Y�ͼ�����N���˳�����
    LEA DX,STRCONTINUE
    MOV AH,09H
    INT 21H
    ;����һ���ַ����û��Ƿ�Ҫ����ѭ��ִ�г���
    MOV AH,1
    INT 21H
    CMP AL,'N'
    JZ EXIT	;N����EXIT���������
    JMP BBGG	;����ѭ��ִ�г���
EXIT:
	;���У��������
	MOV DX,OFFSET NEWLINE
	MOV AH,9
	INT 21H
    MOV AH,4CH
    INT 21H
MAIN ENDP

;���뺯�������������ַ��������ж��Ƿ�Ϸ�
INPUT PROC NEAR
	;���������ַ���
	LEA DX,STRINN;ȡstr����ַ�����ڴ��������ַ���
	MOV AH,0AH
	INT 21H
	
	LEA SI,STRINN+2	;���ƫ�Ƶ�ַ
	MOV CX,4	;��������ѭ����
	MOV DX,0	;������飬����
A1:
	;������¼ѭ��������CX
	PUSH CX
	;��һ���ַ����ж��Ƿ�ΪСд��ĸ�����Ϸ�����A4
	MOV AL,[SI]
	CMP AL,'0'
	JB A4
	CMP AL,'F'
	JA A4
	CMP AL,'9'
	JBE A2
	CMP AL,'A'
	JB A4
	
	SUB AL,07H	;
A2:
	SUB AL,30H;	;תbcd
	CBW			;��չAL->AX
	ADD DX,AX	
	CMP CX,1	;������һ��ѭ��������λ��ִ�У�ֱ�Ӽ�
	JZ A3	
	;����4λ
	MOV CL,4	
	SHL DX,CL
A3:
	INC SI	;ƫ��1λ����  DB����
	POP CX
	LOOP A1
	MOV CL,0
	MOV NUM,DX	
	JMP A5
A4:	;��CL��λ0FFH�� �������벻�Ϸ�����Ҫ��������
	POP CX
	MOV CL,0FFH
	MOV DX,0
	MOV NUM,DX
A5:
	RET
INPUT ENDP

;ת������
BIN PROC NEAR
	MOV CX,16
	MOV DX,0
B1:
	MOV AX,0
  	SHL BX,1
  	ADC AL,0                   ;ѭ������1λ����CF��ʾλ���λ2������
  	PUSH CX                    ;����CX
 	PUSH BX                    ;����BX
 	ADD AL,30H				;תascii
 	MOV CX,1				;����
 	MOV BL,07H                ;��ʾ���
 	MOV BH,0
 	MOV AH,09H
 	INT 10H					
 	MOV AH,03H                
 	INT 10H
 	INC DL                   ;���ƣ�DL++
 	MOV AH,02H               
 	INT 10H					;���һ���ַ�
 	POP BX					;�ָ�BX
 	POP CX					;�ָ�CX
 	LOOP B1
  
  RET

BIN ENDP

;�ж��Ƿ�Ϊż��
OUSHU PROC NEAR          
  PUSH BX                  ;����BX
  ;ȡbcdĩλ
  AND BX,0001H             
  MOV CX,8
C1:
  CMP BL,0H                ;�ж�ĩβ�ǲ���0���Ǿ���ż��
  JZ C2						;��ż����C2���������ʮ����
  MOV AH,02H               ;����ż�������NO��
  MOV DL,'N'
  INT 21H
  MOV AH,02H
  MOV DL,'O'
  INT 21H
  POP BX
  JMP C3	;���ӳ������

C2:
  POP BX
  MOV CX,5
  MOV AX,BX
  MOV BX,10
C4:
  MOV DX,0
  DIV BX                    ;����10
  ADD DL,30H		;תbcd
  PUSH DX			;������ջ
  LOOP C4			;����ѭ���������
  MOV CX,5
C5:					;ȡջ������ջһ��
  POP DX	
  MOV AH,02H                ;���ַ����
  INT 21H		
  LOOP C5			;ѭ������ַ��������ɾ���ʮ������
C3:
  RET
OUSHU ENDP

    
    
    
CODES ENDS
    END MAIN