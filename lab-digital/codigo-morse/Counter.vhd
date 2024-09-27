-- contador.vhd
-- contador hexadecimal de 4 bits

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- definição dos sinais de entrada e saída do circuito
entity Counter is
  port (
    clock, zera, enable: in std_logic;
    morse_bit: in std_logic;
    contagem: out std_logic_vector(4 downto 0);
    fim: out std_logic
  );
end Counter;


-- implementação comportamental do circuito contador
architecture comportamental of Counter is
  -- sinal IQ: sinal do tipo inteiro que armazena o valor atual do contador
  signal IQs: integer range 0 to 2**5;
  signal idxs: integer range 0 to 4;
begin
  process(clock, zera, morse_bit, enable, IQs, idxs)--, IQ, idx)
  -- define um processo sensível à mudança dos níveis lógicos dos sinais
  -- clock, zera, conta, carrega, entrada e IQ
  -- os sinais zera, conta e carrega definem as ações do circuito
  variable IQ: integer range 0 to 2**5;
  variable idx: integer range 0 to 4;
  begin
    IQs <= IQ;
    idxs <= idx;
    if zera='1' then
      -- clear assíncrono (não depende da borda de subida do clock)
      IQ := 0; -- zera o valor do contador
      idx := 0;
    
    elsif clock'event and clock='1' then
      if enable = '1' then
        if idx=4 then 
          IQ := IQ;
          idx := idx;
        else
          if morse_bit = '1' then
            IQ := IQ + 2**(4-idx);
          else
            IQ := IQ + 0;
          end if;
          idx := idx + 1;
        end if;
      else
        -- se nenhuma ação for especificada, o contador permanece com
        -- o sinal atual
        IQ := IQ;
        idx := idx;
      end if;
    end if;
  end process;

  -- liga do sinal interno IQ ao sinal de saída do contador
  -- faz cast de inteiro para std_logic_vector
  contagem <= std_logic_vector(to_unsigned(IQs, contagem'length));

  -- detecta quando o contador atinge o valor máximo
  fim <= '1' when idxs=4 else '0';
end comportamental;
