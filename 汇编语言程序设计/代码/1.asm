;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
	;������ʾ��Ϣ
	CUE1 DB 'PLEASE INPUT A STRING:$'
	CUE2 DB 'PLEASE INPUT ANOTHER STRING:$'
	STRNOTICE DB 'CONTINUE OR NOT? (Y/N)$'
	STRR DB '-------------------------$'
	;�����ַ���
	BUFF1 DB 10H DUP('$')
	BUFF2 DB 10H DUP('$')
	;����
	NEWLINE DB 13,10,'$'
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    ;�˴��������δ���
    
BBGG:
	;����ָ��߲�����
	LEA DX, STRR
    MOV AH,9
    INT 21H
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;�����ʾ��Ϣ
    MOV DX, OFFSET CUE1
    MOV AH, 9
    INT 21H
    ;����
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;�����û�����ַ���
    LEA DX,BUFF1
    MOV AH, 0AH
    INT 21H
    ;����
    LEA DX,NEWLINE
    MOV AH,9
    INT 21H
    ;�����ʾ��Ϣ
    LEA DX,CUE2
    MOV AH,9
    INT 21H
    ;����
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;�����û�����ַ���
    LEA DX, BUFF2
    MOV AH, 0AH
    INT 21H
    ;����
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    INT 21H
    ;��ȡ�����ַ���ʵ�ʳ��Ȳ��Ƚ�
    MOV CL, BUFF1+1
    CMP CL, BUFF2+1
    ;��һ���������N
    JNE OUTPUT_N
    ;����ȡƫ�Ƶ�ַ���ַ����׸�Ԫ��
    MOV SI, OFFSET BUFF1+1
    MOV DI,OFFSET BUFF2+1
    ;���������־λ
    CLD
    ;�ַ����Ƚ�ָ�CXΪ0ʱ����
    REPE CMPSB
    ;ȫ��һ�������Y
    JE OUTPUT_Y
    
OUTPUT_N:	;���У����N������
	MOV AH,9
	MOV DX, OFFSET NEWLINE
	INT 21H
	
	MOV AH,2
	MOV DL,'N'
	INT 21H
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    
	JMP JUDGEAGAIN
OUTPUT_Y:	;���У����Y�����У��ж��Ƿ�Ҫ����ѭ�����г���
	MOV AH,9
	MOV DX,OFFSET NEWLINE
	INT 21H
	
	MOV AH,2
	MOV DL,'Y'
	INT 21H
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    
	JMP JUDGEAGAIN
    
    
JUDGEAGAIN:
	;��ʾ��Ϣ������
	LEA DX,STRNOTICE
    MOV AH,09H
    INT 21H
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    
    MOV AH,1
    INT 21H
    CMP AL,'N'
    JZ EXIT
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    JMP BBGG	;ѭ�����г���
EXIT:
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START