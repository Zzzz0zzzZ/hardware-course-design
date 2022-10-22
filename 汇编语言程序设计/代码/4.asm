;默认采用ML6.11汇编程序
DATAS SEGMENT
	;此处输入数据段代码  
	
	STR0 DB 0AH,0DH,'INPUT ERROR! PLEASE INPUT AGAIN!',0AH,0DH,'$' ;提示信息
	STR1 DB 'INPUT AN INTEGER (6WEI): $'	;提示信息
	BUF DB 0,0,0,0,0,0	;存储6个字符的数组
	NEWLINE DB 13,10,'$'	;换行
	STR2 DB 'SUM: $'	;提示信息
	
	NUM1 DB 0		;存第一个数
	NUM2 DB 0		;存第二个数
	NUM3 DB 0		;存第三个数
	SUM  DW 0		;存SUM和
	STR3 DB 'SORT: $'	;提示信息
DATAS ENDS

STACKS SEGMENT

STACKS ENDS
	;此处输入堆栈段代码
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:	;输错时跳转到这儿
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
AGA:    ;循环运行程序的标志
    ;显示提示信息
    LEA DX,STR1	
    MOV AH,9
    INT 21H
    
    MOV CX,6 ;输入6次
    LEA BX,BUF ;BX指向BUF
LL:  ;输入正确时循环
    MOV AH,1
    INT 21H  ;1号功能输入一个字符
    ;判断字符是否合法
    CMP AL,30H
    JB  ERR     ;小于0就跳ERR
    CMP AL,39H
    JA  ERR     ;大于9跳ERR
    SUB AL,30H ;转BCD
    MOV [BX],AL;送对应存储单元
    INC BX		;BX--，指向下一个存储单元
    LOOP LL     ;循环起来
	JMP NEXT	;循环结束，进行下一步
ERR:
	LEA DX,STR0
	MOV AH,9
	INT 21H   ;输出错误
	JMP START ;跳最开始	，重新输入
	
NEXT:
	;取字符，每两个字符拼成一个两位数，高四位是十位，低四位是个位
	LEA BX,BUF
	ADD BX,5 ;指向最后一个单元
	MOV AL,[BX]
	MOV CL,4   ;高位挪入高四位
	SHL AL,CL
	DEC BX
	OR  AL,[BX];或上低四位拼起来
	MOV NUM1,AL;送NUM1
	DEC BX

	MOV AL,[BX]
	MOV CL,4   ;高位挪入高四位
	SHL AL,CL
	DEC BX
	OR  AL,[BX];或上低四位拼起来
	MOV NUM2,AL;送NUM2
	DEC BX
	
	MOV AL,[BX]
	MOV CL,4   ;高位挪入高四位
	SHL AL,CL
	DEC BX
	OR  AL,[BX];或上低四位拼起来
	MOV NUM3,AL;送NUM3
	
	;求和SUM
	MOV AX,0
	ADD AL,NUM1
	DAA    ;组合BCD调整
	ADC AH,0 ;加上进位

	ADD AL,NUM2
	DAA    ;组合BCD调整
	ADC AH,0 ;加上进位
	
	ADD AL,NUM3
	DAA    ;组合BCD调整
	ADC AH,0 ;加上进位
	
	MOV BX,AX ;送BX  BH存的是进位，BL存本地和
	
	;换行
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H
	;显示提示信息
	LEA DX,STR2
	MOV AH,9
	INT 21H
	;显示SUM，按字符显示
	XCHG BL,BH          ;显示高位
	CALL DISP   ;调用显示
	XCHG BL,BH          ;显示低位
	CALL DISP   ;调用显示	
	
	;比大小
	MOV AL,NUM1
	MOV BL,NUM2
	MOV CL,NUM3
	
	CMP AL,BL ;AL大就跳
	JA  Z0     
	XCHG AL,BL;交换AL和BL
Z0:
	CMP AL,CL;AL大就跳
	JA Z1
	XCHG AL,CL;否则交换AL,CL
Z1:        
	CMP BL,CL;BL大就跳
	JA Z2
	XCHG BL,CL	;否则交换BL,CL
Z2:
	;保存交换完的结果
	MOV NUM1,AL
	MOV NUM2,BL
	MOV NUM3,CL 
	;换行
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H
	;显示提示信息
	LEA DX,STR3
	MOV AH,9
	INT 21H
	;显示输出三个数，从大到小
	;输出NUM1
	MOV BL,NUM1
	CALL DISP   
	;输出一个空格，和NUM2
	MOV DL,' '
	MOV AH,2
	INT 21H   
	MOV BL,NUM2
	CALL DISP   
	;输出一个空格和NUM3
	MOV DL,' '
	MOV AH,2
	INT 21H   
	MOV BL,NUM3
	CALL DISP   
	;换行换行
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H  	
	LEA DX,NEWLINE
	MOV AH,9
	INT 21H  	 
	;循环运行这个程序	 
	JMP AGA
	  	  
    MOV AH,4CH
    INT 21H
DISP PROC  ;入口参数BL
	MOV CL,4
	MOV DL,BL
	SHR DL,CL	;右移4位，输出高位对应的字符
	OR  DL,30H;转ASCII
	MOV AH,2
	INT 21H   ;输出
	
	MOV DL,BL
	AND DL,0FH;屏蔽高四位，输出低位对应的字符
	OR  DL,30H;转ASCII
	MOV AH,2
	INT 21H   ;输出
	RET			;子程序结束
DISP ENDP
CODES ENDS
    END START

