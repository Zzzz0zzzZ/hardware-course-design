lui $1, 0xffff		# 加载十六进制数ffff到1号寄存器内容高位（负数）
bltzal $1, flag1	# 如果1号寄存器内容小于0，跳flag1，同时存下一条地址到31号寄存器；否则顺序执行
j jmp1			# 无条件跳转jmp1处
flag1:ori $7, $0, 6	# 6和0号寄存器进行或运算，结果存7号寄存器
j second		# 无条件跳转second处
jmp1:ori $9, $0, 9	# 9和0号寄存器进行或运算，结果存9号寄存器
second:ori $2, $0, 3	# 3和0号寄存器进行或运算，结果存2号寄存器
bltzal $2, flag2	# 如果2号寄存器内容小于0，跳flag2；同时存下一条地址到31号寄存器；否则顺序执行
j jmp2			# 无条件跳转jmp2处
flag2:ori $10, $0, 9	# 9和0号寄存器进行或运算，结果存10号寄存器
j end			# 无条件跳转end处
jmp2:ori $8, $0, 6	# 6和0号寄存器进行或运算，结果存8号寄存器
end:			# end处
