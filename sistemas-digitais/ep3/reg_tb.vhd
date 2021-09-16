library IEEE;
use IEEE.numeric_bit.all;

entity reg_tb is
end reg_tb;

architecture reg_tb_arch of reg_tb is
  component reg is
    generic(
      wordSize: natural := 4
    );
    port(
      clock: in bit;
      reset: in bit;
      load: in bit;
      d: in bit_vector(wordSize-1 downto 0);
      q: out bit_vector(wordSize-1 downto 0)
    );
  end component;

  constant wordSize: natural := 8;

  signal clock_in, reset_in, load_in: bit;
  signal d_in, q_out: bit_vector(wordSize-1 downto 0);

  constant clock_period: time := 2 ns;
  signal simulating: bit := '1';

begin
  DUT: reg
  generic map(
    wordSize => wordSize
  )
  port map(
    clock => clock_in,
    reset => reset_in,
    load => load_in,
    d => d_in,
    q => q_out
  );

  clock_in <= (simulating and (not clock_in)) after clock_period/2;

  stimulus: process is
  begin
    report "Test start";

    wait for 2 * clock_period;

    d_in <= "00000100";
    load_in <= '1';

    wait for 4.2 * clock_period;

    reset_in <= '1';

    wait for 1 * clock_period;

    reset_in <= '0';

    wait for clock_period;

    report "Test end";
    simulating <= '0';
    wait;
  end process;
end architecture;