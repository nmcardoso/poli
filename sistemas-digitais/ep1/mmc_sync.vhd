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
  signal a_reg, b_reg: bit_vector(15 downto 0);
  signal a_next, b_next: bit_vector(15 downto 0);
  signal nSomas_reg: bit_vector(8 downto 0);
  signal nSomas_next: bit_vector(8 downto 0);
  signal add_a, add_b: bit_vector(15 downto 0);
  signal acc_nSomas: bit_vector(8 downto 0);
  constant acc_step: bit_vector(8 downto 0) := "000000001";
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
    when op_a =>
      if (add_a = add_b) then -- old: add_a = add_b
        state_next <= idle;
      elsif (add_a < add_b) then
        state_next <= op_a;
      else
        state_next <= op_b;
      end if;
    when op_b =>
      if (add_a = add_b) then -- old: add_a = add_b
        state_next <= idle;
      elsif (add_b < add_a) then
        state_next <= op_b;
      else
        state_next <= op_a;
      end if;
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



process(state_reg, A, B, a_reg, b_reg, add_a, add_b)
begin
  case state_reg is
    when idle =>
      a_next <= bit_vector("00000000" & A);
      b_next <= bit_vector("00000000" & B);
      -- nSomas_next <= (others => '0');
    when op_a =>
      if (unsigned(a_reg) = 0 or unsigned(b_reg) = 0) then
        a_next <= (others => '0');
        b_next <= (others => '0');
        nSomas_next <= (others => '0');
      elsif (add_a = add_b) then
        a_next <= add_a;
        b_next <= add_b;
        nSomas_next <= acc_nSomas;
      else
        a_next <= add_a;
        b_next <= b_reg;
        nSomas_next <= acc_nSomas;
      end if;
    when op_b =>
      if (unsigned(a_reg) = 0 or unsigned(b_reg) = 0) then
        a_next <= (others => '0');
        b_next <= (others => '0');
        nSomas_next <= (others => '0');
      elsif (add_a = add_b) then
        a_next <= add_a;
        b_next <= add_b;
        nSomas_next <= acc_nSomas;
      else
        a_next <= a_reg;
        b_next <= add_b;
        nSomas_next <= acc_nSomas;
      end if;
  end case;
end process;



add_a <= bit_vector(unsigned(bit_vector("00000000" & A)) + unsigned(a_reg));
add_b <= bit_vector(unsigned(bit_vector("00000000" & B)) + unsigned(b_reg));
acc_nSomas <= bit_vector(unsigned(nSomas_reg) + unsigned(acc_step));



fim <= '1' when state_reg = idle else '0';



MMC <= bit_vector(a_reg);
nSomas <= bit_vector(nSomas_reg);

end architecture;