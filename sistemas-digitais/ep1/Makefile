.DEFAULT_GOAL := all


all:
  ghdl -a mmc.vhdl
  ghdl -a mmc_tb.vhdl
  ghdl -r mmc_tb --vcd=mmc.vcd
