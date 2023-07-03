library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CodigoMorse is
  port (
  clock_in, reset_in : in std_logic;
  morse_bit : in std_logic;
  num_display : out std_logic_vector(7 downto 0);
  debug_morse_vec : out std_logic_vector(4 downto 0);
  aq_led_0, aq_led_1, aq_led_2, aq_led_3, aq_led_4 : out std_logic
  );
end CodigoMorse;

architecture CodigoMorseArch of CodigoMorse is
  signal morse_vec : std_logic_vector(4 downto 0);
  signal num_display_inv : std_logic_vector(7 downto 0);

  component Decoder is
    port (
      morse : in std_logic_vector(4 downto 0);
      display : out std_logic_vector(7 downto 0)
    );
  end component;

  component Controller is
    port (
      clk_in : in std_logic;
      reset : in std_logic;
      morse_bit : in std_logic;
      morse_out : out std_logic_vector(4 downto 0);
      aq_led_0, aq_led_1, aq_led_2, aq_led_3, aq_led_4 : out std_logic
    );
  end component;
  
  begin
  controller1 : Controller port map(
    clk_in => clock_in,
    reset => reset_in,
    morse_bit => morse_bit,
    morse_out => morse_vec,
    aq_led_0 => aq_led_0,
    aq_led_1 => aq_led_1,
    aq_led_2 => aq_led_2, 
    aq_led_3 => aq_led_3,
    aq_led_4 => aq_led_4
  );

  decoder1 : Decoder port map(
    morse => morse_vec,
    display => num_display_inv
  );
  
  num_display <= not num_display_inv;
  debug_morse_vec <= morse_vec;

end CodigoMorseArch;
