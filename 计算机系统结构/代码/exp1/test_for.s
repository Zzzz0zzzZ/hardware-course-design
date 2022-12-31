
.data  
a: .space 48  
b: .word 10,11,12,13,0,1  
c: .word 1,2,3,4,5,6  
 
.text 
;initialize registers  
daddi r1,r0,a  	; 把a,b,c数组的起始地址存入r1,r2,r3寄存器中
daddi r2,r0,b  
daddi r3,r0,c  
daddi r4,r0,6  	; 计数器
Loop: lw r5,0(r1) ; element of a	; 在对应的地址取数a,b,c 
	lw r6,0(r2) ; element of b 
	lw r7,0(r3) ; element of c          
	dadd r8,r5,r6 ; a[i] + b[i]     ; a+b
	dadd r9,r7,r8 ; a[i] = a[i] + b[i] + c[i];	; a+b+c            
	sw r9,0(r1) ; store value in a[i]           ; 把结果写回a数组对应位置
	daddi r1,r1,8 ; increment memory pointers    ; 地址增加，即下一个访问的地址        
	daddi r2,r2,8            
	daddi r3,r3,8            
	daddi r4,r4,-1 ; i++            ; 计数器改变，记录循环剩余次数
	bnez r4,Loop              		; 决定是否停止循环
end: halt							; 程序结束