library IEEE;
use IEEE.numeric_bit.all;

-- Tentativas:
-- 01: #18486 (10)

entity rom_simples is
  port (
    addr: in bit_vector(4 downto 0);
    data: out bit_vector(7 downto 0)
  );
end rom_simples;

architecture rom_simples_arch of rom_simples is

  type mem_type is array (0 to 31) of bit_vector(7 downto 0);
  signal mem: mem_type := (
    0  => "00000000",
    1  => "00000011",
    2  => "11000000",
    3  => "00001100",
    4  => "00110000",
    5  => "01010101",
    6  => "10101010",
    7  => "11111111",
    8  => "11100000",
    9  => "11100111",
    10 => "00000111",
    11 => "00011000",
    12 => "11000011",
    13 => "00111100",
    14 => "11110000",
    15 => "00001111",
    16 => "11101101",
    17 => "10001010",
    18 => "00100100",
    19 => "01010101",
    20 => "01001100",
    21 => "01000100",
    22 => "01110011",
    23 => "01011101",
    24 => "11100101",
    25 => "01111001",
    26 => "01010000",
    27 => "01000011",
    28 => "01010011",
    29 => "10110000",
    30 => "11011110",
    31 => "00110001",
    others => "00000000"
  );
  
begin

data <= mem(to_integer(unsigned(addr)));

end architecture;
