library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
  port (
    morse : in std_logic_vector(4 downto 0);
    display : out std_logic_vector(7 downto 0)
  );
end Decoder;

architecture Decoder_arch of Decoder is
begin  
  with morse select display <=
    "00111111" when "11111",  -- 0
    "00000110" when "01111",  -- 1
    "01011011" when "00111",  -- 2
    "01001111" when "00011",  -- 3
    "01100110" when "00001",  -- 4
    "01101101" when "00000",  -- 5
    "01111101" when "10000",  -- 6
    "00000111" when "11000",  -- 7
    "01111111" when "11100",  -- 8
    "01101111" when "11110",  -- 9
    "00000000" when others;
end Decoder_arch;
