;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
	;�˴��������ݶδ���  
	
	STR0 DB 0AH,0DH,'INPUT ERROR! PLEASE INPUT AGAIN!',0AH,0DH,'$' ;��ʾ��Ϣ
	STR1 DB 'INPUT AN INTEGER (6WEI): $'	;��ʾ��Ϣ
	BUF DB 0,0,0,0,0,0	;�洢6���ַ�������
	NEWLINE DB 13,10,'$'	;����
	STR2 DB 'SUM: $'	;��ʾ��Ϣ
	
	NUM1 DB 0		;���һ����
	NUM2 DB 0		;��ڶ�����
	NUM3 DB 0		;���������
	SUM  DW 0		;��SUM��
	STR3 DB 'SORT: $'	;��ʾ��Ϣ
DATAS ENDS

STACKS SEGMENT

STACKS ENDS
	;�˴������ջ�δ���
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:	;���ʱ��ת�����
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
AGA:    ;ѭ�����г���ı�־
    ;��ʾ��ʾ��Ϣ
    LEA DX,STR1	
    MOV AH,9
    INT 21H
    
    MOV CX,6 ;����6��
    LEA BX,BUF ;BXָ��BUF
LL:  ;������ȷʱѭ��
    MOV AH,1
    INT 21H  ;1�Ź�������һ���ַ�
    ;�ж��ַ��Ƿ�Ϸ�
    CMP AL,30H
    JB  ERR     ;С��0����ERR
    CMP AL,39H
    JA  ERR     ;����9��ERR
    SUB AL,30H ;תBCD
    MOV [BX],AL;�Ͷ�Ӧ�洢��Ԫ
    INC BX		;BX--��ָ����һ���洢��Ԫ
    LOOP LL     ;ѭ������
	JMP NEXT	;ѭ��������������һ��
ERR:
	LEA DX,STR0
	MOV AH,9
	INT 21H   ;�������
	JMP START ;���ʼ	����������
	
NEXT:
	;ȡ�ַ���ÿ�����ַ�ƴ��һ����λ��������λ��ʮλ������λ�Ǹ�λ
	LEA BX,BUF
	ADD BX,5 ;ָ�����һ����Ԫ
	MOV AL,[BX]
	MOV CL,4   ;��λŲ�����λ
	SHL AL,CL
	DEC BX
	OR  AL,[BX];���ϵ���λƴ����
	MOV NUM1,AL;��NUM1
	DEC BX

	MOV AL,[BX]
	MOV CL,4   ;��λŲ�����λ
	SHL AL,CL
	DEC BX
	OR  AL,[BX];���ϵ���λƴ����
	MOV NUM2,AL;��NUM2
	DEC BX
	
	MOV AL,[BX]
	MOV CL,4   ;��λŲ�����λ
	SHL AL,CL
	DEC BX
	OR  AL,[BX];���ϵ���λƴ����
	MOV NUM3,AL;��NUM3
	
	;���SUM
	MOV AX,0
	ADD AL,NUM1
	DAA    ;���BCD����
	ADC AH,0 ;���Ͻ�λ

	ADD AL,NUM2
	DAA    ;���BCD����
	ADC AH,0 ;���Ͻ�λ
	
	ADD AL,NUM3
	DAA    ;���BCD����
	ADC AH,0 ;���Ͻ�λ
	
	MOV BX,AX ;��BX  BH����ǽ�λ��BL�汾�غ�
	
	;����
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H
	;��ʾ��ʾ��Ϣ
	LEA DX,STR2
	MOV AH,9
	INT 21H
	;��ʾSUM�����ַ���ʾ
	XCHG BL,BH          ;��ʾ��λ
	CALL DISP   ;������ʾ
	XCHG BL,BH          ;��ʾ��λ
	CALL DISP   ;������ʾ	
	
	;�ȴ�С
	MOV AL,NUM1
	MOV BL,NUM2
	MOV CL,NUM3
	
	CMP AL,BL ;AL�����
	JA  Z0     
	XCHG AL,BL;����AL��BL
Z0:
	CMP AL,CL;AL�����
	JA Z1
	XCHG AL,CL;���򽻻�AL,CL
Z1:        
	CMP BL,CL;BL�����
	JA Z2
	XCHG BL,CL	;���򽻻�BL,CL
Z2:
	;���潻����Ľ��
	MOV NUM1,AL
	MOV NUM2,BL
	MOV NUM3,CL 
	;����
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H
	;��ʾ��ʾ��Ϣ
	LEA DX,STR3
	MOV AH,9
	INT 21H
	;��ʾ������������Ӵ�С
	;���NUM1
	MOV BL,NUM1
	CALL DISP   
	;���һ���ո񣬺�NUM2
	MOV DL,' '
	MOV AH,2
	INT 21H   
	MOV BL,NUM2
	CALL DISP   
	;���һ���ո��NUM3
	MOV DL,' '
	MOV AH,2
	INT 21H   
	MOV BL,NUM3
	CALL DISP   
	;���л���
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H  	
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H  	 
	;ѭ�������������	 
	JMP AGA
	  	  
    MOV AH,4CH
    INT 21H
DISP PROC  ;��ڲ���BL
	MOV CL,4
	MOV DL,BL
	SHR DL,CL	;����4λ�������λ��Ӧ���ַ�
	OR  DL,30H;תASCII
	MOV AH,2
	INT 21H   ;���
	
	MOV DL,BL
	AND DL,0FH;���θ���λ�������λ��Ӧ���ַ�
	OR  DL,30H;תASCII
	MOV AH,2
	INT 21H   ;���
	RET			;�ӳ������
DISP ENDP
CODES ENDS
    END START

