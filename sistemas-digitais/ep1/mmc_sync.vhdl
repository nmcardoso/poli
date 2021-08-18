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
  type state_type is (idle, op_a, op_b);
  signal state_reg, state_next: state_type;
begin



process(clock, reset)
begin
  if (reset='1') then
    state_reg <= idle;
  elsif (clock'event and clock='1') then
    state_reg <= state_next;
  end if;
end process;



process(state_reg, inicia, A, B, add_a, add_b)
begin
  case state_reg is
    when idle =>
      if (inicia='1') then
        if (A = B or unsigned(A) = 0 or unsigned(B) = 0) then
          state_next <= idle;
        elsif (A < B) then
          state_next <= op_a;
        else
          state_next <= op_b;
        end if;
      else
        state_next <= idle;
      end if;
  end case;
end process;


  end case;
end process;
end architecture;