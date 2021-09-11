library IEEE;
use IEEE.numeric_bit.all;

entity reg is
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
end reg;
