all: rom_arquivo

rom_simples: 
	ghdl -a --std=08 rom_simples.vhd
	ghdl -a --std=08 rom_simples_tb.vhd
	ghdl -r --std=08 rom_simples_tb --vcd=rom_simples.vcd

