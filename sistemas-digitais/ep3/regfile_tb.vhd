library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity regfile_tb is
end entity;

architecture tb of regfile_tb is
  -- Componente a ser testado (Device Under Test -- DUT)
  component regfile is
    generic (
      regn: natural := 32;
      wordSize: natural := 64
    );
    port (
      clock: in bit;
      reset: in bit;
      regWrite: in bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
      d: in bit_vector(wordSize-1 downto 0);
      q1, q2: out bit_vector(wordSize-1 downto 0)
    );
  end component;

  constant regn_in : natural := 8;
  constant wordSize_in : natural := 64;
  constant regn_bits : natural := natural(ceil(log2(real(regn_in))));
  
  -- Declaração de sinais para conectar a componente
  signal clk, reset_in, regWrite_in: bit := '0';
  signal rr1_in, rr2_in, wr_in: bit_vector(regn_bits-1 downto 0);
  signal d_in, q1_out, q2_out: bit_vector(wordSize_in-1 downto 0);

  signal Q1, Q2: integer;
  signal RR1, RR2, WR : integer := 0;

  -- Configurações do clock
  signal finished : boolean := false;
  constant clockPeriod : time := 1 ns;

begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
  -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
  -- simulação de eventos
  clk <= not clk after clockPeriod/2 when not finished else '0';

  DUT: regfile    generic map(regn_in, wordSize_in)
                  port map(clk, reset_in, regWrite_in, rr1_in, rr2_in, wr_in, d_in, q1_out, q2_out);

  Q1 <= to_integer(unsigned(q1_out));
  Q2 <= to_integer(unsigned(q2_out));

  rr1_in <= bit_vector(to_unsigned(RR1, regn_bits));
  rr2_in <= bit_vector(to_unsigned(RR2, regn_bits));
  wr_in <= bit_vector(to_unsigned(WR, regn_bits));

  STIMULUS: process is
  begin
    report "BOT";
    finished <= false;

    wait for clockPeriod;
    reset_in <= '1';
    wait for 2*clockPeriod;
    reset_in <= '0';
    wait for 2*clockPeriod;

    RR1 <= 0;
    RR2 <= 1;
    WR <= 0;
    d_in   <= bit_vector(to_unsigned(15, wordSize_in));
    wait until falling_edge(clk);
    regWrite_in <= '1';
    wait for clockPeriod;
    regWrite_in <= '0';

    assert (Q1=15) report "1.1" severity failure;
    assert (Q2=0) report "1.2" severity failure;

    wait for 2*clockPeriod;

    WR <= 1;
    d_in   <= bit_vector(to_unsigned(13, wordSize_in));
    wait until falling_edge(clk);
    regWrite_in <= '1';
    wait for clockPeriod;
    regWrite_in <= '0';

    assert (Q1=15) report "2.1" severity failure;
    assert (Q2=13) report "2.2" severity failure;
    
    wait for 2*clockPeriod;

    finished <= true;
    report "EOT";
    wait;
  end process;
end architecture;