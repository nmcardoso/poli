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
  signal add_a, add_b: bit_vector(15 downto 0);
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
        else
          state_next <= op;
        end if;
      else
        state_next <= idle;
      end if;
    when op =>
      if (add_a = add_b) then
        state_next <= lastop;
      else
        state_next <= op;
      end if;
    when lastop =>
      state_next <= idle;
  end case;
end process;



process(clock, reset)
begin
  if (reset='1') then
    a_reg <= (others => '0');
    b_reg <= (others => '0');
    nSomas_reg <= (others => '0');
  elsif (clock'event and clock='1') then
    a_reg <= a_next;
    b_reg <= b_next;
    nSomas_reg <= nSomas_next;
  end if;
end process;


end architecture;