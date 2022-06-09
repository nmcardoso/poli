library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity unidade_controle is
  port (
    clk, reset_n: in std_logic;
    T0, T1, T2: in std_logic_vector(3 downto 0);
    Qa, Qb, Qc, Qd: in std_logic;
    load_n: out std_logic;
    S0_verde, S0_amarelo, S0_vermelho: out std_logic;
    S1_verde, S1_amarelo, S1_vermelho: out std_logic;
    Oa, Ob, Oc, Od: out std_logic
  );
end unidade_controle;

architecture unidade_controle_arch of unidade_controle is
  type estado_tipo is (IDLE, E0, E1, E2, E3, E4, E5);
  signal estado_atual, prox_estado: estado_tipo;
  signal luzes: std_logic_vector(5 downto 0);
  signal contagem: std_logic_vector(3 downto 0);
  signal offset: std_logic_vector(3 downto 0);
  constant max: unsigned := "1111";
  constant one: unsigned := "0001";
begin
  sincrono: process(clk, reset_n, prox_estado)
  begin
    if reset_n='0' then
      estado_atual <= IDLE;
    elsif clk'event and clk='1' then
      estado_atual <= prox_estado;
    end if;
  end process;

  circ_prox_estado: process(estado_atual, contagem)
  begin
    case estado_atual is
      when IDLE =>
        offset <= std_logic_vector(max - unsigned(T0) + one);
        prox_estado <= E0;
        luzes <= "000000";
        load_n <= '0';
      when E0 =>
        offset <= std_logic_vector(max - unsigned(T1) + one);
        luzes <= "100001";
        if contagem /= "1111" then
          prox_estado <= E0;
          load_n <= '1';
        else
          prox_estado <= E1;
          load_n <= '0';
        end if;
      when E1 =>
        offset <= std_logic_vector(max - unsigned(T2) + one);
        luzes <= "010001";
        if contagem /= "1111" then
          prox_estado <= E1;
          load_n <= '1';
        else
          prox_estado <= E2;
          load_n <= '0';
        end if;
      when E2 =>
        offset <= std_logic_vector(max - unsigned(T0) + one);
        luzes <= "001001";
        if contagem /= "1111" then
          prox_estado <= E2;
          load_n <= '1';
        else
          prox_estado <= E3;
          load_n <= '0';
        end if;
      when E3 =>
        offset <= std_logic_vector(max - unsigned(T1) + one);
        luzes <= "001100";
        if contagem /= "1111" then
          prox_estado <= E3;
          load_n <= '1';
        else
          prox_estado <= E4;
          load_n <= '0';
        end if;
      when E4 =>
        offset <= std_logic_vector(max - unsigned(T2) + one);
        luzes <= "001010";
        if contagem /= "1111" then
          prox_estado <= E4;
          load_n <= '1';
        else
          prox_estado <= E5;
          load_n <= '0';
        end if;
      when E5 =>
        offset <= std_logic_vector(max - unsigned(T0) + one);
        luzes <= "001001";
        if contagem /= "1111" then
          prox_estado <= E5;
          load_n <= '1';
        else
          prox_estado <= E0;
          load_n <= '0';
        end if;
    end case;
  end process;

  contagem <= Qd & Qc & Qb & Qa;

  S0_verde <= luzes(5);
  S0_amarelo <= luzes(4);
  S0_vermelho <= luzes(3);
  S1_verde <= luzes(2);
  S1_amarelo <= luzes(1);
  S1_vermelho <= luzes(0);

  Od <= offset(3);
  Oc <= offset(2);
  Ob <= offset(1);
  Oa <= offset(0);
end architecture;
