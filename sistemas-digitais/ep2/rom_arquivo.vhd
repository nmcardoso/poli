library IEEE;
use IEEE.numeric_bit.all;
use std.textio.all;

-- Tentativas:
-- 01: #18487 (0) - VHDL analysis error
-- 02: #18494 (10)

entity rom_arquivo is
  port (
    addr: in bit_vector(4 downto 0);
    data: out bit_vector(7 downto 0)
  );
end rom_arquivo;

architecture rom_arquivo_arch of rom_arquivo is

  type mem_type is array (0 to 31) of bit_vector(7 downto 0);

  impure function init_rom_from_file(filename: in string) return mem_type is
    file rom_file: text open read_mode is filename;
    variable file_line: line;
    variable temp_bv: bit_vector(7 downto 0);
    variable temp_mem: mem_type;
  begin
    for i in mem_type'range loop
      readline(rom_file, file_line);
      read(file_line, temp_bv);
      temp_mem(i) := temp_bv;
    end loop;
    return temp_mem;
  end function;

  signal mem: mem_type := init_rom_from_file("conteudo_rom_ativ_02_carga.dat");
  
begin

data <= mem(to_integer(unsigned(addr)));

end architecture;
