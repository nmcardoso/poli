library ieee;
use ieee.numeric_std.all;
use std.textio.all;

-- Tentativas:
-- #13962
-- #13963 (sucesso)

entity rom is
  port(
    addr: in  bit_vector(7 downto 0);
    data: out bit_vector(31 downto 0)
  );
end rom;

architecture rom_arch of rom is
  type RomType is array(0 to 255) of bit_vector(31 downto 0);

  impure function init_rom_from_file(filename: in string) return RomType is
    file rom_file: text is in filename;
    variable file_line: line;
    variable rom_data: RomType;
  begin
    for i in RomType'range loop
      readline(rom_file, file_line);
      read(file_line, rom_data(i));
    end loop;
    return rom_data;
  end function;

  function bv_to_natural(bv: in bit_vector) return natural is
    variable result : natural := 0;
  begin
    for index in bv'range loop
      result := result * 2 + bit'pos(bv(index));
    end loop;
    return result;
  end bv_to_natural;
