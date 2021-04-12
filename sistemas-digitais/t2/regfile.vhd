library ieee;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- Tentativas:
-- 14056 (5.2)
-- 14058 (5.2)
-- 14060 (9.6)


entity regfile is
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
end regfile;


architecture regfile_arch of regfile is
  type register_type is array(0 to regn - 1) of bit_vector(wordSize - 1 downto 0);

  signal zeros: bit_vector(wordSize - 1 downto 0) := (others => '0');
  -- signal reg: register_type := (others => zeros);
begin

end architecture;