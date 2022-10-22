ori $1,$0,0x7f00 	# ctrl寄存器地址
ori $2,$0,0x7f04	# preset寄存器地址
ori $3,$0,0x7F08	# count寄存器地址
ori $4,$0,0x7F0C	# IPD输入设备地址
ori $5,$0,0x7F10	# OPD preData输出设备初值寄存器地址
ori $6,$0,0x7F14	# OPD curData输出设备当前值寄存器地址
lw $7,0($4)		# 从输入设备获取当前的输入值
sw $7,0($5)		# 把当前输入值保存到输出设备初值寄存器中
sw $7,0($6)		# 把当前输入值保存到输出设备当前值寄存器中
ori $12,$0,0x0401	# setSR 100_0000_0001设置sr寄存器的值（准备好值）
mtc0 $12,$12		# 把gpr12号寄存器内容写入到cp0的sr寄存器中（完成设置）
mfc0 $21,$15		# 获取cp0中prid寄存器的值，写入gpr21号寄存器
ori $13,$0,0x000a	# 10 倒计时（准备好初值）
ori $9, $0, 0x0009	# ctrl控制位 1001 （准备好值）
sw $13,0($2)		# 把倒计时初值10存入preset寄存器（完成设置）
sw $13,0($3)		# 把倒计时初值10存入count寄存器 （完成设置）
sw $9,0($1)		# 设置计时器的ctrl寄存器的标志位 （完成设置）
loop:j loop		# 死循环
