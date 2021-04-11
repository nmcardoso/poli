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
  -- signed_A <= A(size - 1) & A;
  -- signed_B <= B(size - 1) & B;
  signed_a <= resize(signed(A), size + 1);
  signed_b <= resize(signed(B), size + 1);
  -- SS <= signed_F(size - 1 downto 0);
  SS <= bit_vector(signed_F(size - 1 downto 0));
  F <= signed_F(size) & SS(size-2 downto 0);

  with S select
    signed_F <= signed_A and signed_B when "0000",
      signed_A or signed_B when "0001",
      signed_A + signed_B when "0010",
      signed_A - signed_B when "0110",
      signed_A nor signed_B when others;

  Co <= signed_F(size);

  Ov <= '1' when 
    ((S = "0010") and ((signed_A > 0 and signed_B > 0 and signed(SS) < 0) or (signed_A < 0 and signed_B < 0 and signed(SS) > 0))) or
    ((S = "0110") and ((signed_A > 0 and signed_B < 0 and signed(SS) < 0) or (signed_A < 0 and signed_B > 0 and signed(SS) > 0)))
    else '0';

end architecture;