all: rom_arquivo

rom_simples: 
	ghdl -a --std=08 rom_simples.vhd
	ghdl -a --std=08 rom_simples_tb.vhd
	ghdl -r --std=08 rom_simples_tb --vcd=rom_simples.vcd

rom_arquivo:
	ghdl -a --std=08 rom_arquivo.vhd
	ghdl -a --std=08 rom_arquivo_tb.vhd
	ghdl -r --std=08 rom_arquivo_tb --vcd=rom_arquivo.vcd

