.data			;数据段
a: .word 1,2,3,4,5,6,7,8 
b: .word 2
c: .space 64 

; for(int i = 0; i < 8; i ++)	c[i] = a[i] * b;

.text			;代码段
l.d f1,b(r0)	; f1 --- 常数	解决l.d cvt.d.l数据相关
daddi r1,r0,a 	; r1 --- &a[i] a数组指针
daddi r2,r0,c	; r2 --- &c[i] b数组指针
daddi r3,r0,8	; cnt 记数
cvt.d.l f1,f1	; 转浮点

Loop:
	l.d f5,0(r1)	; 读取浮点,填补空转
	l.d f6,0(r2)
	l.d f7,8(r1)
	l.d f8,8(r2)
	l.d f9,16(r1)
	l.d f10,16(r2)
	l.d f11,24(r1)
	l.d f12,24(r2)
	
	mul.d f6,f5,f1	; 浮点乘,填补空转
	mul.d f8,f7,f1
	mul.d f10,f9,f1
	mul.d f12,f11,f1
	
	daddi r3,r3,-4	; 填补空转，同时还解决了r3数据相关
	
	s.d f6,0(r2)	; 存浮点
	s.d f8,8(r2)
	s.d f10,16(r2)
	s.d f12,24(r2)
					
	daddi r1,r1,32	; 用两个daddi填补空转
	daddi r2,r2,32
	bnez r3,Loop

halt