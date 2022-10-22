;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码  
    ;字符串，存储输入的字符
    STRING DB 30 
     	   DB ?
     	   DB 30 DUP (?)
    ;提示信息
    WARN DB 10,'Input error,Please input again;',10,'$'
    HINT DB 'Please input a string:',10,'$'
    RESULT DB 10,'Result is:',10,'$'
    CHOICE DB 10,'continue or not?(Y/N)',10,'$'
    ;换行
    NEWLINE DB 13,10,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
RESTORE:
	;显示输入提示
	MOV AH,9
	LEA DX,HINT
	INT 21H
	;读取字符串
	MOV AH,10
	LEA DX,STRING
	INT 21H
	;取实际字符数，即偏移地址
	MOV BL,STRING+1
	MOV BH,0
	;取字符串基地址
	LEA SI,STRING+2
	MOV BYTE PTR [SI+BX],'$'
	;偏移地址放到CX寄存器
	MOV CX,BX
	;BL寄存器存2
	MOV BL,2
	
CHECK:	;检查当前字符是否合法,‘a’---'z',不合法就跳转
	CMP STRING[BX],'a'
	JL ERROR
	CMP STRING[BX],'z'
	JG ERROR
	
	ADD BL,1
	LOOP CHECK	;循环检查，直到末尾
	
	MOV BL,STRING+1	;CL存循环次数，BL是偏移地址，可以偏移至字符串首个元素存储位置
	MOV BH,0
	MOV CX,BX
	MOV BL,2
	
CHANGE:	;小写转大写
	SUB STRING[BX],20H	;ascii码操作，转大写
	ADD BL,1	;偏移地址加1，因为是DB类型
	LOOP CHANGE	;循环
	
	;输出提示信息
	MOV AH,9
	LEA DX,RESULT	
	INT 21H	
 	;输出结果
	LEA DX,STRING+2
	INT 21H
	
	MOV AH,9
	;输出提示信息
	LEA DX,CHOICE
	INT 21H
	;读取字符，判断要不要继续循环程序
	MOV AH,1
	INT 21H
	
	CMP AL,'N'
	JZ EXIT	;不要就退出程序
	;否则换行，继续循环执行程序
	MOV AH,9
	MOV DX,OFFSET NEWLINE
	INT 21H
	JMP RESTORE
	
ERROR:	;错误，输出提示信息，重新输入
	MOV AH,9
	LEA DX,WARN
	INT 21H
	JMP RESTORE
	
EXIT:	;换行，退出程序
	MOV AH,9
	MOV DX,OFFSET NEWLINE
	INT 21H
    MOV AH,4CH
    INT 21H
    
    
CODES ENDS
    END START