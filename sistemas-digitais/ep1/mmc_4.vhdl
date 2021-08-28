library IEEE;
use IEEE.numeric_bit.all;



entity mmc is
  port(
    reset, clock: in bit;
    inicia: in bit;
    A, B: in bit_vector(7 downto 0);
    fim: out bit;
    nSomas: out bit_vector(8 downto 0);
    MMC: out bit_vector(15 downto 0)
  );
end mmc;

architecture mmc_arch of mmc is
  type state_type is (idle, compare, a_gt_b, a_lt_b, finished);
  signal curr_state, next_state: state_type;
begin

end architecture;