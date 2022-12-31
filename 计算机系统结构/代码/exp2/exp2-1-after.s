.data			;数据段
a: .word 1,2,3,4,5,6,7,8 
b: .word 2
c: .space 64 

; for(int i = 0; i < 8; i ++)	c[i] = a[i] * b;

.text			;代码段
l.d f1,b(r0)	; f1 --- 常数	解决l.d cvt.d.l数据相关
daddi r1,r0,a 	; r1 --- &a[i]
daddi r2,r0,c	; r2 --- &c[i]
daddi r3,r0,8	; cnt

cvt.d.l f1,f1

Loop:
	l.d f5,0(r1)
	l.d f6,0(r2)
	daddi r1,r1,8	; 解决l.d mul.d数据相关
	mul.d f6,f5,f1
	daddi r2,r2,8	; 解决mul.d s.d数据相关
	daddi r3,r3,-1
	s.d f6,0(r2)
	bnez r3,Loop
	
halt