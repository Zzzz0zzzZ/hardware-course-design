;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码  
    ;换行
    NEWLINE DB 13,10,'$'
    ;提示信息
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
    ;定义变量
    NUM DW 2 DUP(?)
    STRINN DB 5,?,5 DUP('?')
    A DW ?
    D DW ?
    F DW ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DW 20H DUP(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

MAIN PROC FAR
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
   
BBGG:
	;输出提示信息
	LEA DX,STRHELLO
	MOV AH,09H
	INT 21H
REIN:	;第一个数
 	;输出提示str1
    LEA DX,STR1
    MOV AH,09H
    INT 21H
    ;调用input函数，保存结果
    CALL INPUT	;输入错误CL置为0ffh
    ;如果CL是0ffh，说明输入错误，重新输入
    CMP CL,0FFH
    JZ REIN
    MOV AX,NUM
    MOV NUM+2,AX
REINN:	;第二个数
    ;输出提示str2
    LEA DX,STR2
    MOV AH,09H
    INT 21H
    ;调用input函数，保存结果
    CALL INPUT
    CMP CL,0FFH
    JZ REINN
    ;提示信息
    LEA DX,STR3;
    MOV AH,09H
    INT 21H
    ;转二进制，入口参数bx
    MOV BX,NUM+2
    CALL BIN
    ;提示信息
    LEA DX,STR4
    MOV AH,09H
    INT 21H
    ;转二进制，入口参数bx
    MOV BX,NUM
    CALL BIN
    ;提示信息
    LEA DX,STR5
    MOV AH,09H
    INT 21H
    ;入口参数bx，判断是否为偶数
    MOV BX,NUM+2
    CALL OUSHU
    ;提示信息
    LEA DX,STR6
    MOV AH,09H
    INT 21H
    ;入口参数bx，判断是否为偶数
    MOV BX,NUM
    CALL OUSHU
    
 	;输出程序结束语句str7
    LEA DX,STR7
    MOV AH,09H
    INT 21H
    
    ;判断是否要继续循环执行程序，Y就继续，N就退出程序
    LEA DX,STRCONTINUE
    MOV AH,09H
    INT 21H
    ;接收一个字符，用户是否要继续循环执行程序
    MOV AH,1
    INT 21H
    CMP AL,'N'
    JZ EXIT	;N就跳EXIT，程序结束
    JMP BBGG	;否则循环执行程序
EXIT:
	;换行，程序结束
	MOV DX,OFFSET NEWLINE
	MOV AH,9
	INT 21H
    MOV AH,4CH
    INT 21H
MAIN ENDP

;输入函数，接收输入字符串，并判断是否合法
INPUT PROC NEAR
	;接收输入字符串
	LEA DX,STRINN;取str基地址，用于存放输入的字符串
	MOV AH,0AH
	INT 21H
	
	LEA SI,STRINN+2	;获得偏移地址
	MOV CX,4	;计数器，循环用
	MOV DX,0	;结果数组，清零
A1:
	;保护记录循环次数的CX
	PUSH CX
	;读一个字符，判断是否为小写字母，不合法就跳A4
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
	SUB AL,30H;	;转bcd
	CBW			;扩展AL->AX
	ADD DX,AX	
	CMP CX,1	;如果最后一次循环，则移位不执行，直接加
	JZ A3	
	;左移4位
	MOV CL,4	
	SHL DX,CL
A3:
	INC SI	;偏移1位往后  DB类型
	POP CX
	LOOP A1
	MOV CL,0
	MOV NUM,DX	
	JMP A5
A4:	;把CL置位0FFH， 代表输入不合法，需要重新输入
	POP CX
	MOV CL,0FFH
	MOV DX,0
	MOV NUM,DX
A5:
	RET
INPUT ENDP

;转二进制
BIN PROC NEAR
	MOV CX,16
	MOV DX,0
B1:
	MOV AX,0
  	SHL BX,1
  	ADC AL,0                   ;循环左移1位，将CF表示位最高位2进制数
  	PUSH CX                    ;保护CX
 	PUSH BX                    ;保护BX
 	ADD AL,30H				;转ascii
 	MOV CX,1				;计数
 	MOV BL,07H                ;显示输出
 	MOV BH,0
 	MOV AH,09H
 	INT 10H					
 	MOV AH,03H                
 	INT 10H
 	INC DL                   ;有移，DL++
 	MOV AH,02H               
 	INT 10H					;输出一个字符
 	POP BX					;恢复BX
 	POP CX					;恢复CX
 	LOOP B1
  
  RET

BIN ENDP

;判断是否为偶数
OUSHU PROC NEAR          
  PUSH BX                  ;保护BX
  ;取bcd末位
  AND BX,0001H             
  MOV CX,8
C1:
  CMP BL,0H                ;判断末尾是不是0，是就是偶数
  JZ C2						;是偶数跳C2，继续输出十进制
  MOV AH,02H               ;不是偶数输出’NO’
  MOV DL,'N'
  INT 21H
  MOV AH,02H
  MOV DL,'O'
  INT 21H
  POP BX
  JMP C3	;跳子程序结束

C2:
  POP BX
  MOV CX,5
  MOV AX,BX
  MOV BX,10
C4:
  MOV DX,0
  DIV BX                    ;除以10
  ADD DL,30H		;转bcd
  PUSH DX			;余数入栈
  LOOP C4			;不断循环这个过程
  MOV CX,5
C5:					;取栈顶，出栈一个
  POP DX	
  MOV AH,02H                ;按字符输出
  INT 21H		
  LOOP C5			;循环输出字符，输出完成就是十进制数
C3:
  RET
OUSHU ENDP

    
    
    
CODES ENDS
    END MAIN