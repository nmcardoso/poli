-- contador.vhd
-- contador bidirecional acíclico de 4 bits

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador is
  port (
    clock, zera, conta, direcao, cheio, duplo: in std_logic;
    vagas: in std_logic_vector(3 downto 0);
    contagem: out std_logic_vector(3 downto 0)
  );
end contador;


architecture contador_arch of contador is
  signal IQ, int_vagas: integer range 0 to 15;
begin
  int_vagas <= to_integer(unsigned(vagas));
  process(clock, zera, conta)
  begin
    if zera='1' then
      IQ <= 0;
    elsif clock'event and clock='1' then    
      if conta='1'then
        if duplo='0' then
          if (direcao='1' and IQ<15 and cheio='0') then
            IQ <= IQ + 1;
          elsif (direcao='0' and IQ>0) then
            IQ <= IQ - 1;
          end if;
        else
          if (direcao='1' and IQ<(int_vagas-1) and cheio='0') then
            IQ <= IQ + 2;
          elsif (direcao='0' and IQ>1) then
            IQ <= IQ - 2;
          end if;
        end if;
      else
        IQ <= IQ;
      end if;
    end if;
  end process;

  contagem <= std_logic_vector(to_unsigned(IQ, contagem'length));
end contador_arch;
