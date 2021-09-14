-- DEMUX

library IEEE;
use IEEE.numeric_bit.all;

entity demux is
  generic (
    selSize : natural := 4
  );
  port (
    a_in : in bit;
    sel : in bit_vector(selSize-1 downto 0);
    a_out : out bit_vector(2**selSize - 1 downto 0)
  );
end entity;

architecture demux_arch of demux is
begin
  process(sel, a_in)
  begin
    a_out <= (others => '0');
    a_out(to_integer(unsigned(sel))) <= a_in;
  end process;
end architecture;
library IEEE;
use IEEE.numeric_bit.all;

entity reg is
  generic (
    wordSize : natural := 4
  );
  port (
    clock: in bit;
    reset: in bit;
    load: in bit;
    d: in bit_vector(wordSize-1 downto 0);
    q: out bit_vector(wordSize-1 downto 0)
  );
end reg;

architecture reg_arch of reg is
  signal data: bit_vector(wordSize-1 downto 0);
begin
  process(clock, reset)
  begin
    if reset = '1' then
      data <= (others => '0');
    elsif rising_edge(clock) then
      if load = '1' then
        data <= d;
      end if;
    end if;
  end process;
  q <= data;
end reg_arch;
library IEEE;
use IEEE.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity regfile is
  generic(
    regn: natural := 32;
    wordSize: natural := 64
  );
  port(
    clock: in bit;
    reset: in bit;
    regWrite: in bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    d: in bit_vector(wordSize-1 downto 0);
    q1, q2: out bit_vector(wordSize-1 downto 0)
  );
end entity;
