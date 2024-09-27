-- contador_ud.vhd
-- contador hexadecimal bidirecional de 4 bits

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador_ud is
  port (
    clock, zera, conta, carrega, direcao: in std_logic;
    entrada: in std_logic_vector(3 downto 0);
    contagem: out std_logic_vector(3 downto 0);
    fim: out std_logic
  );
end contador_ud;


architecture comportamental of contador_ud is
  signal IQ: integer range 0 to 15;
begin
  process(clock, zera, conta, carrega, direcao, entrada, IQ)
  begin
    if zera='1' then
      IQ <= 0;
    elsif clock'event and clock='1' then    
      if carrega='1' then
      IQ <= to_integer(unsigned(entrada));
      elsif conta='1' then  
        if direcao='1' then
          if IQ=15 then 
            IQ <= 0;
          else 
            IQ <= IQ + 1;
          end if;
        else
          if IQ=0 then
            IQ <= 15;
          else
            IQ <= IQ - 1;
          end if;
        end if;
      else
        IQ <= IQ;
      end if;
    end if;
  end process;

  contagem <= std_logic_vector(to_unsigned(IQ, contagem'length));
  fim <= '1' when IQ=15 else '0';
end comportamental;
