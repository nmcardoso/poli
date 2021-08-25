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


architecture mmc_arch of epmmc is
  type state_type is (idle, op, lastop);
  signal state_reg, state_next: state_type;
  signal a_reg, b_reg: bit_vector(15 downto 0);
  signal a_next, b_next: bit_vector(15 downto 0);
  signal nSomas_reg: bit_vector(8 downto 0);
  signal nSomas_next: bit_vector(8 downto 0);
  signal acc_a_reg, acc_b_reg: bit_vector(8 downto 0);






begin

end architecture;