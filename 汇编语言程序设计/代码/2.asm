;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ���  
    ;�ַ������洢������ַ�
    STRING DB 30 
     	   DB ?
     	   DB 30 DUP (?)
    ;��ʾ��Ϣ
    WARN DB 10,'Input error,Please input again;',10,'$'
    HINT DB 'Please input a string:',10,'$'
    RESULT DB 10,'Result is:',10,'$'
    CHOICE DB 10,'continue or not?(Y/N)',10,'$'
    ;����
    NEWLINE DB 13,10,'$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
RESTORE:
	;��ʾ������ʾ
	MOV AH,9
	LEA DX,HINT
	INT 21H
	;��ȡ�ַ���
	MOV AH,10
	LEA DX,STRING
	INT 21H
	;ȡʵ���ַ�������ƫ�Ƶ�ַ
	MOV BL,STRING+1
	MOV BH,0
	;ȡ�ַ�������ַ
	LEA SI,STRING+2
	MOV BYTE PTR [SI+BX],'$'
	;ƫ�Ƶ�ַ�ŵ�CX�Ĵ���
	MOV CX,BX
	;BL�Ĵ�����2
	MOV BL,2
	
CHECK:	;��鵱ǰ�ַ��Ƿ�Ϸ�,��a��---'z',���Ϸ�����ת
	CMP STRING[BX],'a'
	JL ERROR
	CMP STRING[BX],'z'
	JG ERROR
	
	ADD BL,1
	LOOP CHECK	;ѭ����飬ֱ��ĩβ
	
	MOV BL,STRING+1	;CL��ѭ��������BL��ƫ�Ƶ�ַ������ƫ�����ַ����׸�Ԫ�ش洢λ��
	MOV BH,0
	MOV CX,BX
	MOV BL,2
	
CHANGE:	;Сдת��д
	SUB STRING[BX],20H	;ascii�������ת��д
	ADD BL,1	;ƫ�Ƶ�ַ��1����Ϊ��DB����
	LOOP CHANGE	;ѭ��
	
	;�����ʾ��Ϣ
	MOV AH,9
	LEA DX,RESULT	
	INT 21H	
 	;������
	LEA DX,STRING+2
	INT 21H
	
	MOV AH,9
	;�����ʾ��Ϣ
	LEA DX,CHOICE
	INT 21H
	;��ȡ�ַ����ж�Ҫ��Ҫ����ѭ������
	MOV AH,1
	INT 21H
	
	CMP AL,'N'
	JZ EXIT	;��Ҫ���˳�����
	;�����У�����ѭ��ִ�г���
	MOV AH,9
	MOV DX,OFFSET NEWLINE
	INT 21H
	JMP RESTORE
	
ERROR:	;���������ʾ��Ϣ����������
	MOV AH,9
	LEA DX,WARN
	INT 21H
	JMP RESTORE
	
EXIT:	;���У��˳�����
	MOV AH,9
	MOV DX,OFFSET NEWLINE
	INT 21H
    MOV AH,4CH
    INT 21H
    
    
CODES ENDS
    END START