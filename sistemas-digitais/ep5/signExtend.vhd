--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #22754 (10)
--------------------------------------------------------------------------------


library IEEE;
use IEEE.numeric_bit.all;

entity signExtend is 
  port(
    i: in bit_vector(31 downto 0);
    o: out bit_vector(63 downto 0)
  );
end signExtend;

architecture signExtend_arch of signExtend is
  signal opcode: bit_vector(4 downto 0);
begin
  opcode <= i(31 downto 27);
  with opcode select
    o <= 
      bit_vector(resize(signed(i(25 downto 0)), 64)) when "00010",
      bit_vector(resize(signed(i(23 downto 5)), 64)) when "10110",
      bit_vector(resize(signed(i(20 downto 12)), 64)) when "11111",
      bit_vector(to_signed(0, 64)) when others; 
end architecture;