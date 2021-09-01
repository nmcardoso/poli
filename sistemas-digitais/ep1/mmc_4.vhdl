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
  signal a_reg, b_reg, a_next, b_next: bit_vector(15 downto 0);
  signal nSomas_reg, nSomas_next: bit_vector(8 downto 0);
  constant acc_step: bit_vector(8 downto 0) := "000000001";
begin

  -- Async reset
  process(clock, reset)
  begin
    if (reset='1') then
      curr_state <= idle;
    elsif (clock'event and clock='1') then
      curr_state <= next_state;
    end if;
  end process;


  -- Finite State Machine
  process(curr_state, inicia, A, B, a_reg, b_reg)
  begin
    case curr_state is
      when idle =>
        if (inicia = '1') then
          next_state <= compare;
        else
          next_state <= idle;
        end if;
      when compare =>
        if (a_reg < b_reg) then
          next_state <= a_lt_b;
        elsif (a_reg > b_reg) then
          next_state <= a_gt_b;
        else
          next_state <= finished;
        end if;
      when a_lt_b =>
        next_state <= compare;
      when a_gt_b =>
        next_state <= compare;
      when finished =>
        next_state <= idle;
    end case;
  end process;

  
  -- Register Bank
  process(clock, reset)
  begin
    if (reset = '1') then
      a_reg <= (others => '0');
      b_reg <= (others => '0');
      nSomas_reg <= (others => '0');
    elsif (clock'event and clock='1') then
      a_reg <= a_next;
      b_reg <= b_next;
      nSomas_reg <= nSomas_next;
    end if;
  end process;


  -- Data
  process(curr_state, inicia, A, B, a_reg, b_reg)
  begin
    case curr_state is
      when idle =>
        if (inicia = '1') then
          a_next <= bit_vector("00000000" & A);
          b_next <= bit_vector("00000000" & B);
          nSomas_next <= (others => '0');
        end if;
      when compare =>
        if (unsigned(a_reg) = 0 or unsigned(b_reg) = 0) then
          a_next <= (others => '0');
          b_next <= (others => '0');
          nSomas_next <= (others => '0');
        else
          a_next <= a_reg;
          b_next <= b_reg;
          nSomas_next <= nSomas_reg;
        end if;
      when a_gt_b =>
        a_next <= a_reg;
        b_next <= bit_vector(unsigned(b_reg) + unsigned(bit_vector("00000000" & B)));
        nSomas_next <= bit_vector(unsigned(nSomas_reg) + unsigned(acc_step));
      when a_lt_b =>
        a_next <= bit_vector(unsigned(a_reg) + unsigned(bit_vector("00000000" & A)));
        b_next <= b_reg;
        nSomas_next <= bit_vector(unsigned(nSomas_reg) + unsigned(acc_step));
      when finished =>
        nSomas_next <= (others => '0');
    end case;
  end process;
  

  fim <= '1' when curr_state = finished else '0';
  MMC <= bit_vector(a_reg);
  nSomas <= bit_vector(nSomas_reg);


end architecture;