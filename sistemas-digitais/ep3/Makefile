reg:
	ghdl -a --std=08 reg.vhd
	ghdl -a --std=08 reg_tb.vhd
	ghdl -r --std=08 reg_tb --wave=reg.ghw

regfile:
	ghdl -c --std=08 regfile.vhd -e regfile regfile_arch
	ghdl -a -g --std=08 regfile.vhd
	ghdl -a -g --std=08 regfile_tb.vhd
	ghdl -r --std=08 --ieee=synopsys regfile_tb --wave=regfile.ghw

calc:
	ghdl -a -g --std=08 calc.vhd
	ghdl -a -g --std=08 calc_tb.vhd
	ghdl -r --std=08 calc_tb --wave=calc.ghw