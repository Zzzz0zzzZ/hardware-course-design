;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ���  
    ;��ʾ��Ϣ
    STR1 DB 0AH,0DH,'PLEASE ENTER THE SCORE ONE BY ONE (0~100)',0AH,0DH,'$'
    STR2 DB 'SCORE GIVEN BY NO.$'
    STR3 DB 0AH,0DH,'FINAL SCORE',0AH,0DH,'$'
    STR4 DB 'SCORE SUM $'
    WARNN DB 'NUMBER ILLEGAL, PLEASE INPUT ALL THE NUMBER AGAIN',0AH,0DH,'$'
    ;����
    NEWLINE DB 13,10,'$'
    ;�洢����ķ���
    SCORE_EACH DB 30H
    	       DB 0
    	       DB 30H DUP('$')
    ;��ʱ����
    SCORE_INT DW 0
    ;�ܺ�
    SCORE_SUM DW 0
    ;��Сֵ
    SCORE_MIN DW 100
    ;���ֵ
    SCORE_MAX DW 0
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    DW 40H DUP(0)
    TOP LABEL WORD;ָ��ջ��
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    ;�˴��������δ���
   
ERR_AGA:			;�������ʱ����
	;�������ֵ����Сֵ���ܺ�
	MOV AX,0
	MOV SCORE_SUM,AX
	MOV SCORE_MAX,AX
	MOV AX,100
	MOV SCORE_MIN,AX
    
    ;'PLEASE ENTER THE SCORE ONE BY ONE (0~100)'   STR1
    LEA DX, STR1
    MOV AH, 09H
    INT 21H
    MOV CX, 07H	;ѭ������
    MOV BX, 01H	;��ί����
    
INN_7:				;ѭ����7������
	;���tmp�÷�
	MOV SCORE_INT, 0	
	;'SCORE GIVEN BY NO.$'
	LEA DX, STR2
	MOV AH, 09H
	INT 21H
	; 1---7 ��ʾ��ί���
	MOV DX, BX
	ADD DX,30H
	MOV AH, 02H
	INT 21H
	MOV DX,':'
	MOV AH,02H
	INT 21H
	MOV DX,' '
	MOV AH,02H
	INT 21H
	INC BX
	
	; �����i����ί�Ĵ��
	LEA DX, SCORE_EACH
	MOV AH,0AH
	INT 21H
	;����
	LEA DX, NEWLINE
	MOV AH,09H
	INT 21H
	;�жϺϷ���񣬲��Ϸ���������,�Ϸ��ʹ�Ӻ�
	CALL LEGAL_JUDGE
	
	LOOP INN_7	;ѭ��
	
	
RESULTT:	;����ƽ��������ʾ
	;'SCORE SUM'��ʾ��Ϣ
	LEA DX,STR4
	MOV AH,09H
	INT 21H
	MOV DX,':'
	MOV AH,02H
	INT 21H
	MOV DX,' '
	MOV AH,02H
	INT 21H
	;����ƽ����
	;���DX
	XOR DX,DX
	;���㡢���ɱ�����
	MOV AX,SCORE_SUM
	SUB AX,SCORE_MAX
	SUB AX,SCORE_MIN
	;���ɳ���
	MOV BX,5
	;���г���
	DIV BX
	;��������
	PUSH DX
	;���BX�����ɳ���10�����ڻ�ȡ�̵ĵ����ַ�
	XOR BX,BX
	MOV BX,10
	XOR CL,CL
INT_TST:
	;ÿ���̳���10ȡ������ת��ascii�벢��ջ��ͬʱ��¼����
	XOR DX,DX
	DIV BX
	ADD DL,30H
	PUSH DX
	INC CL
	CMP AX,0
	JNE INT_TST  ;AX��Ϊ0�ͼ���ѭ��
	
SHOWW:
	;���ݼ�¼�Ĵ���ѭ�����ÿһλ�ַ���ƽ�����������֣����ַ���ջ����ȡ
	POP DX
	MOV AH,02H
	INT 21H
	LOOP SHOWW
	;���㲢��ʾС������
	;��ʾһ��С����
	MOV DX,'.'
	INT 21H
	;���֮ǰ�������������������10�ٳ���2���൱�ڳ���2��������һλ
	POP DX
	SAL DX,1
	;ת��ascii��
	ADD DX,30H
	;������ַ�
	INT 21H
	JMP EXITT
	
LEGAL_JUDGE PROC 	;�ж������Ƿ�Ϸ����Ϸ�����װ����λ����Ȼ�����SCORE_SUM��SCORE_MIN��SCORE_MAX
	PUSH CX	;����CX
	;�жϷ����Ƿ�Ϊ3λ������
	MOV AL,SCORE_EACH+1
	CMP AL,03H
	JA ERR_IN	;���Ϸ�����������
	;�ַ����׸�Ԫ��λ�ã���SI��Ҫƫ��2
	MOV SI,2
	;����ַ���ʵ�ʳ���
	MOV CL,SCORE_EACH+1
NEXT_C:
	
	XOR AX,AX	;���AX
	MOV AL,SCORE_EACH[SI]	;��ǰԪ����AX
	;�ж��Ƿ���0-9֮��
	CMP AL,'0'	
	JB ERR_IN
	CMP AL,'9'
	JA ERR_IN
	;�������û��,��strתΪint������װ��3λ��
	;תbcd
	SUB AL,30H
	PUSH AX
	XOR AX,AX
	MOV AX,10
	MUL SCORE_INT
	MOV SCORE_INT,AX
	POP AX
	ADD SCORE_INT,AX
	INC SI
	LOOP NEXT_C	;ѭ���ж�&��װ
P_SUM:
	;���DX��AX
	XOR DX,DX
	XOR AX,AX
	;�жϷ����Ƿ�С�ڵ���100���Ǿͼ�����������������
	MOV AX,SCORE_INT
	CMP AX,100
	JA ERR_IN
	;����SCORE_NUM
	ADD SCORE_SUM,AX
	;�ж��Ƿ���Ҫ������Сֵ���������
	CMP AX,SCORE_MIN
	JA UPDATE_SCMAX
	MOV SCORE_MIN,AX
	;�ж��Ƿ���Ҫ�������ֵ���������
UPDATE_SCMAX:
	CMP AX,SCORE_MAX
	JB OVERR
	MOV SCORE_MAX,AX
OVERR:
	POP CX	;�����ӳ���ʱ�������˳�ʱ��Ҫ��ԭ
	RET	;����
LEGAL_JUDGE ENDP
    
    
ERR_IN:	;���������Ϣ����ת��ERR_AGA
	LEA DX,WARNN
	MOV AH,09H
	INT 21H
	
	JMP ERR_AGA
    
EXITT:
	;����
	LEA DX,NEWLINE
	MOV AH,09H
	INT 21H
	
	JMP ERR_AGA	;ʹ����ѭ������
	
    MOV AH,4CH
    INT 21H
    
    
CODES ENDS
    END START