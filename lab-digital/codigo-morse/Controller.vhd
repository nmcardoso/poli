library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
  port (
    clk_in, reset : in std_logic;
    morse_bit: in std_logic;
    morse_out : out std_logic_vector(4 downto 0);
    aq_led_0, aq_led_1, aq_led_2, aq_led_3, aq_led_4 : out std_logic
  );
end Controller;

architecture Controller_arch of Controller is
  -- signal morse_bit_0, morse_bit_1, morse_bit_2, morse_bit_3, morse_bit_4 : std_logic;
  signal morse_vector : std_logic_vector(4 downto 0) := "00000";
  signal morse_vector_temp : std_logic_vector(4 downto 0) := "00000";
  signal led_vector : std_logic_vector(4 downto 0) := "00000";
  signal fim_contagem : std_logic;
  signal zera_contador : std_logic := '0';
  signal morse_bit_contador : std_logic := '0';
  constant invalid_morse_code : std_logic_vector(4 downto 0) := "01010";

  type ME_tipo is (idle, aquisicao, resultado);
  signal estado_atual, estado_futuro : ME_tipo;


  component Counter is
    port(
      clock, zera, enable: in std_logic;
      morse_bit: in std_logic;
      contagem: out std_logic_vector(4 downto 0);
      fim: out std_logic
    );
  end component;

begin
  cont: Counter port map(
    clock => clk_in, 
    zera => zera_contador or reset,
    enable => not zera_contador,
    morse_bit => morse_bit_contador,
    contagem => morse_vector_temp,
    fim => fim_contagem
  );

  sincrono: process(clk_in, reset, estado_futuro)
    begin
      if reset='1' then
        estado_atual <= idle;
      elsif clk_in'event and clk_in='1' then
        estado_atual <= estado_futuro;
      end if;
    end process;

  comb: process(estado_atual, reset, morse_bit, led_vector, fim_contagem, zera_contador, morse_vector, morse_vector_temp, morse_bit_contador)
    begin
      -- morse_vector_temp <= "00000";
      case estado_atual is
        when idle =>
          led_vector <= "00000";
          morse_vector <= invalid_morse_code;
          zera_contador <= '1';
          morse_bit_contador <= '0';
          if reset = '1' then
            estado_futuro <= idle;
          else
            estado_futuro <= aquisicao;
          end if;
        
        when aquisicao =>
          led_vector <= "00000";
          zera_contador <= '0';
          morse_vector <= invalid_morse_code;
          morse_bit_contador <= morse_bit;
          if fim_contagem = '1' then
            estado_futuro <= resultado;
          else
            estado_futuro <= aquisicao;
          end if;

        when resultado =>
          led_vector <= "11111";
          morse_vector <= morse_vector_temp;
          morse_bit_contador <= '0';
          estado_futuro <= idle;
          zera_contador <= '0';

        when others =>
          led_vector <= led_vector;
          morse_vector <= morse_vector;
          morse_bit_contador <= morse_bit_contador;
          estado_futuro <= idle;
          zera_contador <= zera_contador;
      end case;
  end process;

  aq_led_0 <= led_vector(0);
  aq_led_1 <= led_vector(1);
  aq_led_2 <= led_vector(2);
  aq_led_3 <= led_vector(3);
  aq_led_4 <= led_vector(4);
  morse_out <= morse_vector;
end Controller_arch;
