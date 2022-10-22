;默认采用ML6.11汇编程序
DATAS SEGMENT
	;定义提示信息
	CUE1 DB 'PLEASE INPUT A STRING:$'
	CUE2 DB 'PLEASE INPUT ANOTHER STRING:$'
	STRNOTICE DB 'CONTINUE OR NOT? (Y/N)$'
	STRR DB '-------------------------$'
	;定义字符串
	BUFF1 DB 10H DUP('$')
	BUFF2 DB 10H DUP('$')
	;换行
	NEWLINE DB 13,10,'$'
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    ;此处输入代码段代码
    
BBGG:
	;输出分隔线并换行
	LEA DX, STRR
    MOV AH,9
    INT 21H
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;输出提示信息
    MOV DX, OFFSET CUE1
    MOV AH, 9
    INT 21H
    ;换行
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;读入用户输的字符串
    LEA DX,BUFF1
    MOV AH, 0AH
    INT 21H
    ;换行
    LEA DX,NEWLINE
    MOV AH,9
    INT 21H
    ;输出提示信息
    LEA DX,CUE2
    MOV AH,9
    INT 21H
    ;换行
    LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    ;读入用户输的字符串
    LEA DX, BUFF2
    MOV AH, 0AH
    INT 21H
    ;换行
    MOV AH, 9
    MOV DX, OFFSET NEWLINE
    INT 21H
    ;获取两个字符串实际长度并比较
    MOV CL, BUFF1+1
    CMP CL, BUFF2+1
    ;不一样长就输出N
    JNE OUTPUT_N
    ;否则取偏移地址到字符串首个元素
    MOV SI, OFFSET BUFF1+1
    MOV DI,OFFSET BUFF2+1
    ;操作方向标志位
    CLD
    ;字符串比较指令，CX为0时结束
    REPE CMPSB
    ;全部一样就输出Y
    JE OUTPUT_Y
    
OUTPUT_N:	;换行，输出N，换行
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
OUTPUT_Y:	;换行，输出Y，换行，判断是否要继续循环运行程序
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
	;提示信息，换行
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
    JMP BBGG	;循环运行程序
EXIT:
	LEA DX, NEWLINE
    MOV AH,9
    INT 21H
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START