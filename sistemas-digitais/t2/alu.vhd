library ieee;
-- use ieee.numeric_std.all;
use ieee.numeric_bit.all;

-- Tentativas:
-- 14110 (falha)
-- 14137 (6,4)
-- 14141 (7,1)


entity alu is
  generic(
    size: natural := 10 -- bit size
  );

  port(
    A, B: in bit_vector(size-1 downto 0); --inputs
    F: out bit_vector(size-1 downto 0); -- outputs
    S: in bit_vector(3 downto 0); -- op selection
    Z: out bit; -- zero flag
    Ov: out bit; -- overflow flag
    Co: out bit -- carry out
  );
end entity alu;

architecture alu_arch of alu is
  signal zeros: bit_vector(size downto 0) := (others => '0');
  signal signed_A, signed_B, signed_F: signed(size downto 0) := (others => '0');
  signal SS: bit_vector(size - 1 downto 0) := (others => '0');
  -- signal signed_A, signed_B, signed_F: bit_vector(size downto 0) := (others => '0');
begin

end architecture;