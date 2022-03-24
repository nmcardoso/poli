library IEEE;
use IEEE.numeric_bit.all;

entity exp is
  port(
    A: in bit;
    B: in bit;
    Y: out bit
  );
end entity;

architecture exp_arch of exp is
  signal s1, s2, s3, s4, s5: bit;
begin
  s1 <= not A;
  s2 <= not B;
  s3 <= A and s2;
  s4 <= s1 and B;
  s5 <= s3 or s4;
  Y <= s5 nand A;
end exp_arch;
