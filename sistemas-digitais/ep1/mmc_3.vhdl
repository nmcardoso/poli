library IEEE;
use IEEE.numeric_bit.all;

-- tentativa 01: 



entity epmmc is
  port(
    reset, clock: in bit;
    inicia: in bit;
    A, B: in bit_vector(7 downto 0);
    fim: out bit;
    nSomas: out bit_vector(8 downto 0);
    MMC: out bit_vector(15 downto 0)
  );
end epmmc;

