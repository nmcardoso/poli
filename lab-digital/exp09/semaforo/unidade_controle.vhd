library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity unidade_controle is
  port (
    clk, reset_n: in std_logic;
    count: in std_logic_vector(3 downto 0);
    load_n: out std_logic; -- sinal de controle do contador
    Ts: out std_logic_vector(1 downto 0); --sinal de controle do mux
    S0_verde, S0_amarelo, S0_vermelho: out std_logic;
    S1_verde, S1_amarelo, S1_vermelho: out std_logic
  );
end unidade_controle;

architecture unidade_controle_arch of unidade_controle is
  type estado_tipo is (E0L, E0C, E1L, E1C, E2L, E2C, E3L, E3C, E4L, E4C, E5L, E5C);
  signal estado_atual, prox_estado: estado_tipo;
  signal luzes: std_logic_vector(5 downto 0);
begin
  sincrono: process(clk, reset_n, prox_estado)
  begin
    if reset_n='0' then
      estado_atual <= E0L;
    elsif clk'event and clk='1' then
      estado_atual <= prox_estado;
    end if;
  end process;

  circ_prox_estado: process(estado_atual, count)
  begin
    case estado_atual is
      when E0L =>
        prox_estado <= E0C;
        Ts <= "00";
        luzes <= "100001";
        load_n <= '0';
      when E0C =>
        Ts <= "00";
        luzes <= "100001";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E1L;
        else
          prox_estado <= E0C;
        end if;
      when E1L =>
        prox_estado <= E1C;
        Ts <= "01";
        luzes <= "010001";
        load_n <= '0';
      when E1C =>
        Ts <= "01";
        luzes <= "010001";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E2L;
        else
          prox_estado <= E1C;
        end if;
      when E2L =>
        prox_estado <= E2C;
        Ts <= "10";
        luzes <= "001001";
        load_n <= '0';
      when E2C =>
        Ts <= "10";
        luzes <= "001001";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E3L;
        else
          prox_estado <= E2C;
        end if;
      when E3L =>
        prox_estado <= E3C;
        Ts <= "00";
        luzes <= "001100";
        load_n <= '0';
      when E3C =>
        Ts <= "00";
        luzes <= "001100";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E4L;
        else
          prox_estado <= E3C;
        end if;
      when E4L =>
        prox_estado <= E4C;
        Ts <= "01";
        luzes <= "001010";
        load_n <= '0';
      when E4C =>
        Ts <= "01";
        luzes <= "001010";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E5L;
        else
          prox_estado <= E4C;
        end if;
      when E5L =>
        prox_estado <= E5C;
        Ts <= "10";
        luzes <= "001001";
        load_n <= '0';
      when E5C =>
        Ts <= "10";
        luzes <= "001001";
        load_n <= '1';
        if count = "0001" then
          prox_estado <= E0L;
        else
          prox_estado <= E5C;
        end if;
    end case;
  end process;

  S0_verde <= luzes(5);
  S0_amarelo <= luzes(4);
  S0_vermelho <= luzes(3);
  S1_verde <= luzes(2);
  S1_amarelo <= luzes(1);
  S1_vermelho <= luzes(0);
end architecture;
