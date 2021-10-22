--------------------------------------------------------------------------------
-- Tentativas:
-- 01: #21826 (10)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- COMPONENTE: ULA
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity alu is
  generic(
    size: natural := 10
  );
  port(
    A, B: in bit_vector(size-1 downto 0);
    F: out bit_vector(size-1 downto 0);
    S: in bit_vector(3 downto 0);
    Z: out bit;
    Ov: out bit;
    Co: out bit
  );
end entity alu;

architecture alu_tb of alu is
  component alu1bit is
    port(
      a, b, less, cin: in bit;
      result, cout, set, overflow: out bit;
      ainvert, binvert: in bit;
      operation: in bit_vector(1 downto 0)
    );
  end component;
  signal carry_io, result_in, set_in: bit_vector(size-1 downto 0);
  signal less_in: bit;
begin
  -- componentes ALU para os bits internos
  alu_gen: for i in 1 to (size-2) generate
    alu_iter: alu1bit port map(
      A => A(i),
      B => B(i),
      less => '0',
      cin => carry_io(i-1),
      result => result_in(i),
      cout => carry_io(i),
      set => set_in(i),
      overflow => open,
      ainvert => S(3),
      binvert => S(2),
      operation => S(1 downto 0)
    );
  end generate;

  -- componente ALU para o bit mais significativo
  alu_msb: alu1bit port map(
    A => A(size-1),
    B => B(size-1),
    less => '0',
    cin => carry_io(size-2),
    result => result_in(size-1),
    cout => carry_io(size-1),
    set => set_in(size-1),
    overflow => Ov,
    ainvert => S(3),
    binvert => S(2),
    operation => S(1 downto 0)
  );

  -- componente ALU para o bit menos significativo
  alu_lsb: alu1bit port map(
    A => A(0),
    B => B(0),
    less => less_in,
    cin => S(2),
    result => result_in(0),
    cout => carry_io(0),
    set => set_in(0),
    overflow => open,
    ainvert => S(3),
    binvert => S(2),
    operation => S(1 downto 0)
  );

  Z <= '1' when (signed(result_in) = 0) else '0';
  less_in <= set_in(size-1);
  Co <= carry_io(size-1);
  F <= result_in;

end architecture;
