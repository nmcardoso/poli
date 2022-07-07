library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity unidade_controle is
  port (
    clk, clear, programa, grava, inibe: in std_logic;
    c_carrega_n, c_inibe_n: out std_logic
  );
end unidade_controle;


architecture unidade_controle_arch of unidade_controle is
  type estado_tipo is (PROG, OP, IDLE);
  signal estado_atual, prox_estado: estado_tipo;
begin
  sincrono: process(clk, clear, prox_estado)
  begin
    if clear='1' then
      estado_atual <= IDLE;
    elsif clk'event and clk='1' then
      estado_atual <= prox_estado;
    end if;
  end process;

  -- circ_prox_estado: process(clk, clear, programa, grava, inibe)
  -- begin
  --   case estado_atual is
  --     when PROG =>
  --       c_inibe_n <= '0';
  --       -- c_carrega_n <= not grava;
        
  --       if grava = '1' then
  --         c_carrega_n <= '0';
  --       else
  --         c_carrega_n <= '1';
  --       end if;

  --       if programa = '1' then
  --         prox_estado <= PROG;
  --       elsif programa = '0' then
  --         prox_estado <= OP;
  --       end if;
  --     when OP =>
  --       -- c_inibe_n <= not inibe;
  --       c_carrega_n <= '0';

  --       if inibe = '1' then
  --         c_inibe_n <= '0';
  --       else
  --         c_inibe_n <= '1';
  --       end if;

  --       if programa = '1' then
  --         prox_estado <= PROG;
  --       elsif programa = '0' then
  --         prox_estado <= OP;
  --       end if;
  --     when IDLE =>
  --       c_inibe_n <= '0';
  --       c_carrega_n <= '1';
  --       if programa = '1' then
  --         prox_estado <= PROG;
  --       else
  --         prox_estado <= IDLE;
  --       end if;
  --   end case;
  -- end process;

  
  prox_estado <= 
    IDLE when estado_atual = IDLE and programa = '0' else
    PROG when programa = '1' else 
    OP;

  c_inibe_n <= not inibe when estado_atual = OP else '0';

  c_carrega_n <= not grava when estado_atual = PROG else '1';

end architecture;
