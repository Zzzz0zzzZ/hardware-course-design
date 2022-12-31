.data			;数据段
A: .word 10
B: .word 8
C: .word 0
.text			;代码段
main:
ld r4,A(r0)		;取A的数据10到r4寄存器
ld r5,B(r0)		;取B的数据8到r5寄存器
dadd r3,r4,r5	;r4和r5寄存器相加，结果存r3
sd r3,C(r0)		;把r3寄存器内容存入内存中
halt