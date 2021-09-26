library IEEE;
use IEEE.numeric_bit.all;
-- use IEEE.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity calc_tb is
end calc_tb;

architecture testbench of calc_tb is
  component reg is
    generic (
      wordSize : natural := 4
    );
    port (
      clock: in bit; 
      reset: in bit;
      load: in bit ; 
      d: in bit_vector(wordSize-1 downto 0);
      q: out bit_vector(wordSize-1 downto 0) 
    );
  end component;

  component regfile is 
    generic(
      regn: natural := 32;
      wordSize: natural :=16
    );
    port(
      clock: in bit;
      reset: in bit;
      regWrite: in bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
      d: in bit_vector(wordSize-1 downto 0);

      qq1, qq2, qwr:  out bit_vector(wordSize-1 downto 0)
    );
  end component regfile;

  component calc is
    port (
      clock : in bit;
      reset : in bit;
      instruction : in bit_vector(16 downto 0);
      q1 : out bit_vector(15 downto 0)
    );
  end component;

  signal clock_in: bit;
  signal reset_in: bit;
  signal instruction_in: bit_vector(16 downto 0);
  signal q1_out: bit_vector(15 downto 0);

  signal opcode: bit_vector(1 downto 0);
  signal oper1, oper2, dest: bit_vector(4 downto 0);

  signal simulating: bit := '1';

  constant clock_period: time := 10 ns;

begin
  clock_in <= simulating and (not clock_in) after clock_period/2;

  instruction_in(16 downto 15) <= opcode;
  instruction_in(14 downto 10) <= oper2;
  instruction_in(9 downto 5) <= oper1;
  instruction_in(4 downto 0) <= dest;

  dut: calc 
    port map(
      clock => clock_in, 
      reset => reset_in, 
      instruction => instruction_in, 
      q1 => q1_out
    );

  stim: process is
    type test_record is record
      opcode: natural;
      oper1: natural;
      oper2: integer;
      dest: natural;
      result: integer;
    end record;
    type test_type is array (natural range <>) of test_record;
    constant tests: test_type := (
      --opcode, oper1, oper2, dest, result
      (1, 1, 10, 1, 0), -- ADDI X3, X1, #10
      (1, 2, -2, 2, 0), -- ADDI X2, X2, #-2
      (0, 1, 2, 3, 10), -- ADD X3, X1, X2
      (0, 3, 0, 3, 8), -- ADD X3, X3, X0

      (3, 4, 5, 4, 0),
      (3, 4, 0, 4, -5),
      (3, 5, -7, 5, 0),
      (3, 5, 0, 5, 7),
      (2, 5, 4, 6, 7),
      (3, 6, 0, 6, 12)
    );
  begin
    report "Test start";

    for k in tests'range loop
      simulating <= '1';

      wait until clock_in'event and clock_in = '1';

      opcode <= bit_vector(to_unsigned(natural(tests(k).opcode), 2));
      oper1 <= bit_vector(to_unsigned(natural(tests(k).oper1), 5));
      oper2 <= bit_vector(to_signed(integer(tests(k).oper2), 5)) when natural(tests(k).opcode) = 1 or natural(tests(k).opcode) = 3 else
                bit_vector(to_unsigned(integer(tests(k).oper2), 5));
      dest <= bit_vector(to_unsigned(natural(tests(k).dest), 5));

      -- wait until clock_in'event and clock_in = '1';
      wait for clock_period/10;

      assert (q1_out = bit_vector(to_signed(integer(tests(k).result), 16)))
        report integer'image(integer(tests(k).oper1)) & " + ("
          & integer'image(integer(tests(k).oper2)) & ") = "
          & integer'image(to_integer(signed(q1_out))) & ". Expected "
          & integer'image(integer(tests(k).result))
          severity error;
      
      -- wait for clock_period;
    end loop;

    report "Test end";
    simulating <= '0';
    wait;
  end process;

end architecture;