library IEEE;
use IEEE.numeric_bit.all;

-- Tentativas:
-- 01: #20648 (10)

entity reg is
  generic(
    wordSize: natural := 4
  );
  port(
    clock: in bit;
    reset: in bit;
    load: in bit;
    d: in bit_vector(wordSize-1 downto 0);
    q: out bit_vector(wordSize-1 downto 0)
  );
end reg;

architecture reg_arch of reg is
  signal data: bit_vector(wordSize-1 downto 0);
begin

  ffdr: process(clock, reset)
  begin
    if reset='1' then
      data <= (others => '0');
    elsif clock='1' and clock'event then
      if load='1' then
        data <= d;
      end if;
    end if;
  end process;
  q <= data;

end architecture;


