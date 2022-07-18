-- contador.vhd
-- contador hexadecimal de 4 bits

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- definição dos sinais de entrada e saída do circuito
entity contador is
  port (
    clock, zera, conta, carrega: in std_logic;
    entrada: in std_logic_vector(3 downto 0);
    contagem: out std_logic_vector(3 downto 0);
    fim: out std_logic
  );
end contador;


-- implementação comportamental do circuito contador
architecture comportamental of contador is
  -- sinal IQ: sinal do tipo inteiro que armazena o valor atual do contador
  signal IQ: integer range 0 to 15;
begin
  process(clock, zera, conta, carrega, entrada, IQ)
  -- define um processo sensível à mudança dos níveis lógicos dos sinais
  -- clock, zera, conta, carrega, entrada e IQ
  -- os sinais zera, conta e carrega definem as ações do circuito
  begin
    if zera='1' then
      -- clear assíncrono (não depende da borda de subida do clock)
      IQ <= 0; -- zera o valor do contador
    
    elsif clock'event and clock='1' then
      -- ações sensíveis à borda de subida do clock são colocadas aqui
      -- há duas ações possíveis: carregar os dados (maior precedência) 
      -- e incrementar o valor do sinal em 1 (menor precedência)
      -- apenas uma das ações é performada por clock
      
      if carrega='1' then
        -- ação "carrega": configura o contador para receber 
        -- um valor específico de um sinal de entrada do circuito
        IQ <= to_integer(unsigned(entrada));
      
      elsif conta='1' then  
        -- ação "conta": lógica de um acumulador circular, 
        -- incrementa o valor atual em 1 se o valor atual for menor 
        -- que o valor máximo, zera caso contrário
        if IQ=15 then 
          IQ <= 0;
        else 
          IQ <= IQ + 1;
        end if;
      
      else
        -- se nenhuma ação for especificada, o contador permanece com
        -- o sinal atual
        IQ <= IQ;
      end if;
    end if;
  end process;

  -- liga do sinal interno IQ ao sinal de saída do contador
  -- faz cast de inteiro para std_logic_vector
  contagem <= std_logic_vector(to_unsigned(IQ, contagem'length));

  -- detecta quando o contador atinge o valor máximo
  fim <= '1' when IQ=15 else '0';
end comportamental;
