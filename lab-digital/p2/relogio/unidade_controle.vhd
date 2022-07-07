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
  type estado_tipo is (PROG, OP);
  signal estado_atual, prox_estado: estado_tipo;
begin
  sincrono: process(clk, clear, prox_estado)
  begin
    if clear='1' then
      estado_atual <= PROG;
    elsif clk'event and clk='1' then
      estado_atual <= prox_estado;
    end if;
  end process;

  -- circ_prox_estado: process(clk, clear, programa, grava, inibe)
  -- begin
  --   case estado_atual is
  --     when PROG =>
  --       c_inibe_n <= '0';
  --       c_carrega_n <= not grava;
  --       if programa = '1' then
  --         prox_estado <= PROG;
  --       elsif programa = '0' then
  --         prox_estado <= OP;
  --       end if;
  --     when OP =>
  --       c_inibe_n <= not inibe;
  --       c_carrega_n <= '1';
  --       if programa = '1' then
  --         prox_estado <= PROG;
  --       elsif programa = '0' then
  --         prox_estado <= OP;
  --       end if;
  --   end case;
  -- end process;

  prox_estado <= PROG when programa = '1' else OP;

  c_inibe_n <= '0' when estado_atual = PROG else not inibe;

  c_carrega_n <= not grava when estado_atual = PROG else '1';

end architecture;
