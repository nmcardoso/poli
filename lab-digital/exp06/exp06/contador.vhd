library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador is
  port (
    clock, zera, conta, direcao: in std_logic;
    contagem: out std_logic_vector(3 downto 0)
  );
end contador;


architecture contador_arch of contador is
  signal IQ: integer range 0 to 15;
begin
  process(clock, zera, conta)
  begin
    if zera='1' then
      IQ <= 0;
    elsif clock'event and clock='1' then  
      if conta='1' then
        if (direcao='1' and IQ<15) then
          IQ <= IQ + 1;
        elsif (direcao='0' and IQ>0) then
          IQ <= IQ - 1;
        end if;
      else
        IQ <= IQ;
      end if;
    end if;
  end process;

  contagem <= std_logic_vector(to_unsigned(IQ, contagem'length));
end contador_arch;
