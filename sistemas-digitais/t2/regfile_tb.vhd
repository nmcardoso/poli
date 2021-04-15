library ieee;
use ieee.numeric_bit.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity regfile_tb is
end regfile_tb;

architecture regfile_tb_arch of regfile_tb is
  component regfile is
    generic(
      regn: natural := 32;
      wordSize: natural := 64
    );

    port(
      clock: in bit;
      reset: in bit;
      regWrite: in bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
      d: in bit_vector(wordSize - 1 downto 0);
      q1, q2: out bit_vector(wordSize - 1 downto 0)
    );
  end component;

begin
end regfile_tb_arch;