library ieee;
use ieee.numeric_bit.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity regfile_tb is
end regfile_tb;

architecture regfile_tb_arch of regfile_tb is
  component regfile is
    generic(
      regn: natural := 32;
      wordSize: natural := 64
    );

    port(
      clock: in bit;
      reset: in bit;
      regWrite: in bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
      d: in bit_vector(wordSize - 1 downto 0);
      q1, q2: out bit_vector(wordSize - 1 downto 0)
    );
  end component;

  function natural_to_bv(n: in natural; length: in natural) return bit_vector is
    variable temp : natural := n;
    variable result : bit_vector(0 to length-1);
  begin
    for index in result'reverse_range loop
      result(index) := bit'val(temp rem 2);
      temp := temp / 2;
    end loop;
    return result;
  end natural_to_bv;

  constant ct: time := 10 ns;
  constant regn: natural := 32;
  constant regl: natural := natural(ceil(log2(real(regn))));
  constant wordSize: natural := 64;
  constant zeros: bit_vector(wordSize - 1 downto 0) := (others => '0');
  
  signal s_clock, s_reset, s_regWrite, sim: bit;
  signal s_rr1, s_rr2, s_wr: bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
  signal s_d, s_q1, s_q2: bit_vector(wordSize - 1 downto 0);
begin
  s_clock <= (sim and not(s_clock)) after ct;

  dut: regfile port map(s_clock, s_reset, s_regWrite, s_rr1, s_rr2, s_wr, s_d, s_q1, s_q2);

  test: process
  begin
    sim <= '1';

    s_regWrite <= '0';
    wait until rising_edge(s_clock);

    -- write data
    s_regWrite <= '1';
    s_wr <= natural_to_bv(3, regl);
    s_d <= natural_to_bv(41, wordSize);
    s_rr1 <= natural_to_bv(3, regl);
    wait until rising_edge(s_clock);
    s_regWrite <= '1';
    s_wr <= natural_to_bv(9, regl);
    s_d <= natural_to_bv(12, wordSize);
    wait until rising_edge(s_clock);

    -- read data
    s_regWrite <= '0';
    s_rr1 <= natural_to_bv(3, regl);
    s_rr2 <= natural_to_bv(9, regl);
    
    wait until rising_edge(s_clock);
    assert s_q1 = natural_to_bv(41, wordSize) report "Falha na leitura q1" severity error;
    assert s_q2 = natural_to_bv(12, wordSize) report "Falha na leitura q2" severity error;

    -- reset data
    wait until rising_edge(s_clock);
    wait for 0.2 * ct; -- check asynchronicity
    s_reset <= '1';
    wait for 0.2 * ct;
    assert s_q1 = zeros report "Falha no reset de r1" severity error;
    assert s_q2 = zeros report "Falha no reset de r2" severity error;

    -- check if last register is writeable
    wait until rising_edge(s_clock);
    s_regWrite <= '1';
    s_wr <= natural_to_bv(regn-1, regl);
    s_d <= natural_to_bv(16, wordSize);
    wait until rising_edge(s_clock);
    s_regWrite <= '0';
    s_rr1 <= natural_to_bv(regn-1, regl);
    wait until rising_edge(s_clock);
    assert s_q1 = zeros report "Falha: dados no último registrador" severity error;

    wait until rising_edge(s_clock);
    s_regWrite <= '1';
    s_wr <= natural_to_bv(9, regl);
    s_d <= natural_to_bv(12, wordSize);
    wait until rising_edge(s_clock);
    
    sim <= '0';
    wait;
  end process;
end regfile_tb_arch;