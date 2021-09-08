library IEEE;
use IEEE.numeric_bit.all;
use std.textio.all;

-- Tentativas:
-- 01: #18497 (0) - VHDL analysis error
-- 02: #18505 (10)

entity rom_arquivo_generica is
  generic (
    addressSize: natural := 5;
    wordSize: natural := 8;
    datFileName: string := "conteudo_rom_ativ_02_carga.dat"
  );

  port (
    addr: in bit_vector(addressSize - 1 downto 0);
    data: out bit_vector(wordSize - 1 downto 0)
  );
end rom_arquivo_generica;

architecture rom_arquivo_generica_arch of rom_arquivo_generica is

  type mem_type is array (0 to 2 ** addressSize - 1) of bit_vector(wordSize - 1 downto 0);

  impure function init_rom_from_file(filename: in string) return mem_type is
    file rom_file: text open read_mode is filename;
    variable file_line: line;
    variable temp_bv: bit_vector(wordSize - 1 downto 0);
    variable temp_mem: mem_type;
  begin
    for i in mem_type'range loop
      readline(rom_file, file_line);
      read(file_line, temp_bv);
      temp_mem(i) := temp_bv;
    end loop;
    return temp_mem;
  end function;

  signal mem: mem_type := init_rom_from_file(datFileName);

begin

  data <= mem(to_integer(unsigned(addr)));

end architecture;