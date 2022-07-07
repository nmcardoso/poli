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
  
  prox_estado <= 
    IDLE when estado_atual = IDLE and programa = '0' else
    PROG when programa = '1' else 
    OP;

  c_inibe_n <= not inibe when estado_atual = OP else '0';

  c_carrega_n <= not grava when estado_atual = PROG else '1';

end architecture;
