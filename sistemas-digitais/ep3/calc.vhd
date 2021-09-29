-- Tentativas:
-- 01: #20694 (10)


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


-- REGISTER

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


-- REGFILE

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

architecture regfile_arch of regfile is
  component reg is
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
  end component;

  component demux is
    generic (
      selSize : natural := 4
    );
    port (
      a_in : in bit;
      sel : in bit_vector(selSize-1 downto 0);
      a_out : out bit_vector(2**selSize - 1 downto 0)
    );
  end component;

  type regfile_type is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);

  constant regn_bits : natural := natural(ceil(log2(real(regn))));
  signal load_addr: bit_vector((2**regn_bits)-1 downto 0);
  signal q_addr: regfile_type;
begin
  gen_regfile: for i in 0 to regn-2 generate
    regf: reg 
      generic map(
        wordSize => wordSize
      )
      port map(
        clock => clock,
        reset => reset,
        load => load_addr(i),
        d => d, 
        q => q_addr(i)
      );
  end generate gen_regfile;

  d1: demux
    generic map(
      selSize => regn_bits
    )
    port map(
      a_in => regWrite, 
      sel => wr, 
      a_out => load_addr
    );

  q_addr(regn-1) <= (others => '0');

  q1 <= q_addr(to_integer(unsigned(rr1)));
  q2 <= q_addr(to_integer(unsigned(rr2)));
end regfile_arch;


-- CALCULATOR

library IEEE;
use IEEE.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity calc is
  port(
    clock: in bit;
    reset: in bit;
    instruction: in bit_vector(16 downto 0);
    q1: out bit_vector(15 downto 0)
  );
end entity;

architecture calc_arch of calc is
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

  signal opcode: bit_vector(1 downto 0);
  signal oper1, oper2, dest: bit_vector(4 downto 0);
  signal result, oper1_reg, oper2_reg: bit_vector(15 downto 0);
begin
    reg_bank: regfile   
      generic map(
        regn => 32, 
        wordSize => 16
      )
      port map(
        clock => clock, 
        reset => reset, 
        regWrite => '1', 
        rr1 => oper1, 
        rr2 => oper2, 
        wr => dest, 
        d => result, 
        q1 => oper1_reg, 
        q2 => oper2_reg
      );

    opcode <= instruction(16 downto 15);
    oper2 <= instruction(14 downto 10);
    oper1 <= instruction(9 downto 5);
    dest <= instruction(4 downto 0);

    with opcode select result <= 
      bit_vector(resize(signed(oper1_reg), 16) + resize(signed(oper2_reg), 16)) when "00",
      bit_vector(resize(signed(oper1_reg), 16) + resize(signed(oper2), 16)) when "01",
      bit_vector(resize(signed(oper1_reg), 16) - resize(signed(oper2_reg), 16)) when "10",
      bit_vector(resize(signed(oper1_reg), 16) - resize(signed(oper2), 16)) when "11";

    q1 <= oper1_reg;
end calc_arch;