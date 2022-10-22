;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码  
    ;提示信息
    STR1 DB 0AH,0DH,'PLEASE ENTER THE SCORE ONE BY ONE (0~100)',0AH,0DH,'$'
    STR2 DB 'SCORE GIVEN BY NO.$'
    STR3 DB 0AH,0DH,'FINAL SCORE',0AH,0DH,'$'
    STR4 DB 'SCORE SUM $'
    WARNN DB 'NUMBER ILLEGAL, PLEASE INPUT ALL THE NUMBER AGAIN',0AH,0DH,'$'
    ;换行
    NEWLINE DB 13,10,'$'
    ;存储输入的分数
    SCORE_EACH DB 30H
    	       DB 0
    	       DB 30H DUP('$')
    ;临时变量
    SCORE_INT DW 0
    ;总和
    SCORE_SUM DW 0
    ;最小值
    SCORE_MIN DW 100
    ;最大值
    SCORE_MAX DW 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DW 40H DUP(0)
    TOP LABEL WORD;指向栈顶
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    
START:
    MOV AX,DATAS
    MOV DS,AX
    MOV ES,AX
    ;此处输入代码段代码
   
ERR_AGA:			;输入错误时返回
	;重置最大值、最小值、总和
	MOV AX,0
	MOV SCORE_SUM,AX
	MOV SCORE_MAX,AX
	MOV AX,100
	MOV SCORE_MIN,AX
    
    ;'PLEASE ENTER THE SCORE ONE BY ONE (0~100)'   STR1
    LEA DX, STR1
    MOV AH, 09H
    INT 21H
    MOV CX, 07H	;循环计数
    MOV BX, 01H	;评委计数
    
INN_7:				;循环读7个分数
	;清空tmp得分
	MOV SCORE_INT, 0	
	;'SCORE GIVEN BY NO.$'
	LEA DX, STR2
	MOV AH, 09H
	INT 21H
	; 1---7 显示评委编号
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
	
	; 输入第i个评委的打分
	LEA DX, SCORE_EACH
	MOV AH,0AH
	INT 21H
	;换行
	LEA DX, NEWLINE
	MOV AH,09H
	INT 21H
	;判断合法与否，不合法重新输入,合法就存加和
	CALL LEGAL_JUDGE
	
	LOOP INN_7	;循环
	
	
RESULTT:	;计算平均数并显示
	;'SCORE SUM'提示信息
	LEA DX,STR4
	MOV AH,09H
	INT 21H
	MOV DX,':'
	MOV AH,02H
	INT 21H
	MOV DX,' '
	MOV AH,02H
	INT 21H
	;计算平均数
	;清空DX
	XOR DX,DX
	;计算、生成被除数
	MOV AX,SCORE_SUM
	SUB AX,SCORE_MAX
	SUB AX,SCORE_MIN
	;生成除数
	MOV BX,5
	;进行除法
	DIV BX
	;保护余数
	PUSH DX
	;清空BX，生成除数10，用于获取商的单个字符
	XOR BX,BX
	MOV BX,10
	XOR CL,CL
INT_TST:
	;每次商除以10取余数，转换ascii码并入栈，同时记录次数
	XOR DX,DX
	DIV BX
	ADD DL,30H
	PUSH DX
	INC CL
	CMP AX,0
	JNE INT_TST  ;AX不为0就继续循环
	
SHOWW:
	;根据记录的次数循环输出每一位字符（平均数整数部分），字符从栈顶获取
	POP DX
	MOV AH,02H
	INT 21H
	LOOP SHOWW
	;计算并显示小数部分
	;显示一个小数点
	MOV DX,'.'
	INT 21H
	;获得之前除法的余数，对其乘以10再除以2，相当于乘以2，即左移一位
	POP DX
	SAL DX,1
	;转换ascii码
	ADD DX,30H
	;输出该字符
	INT 21H
	JMP EXITT
	
LEGAL_JUDGE PROC 	;判断输入是否合法，合法就组装成三位数，然后更新SCORE_SUM，SCORE_MIN，SCORE_MAX
	PUSH CX	;保护CX
	;判断分数是否为3位及以下
	MOV AL,SCORE_EACH+1
	CMP AL,03H
	JA ERR_IN	;不合法，重新输入
	;字符串首个元素位置，即SI需要偏移2
	MOV SI,2
	;获得字符串实际长度
	MOV CL,SCORE_EACH+1
NEXT_C:
	
	XOR AX,AX	;清空AX
	MOV AL,SCORE_EACH[SI]	;当前元素送AX
	;判断是否在0-9之间
	CMP AL,'0'	
	JB ERR_IN
	CMP AL,'9'
	JA ERR_IN
	;如果输入没错,则将str转为int，即组装成3位数
	;转bcd
	SUB AL,30H
	PUSH AX
	XOR AX,AX
	MOV AX,10
	MUL SCORE_INT
	MOV SCORE_INT,AX
	POP AX
	ADD SCORE_INT,AX
	INC SI
	LOOP NEXT_C	;循环判断&组装
P_SUM:
	;清空DX，AX
	XOR DX,DX
	XOR AX,AX
	;判断分数是否小于等于100，是就继续，否则重新输入
	MOV AX,SCORE_INT
	CMP AX,100
	JA ERR_IN
	;更新SCORE_NUM
	ADD SCORE_SUM,AX
	;判断是否需要更新最小值，是则更新
	CMP AX,SCORE_MIN
	JA UPDATE_SCMAX
	MOV SCORE_MIN,AX
	;判断是否需要更新最大值，是则更新
UPDATE_SCMAX:
	CMP AX,SCORE_MAX
	JB OVERR
	MOV SCORE_MAX,AX
OVERR:
	POP CX	;进入子程序时保护，退出时需要还原
	RET	;结束
LEGAL_JUDGE ENDP
    
    
ERR_IN:	;输出错误信息，跳转到ERR_AGA
	LEA DX,WARNN
	MOV AH,09H
	INT 21H
	
	JMP ERR_AGA
    
EXITT:
	;换行
	LEA DX,NEWLINE
	MOV AH,09H
	INT 21H
	
	JMP ERR_AGA	;使程序循环运行
	
    MOV AH,4CH
    INT 21H
    
    
CODES ENDS
    END START