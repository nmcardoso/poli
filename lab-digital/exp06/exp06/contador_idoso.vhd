library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity contador_idoso is
  port (
    clock, zera, conta, direcao: in std_logic;
    contagem: out std_logic_vector(3 downto 0);
    conta_out, direcao_out: out std_logic
  );
end contador_idoso;


architecture contador_idoso_arch of contador_idoso is
  signal IQ: integer range 0 to 15;
begin
  process(clock, zera, conta)
  begin
    if zera='1' then
      IQ <= 0;
    elsif clock'event and clock='1' then
      conta_out <= '0';
      direcao_out <= '0';
      if conta='1' then
        if (direcao='1' and IQ<15) then
          conta_out <= conta;
          direcao_out <= direcao;
          IQ <= IQ + 1;
        elsif (direcao='0' and IQ>0) then
          conta_out <= conta;
          direcao_out <= direcao;
          IQ <= IQ - 1;
        end if;
      else
        IQ <= IQ;
      end if;
    end if;
  end process;

  contagem <= std_logic_vector(to_unsigned(IQ, contagem'length));
end contador_idoso_arch;
