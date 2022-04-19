--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #........ ()
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- DEPENDENCIES
-- [D01] DEMUX 1 BIT
-- [D02] REGISTER 1 BIT
-- [D03] REGFILE
-- [D04] FULL ADDER 1 BIT
-- [D05] ALU 1 BIT
-- [D06] ALU
-- [D07] SIGN EXTEND 
-- [D08] ALU CONTROL
-- [D09] CONTROL UNIT
-- [D10] DATAPATH
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- COMPONENT: [D01] DEMUX 1 BIT
--------------------------------------------------------------------------------
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



--------------------------------------------------------------------------------
-- COMPONENT: [D02] REGISTER 1 BIT
--------------------------------------------------------------------------------
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



--------------------------------------------------------------------------------
-- COMPONENT: [D03] REGFILE
--------------------------------------------------------------------------------
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



--------------------------------------------------------------------------------
-- COMPONENT: [D04] FULL ADDER 1 BIT
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity fa1bit is
  port(
    a, b, cin: in bit;
    s, cout: out bit
  );
 end entity;

architecture fa1bit_arch of fa1bit is
  signal axorb: bit;
begin
  axorb <= a xor b;
  s <= axorb xor cin;
  cout <= (axorb and cin) or (a and b);
end architecture;



--------------------------------------------------------------------------------
-- COMPONENT: [D05] ALU 1 BIT
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity alu1bit is
  port(
    a, b, less, cin: in bit;
    result, cout, set, overflow: out bit;
    ainvert, binvert: in bit;
    operation: in bit_vector(1 downto 0)
  );
end entity;

architecture alu1bit_arch of alu1bit is
  component fa1bit is
    port(
      a, b, cin: in bit;
      s, cout: out bit
    );
   end component;
  signal a_in, b_in, fa_sum, fa_cout: bit;
begin
  adder: fa1bit port map(
    a => a_in,
    b => b_in,
    cin => cin,
    s => fa_sum,
    cout => fa_cout
  );

  -- ainvert multiplex
  with ainvert select
    a_in <= 
      not(a) when '1',
      a when others;
  
  -- binvert multiplex
  with binvert select
    b_in <=
      not(b) when '1',
      b when others;

  -- operation multiplex
  with operation select
    result <=
      a_in and b_in when "00",
      a_in or b_in when "01",
      fa_sum when "10",
      less when "11";

  cout <= fa_cout;
  set <= fa_sum;
  overflow <= cin xor fa_cout;
end architecture;



--------------------------------------------------------------------------------
-- COMPONENT: [D06] ALU
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



--------------------------------------------------------------------------------
-- COMPONENT: [D07] SIGN EXTEND
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity signExtend is 
  port(
    i: in bit_vector(31 downto 0);
    o: out bit_vector(63 downto 0)
  );
end signExtend;

architecture signExtend_arch of signExtend is
  signal opcode: bit_vector(4 downto 0);
begin
  opcode <= i(31 downto 27);
  with opcode select
    o <= 
      bit_vector(resize(signed(i(25 downto 0)), 64)) when "00010",
      bit_vector(resize(signed(i(23 downto 5)), 64)) when "10110",
      bit_vector(resize(signed(i(20 downto 12)), 64)) when "11111",
      bit_vector(to_signed(0, 64)) when others; 
end architecture;



--------------------------------------------------------------------------------
-- COMPONENT: [D08] ALU CONTROL
--------------------------------------------------------------------------------
entity alucontrol is
  port(
    aluop: in bit_vector(1 downto 0);
    opcode: in bit_vector(10 downto 0);
    aluCtrl: out bit_vector(3 downto 0)
  );
end entity;

architecture alucontrol_arch of alucontrol is
  signal op_r: bit_vector(3 downto 0); 
begin
  -- opcode mux
  with opcode select
    op_r <=
      "0000" when "10001010000", -- and
      "0001" when "10101010000", -- or
      "0010" when "10001011000", -- add
      "0110" when "11001011000", -- sub
      "0000" when others;
  
  -- aluop mux
  with aluop select
    aluCtrl <=
      op_r  when "10", -- type R: and, or, add, sub
      "0010" when "00", -- ldur, stur
      "0111" when "01", -- cbz
      "0000" when others;
end architecture;



--------------------------------------------------------------------------------
-- COMPONENT: [D09] CONTROL UNIT
--------------------------------------------------------------------------------
entity controlunit is
  port(
    -- to datapath
    reg2loc: out bit;
    uncondBranch: out bit;
    branch: out bit;
    memRead: out bit;
    memToReg: out bit;
    aluOp: out bit_vector(1 downto 0);
    memWrite: out bit;
    aluSrc: out bit;
    regWrite: out bit;
    -- from datapath
    opcode: in bit_vector(10 downto 0)
  );
end entity;


architecture controlunit_arch of controlunit is
  type instruction_type is (LDUR, STUR, CBZ, B, R);
  signal i: instruction_type;
begin
  i <= 
    LDUR when (opcode = "11111000010") else
    STUR when (opcode = "11111000000") else
    CBZ when (opcode(10 downto 3) = "10110100") else
    B when (opcode(10 downto 5) = "000101") else
    R;

  reg2loc <= '1' when (i = STUR or i = CBZ) else '0';
  
  uncondBranch <= '1' when (i = B) else '0';

  branch <= '1' when (i = CBZ) else '0';

  memRead <= '1' when (i = LDUR) else '0';

  memToReg <= '1' when (i = LDUR) else '0';

  memWrite <= '1' when (i = STUR) else '0';

  aluSrc <= '1' when (i = LDUR or i = STUR) else '0';

  regWrite <= '1' when (i = R or i = LDUR) else '0';

  aluOp <= 
    "10" when (i = R) else 
    "01" when (i = CBZ or i = B) else
    "00";
end architecture;



--------------------------------------------------------------------------------
-- COMPONENT: [D10] DATAPATH
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;


entity datapath is
  port(
    -- Common
    clock: in bit;
    reset: in bit;
    -- From Control Unit
    reg2loc: in bit;
    pcsrc: in bit;
    memToReg: in bit;
    aluCtrl: in bit_vector(3 downto 0);
    aluSrc: in bit;
    regWrite: in bit;
    -- To Control Unit
    opcode: out bit_vector(10 downto 0);
    zero: out bit;
    -- IM interface
    imAddr: out bit_vector(63 downto 0);
    imOut: in bit_vector(31 downto 0);
    -- DM interface
    dmAddr: out bit_vector(63 downto 0);
    dmIn: out bit_vector(63 downto 0);
    dmOut: in bit_vector(63 downto 0)
  );
end entity datapath;

architecture datapath_arch of datapath is
  -- REGISTER 1 BIT
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

  -- REGFILE
  component regfile is
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
  end component;

  -- ALU
  component alu is
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
  end component;

  -- SIGN EXTEND
  component signExtend is
    port(
      i: in bit_vector(31 downto 0);
      o: out bit_vector(63 downto 0)
    );
  end component;

  -- CONSTANTS
  constant wordSize: natural := 64;

  -- SIGNALS
  signal pc_d, pc_q, pc_next, pc_shifted: bit_vector(wordSize-1 downto 0);
  signal rf_rr1, rf_rr2, rf_wr: bit_vector(4 downto 0);
  signal rf_d, rf_q1, rf_q2: bit_vector(wordSize-1 downto 0);
  signal sign_ext: bit_vector(wordSize-1 downto 0);
  signal alu_B, alu_F: bit_vector(wordSize-1 downto 0);
  signal alu_zero_flag: bit;

begin
  -- PROGRAM COUNTER (PC)
  PC: reg
    generic map(
      wordSize  => wordSize
    )
    port map(
      clock => clock,
      reset => reset,
      load => '1',
      d => pc_d,
      q => pc_q
    );

  -- REGFILE
  RF: regfile
    generic map(
      regn => 32,
      wordSize => wordSize
    )
    port map(
      clock => clock,
      reset => reset,
      regWrite => regWrite,
      rr1 => rf_rr1,
      rr2 => rf_rr2,
      wr => rf_wr,
      d => rf_d,
      q1 => rf_q1,
      q2 => rf_q2
    );

  -- SIGNAL EXTEND
  SE: signExtend
    port map(
      i => imOut,
      o => sign_ext
    );
  
  -- ALU
  MAIN_ALU: alu
    generic map(
      size => wordSize
    )
    port map(
      A => rf_q1,
      B => alu_B,
      F => alu_F,
      S => aluCtrl,
      Z => alu_zero_flag,
      Ov => open,
      Co => open
    );

  -- PROGRAM COUNTER
  pc_next <= bit_vector(unsigned(pc_q) + 4);
  pc_shifted <= bit_vector(unsigned(pc_d) + unsigned(sign_ext(wordSize-3 downto 0) & "00"));
  pc_d <= pc_shifted when (pcsrc = '1') else pc_next;

  -- REGFILE
  rf_wr <= imOut(4 downto 0);
  rf_rr1 <= imOut(9 downto 5);
  rf_rr2 <= imOut(4 downto 0) when (reg2loc = '1') else imOut(20 downto 16);
  rf_d <= dmOut when (memToReg = '1') else alu_F;

  -- ALU
  alu_B <= sign_ext when (aluSrc = '1') else rf_q2;

  -- TO CONTROL UNIT
  opcode <= imOut(31 downto 21);
  zero <= alu_zero_flag;

  -- IM INTERFACE
  imAddr <= pc_q;

  -- DM INTERFACE
  dmAddr <= alu_F;
  dmIn <= rf_q2;
end architecture;






--------------------------------------------------------------------------------
-- MAIN COMPONENT
-- POLILEGSC
--------------------------------------------------------------------------------
entity polilegsc is
  port(
    clock, reset: in bit;
    -- Data Memory
    dmem_addr: out bit_vector(63 downto 0);
    dmem_dati: out bit_vector(63 downto 0);
    dmem_dato: in bit_vector(63 downto 0);
    dmem_we: out bit;
    -- Instruction Memory
    imem_addr : out bit_vector(63 downto 0);
    imem_data: in bit_vector(31 downto 0)
  );
end entity polilegsc;

architecture polilegsc_arch of polilegsc is
  component alucontrol is
    port(
      aluop: in bit_vector(1 downto 0);
      opcode: in bit_vector(10 downto 0);
      aluCtrl: out bit_vector(3 downto 0)
    );
  end component;

  component controlunit is
    port(
      -- to datapath
      reg2loc: out bit;
      uncondBranch: out bit;
      branch: out bit;
      memRead: out bit;
      memToReg: out bit;
      aluOp: out bit_vector(1 downto 0);
      memWrite: out bit;
      aluSrc: out bit;
      regWrite: out bit;
      -- from datapath
      opcode: in bit_vector(10 downto 0)
    );
  end component;

  component datapath is
    port(
      -- Common
      clock: in bit;
      reset: in bit;
      -- From Control Unit
      reg2loc: in bit;
      pcsrc: in bit;
      memToReg: in bit;
      aluCtrl: in bit_vector(3 downto 0);
      aluSrc: in bit;
      regWrite: in bit;
      -- To Control Unit
      opcode: out bit_vector(10 downto 0);
      zero: out bit;
      -- IM interface
      imAddr: out bit_vector(63 downto 0);
      imOut: in bit_vector(31 downto 0);
      -- DM interface
      dmAddr: out bit_vector(63 downto 0);
      dmIn: out bit_vector(63 downto 0);
      dmOut: in bit_vector(63 downto 0)
    );
  end component;

  signal ac_op: bit_vector(1 downto 0);
  signal ac_opcode: bit_vector(10 downto 0);
  signal ac_output: bit_vector(3 downto 0);
  signal uc_reg2loc, uc_uncondBranch, uc_branch, uc_memRead, 
    uc_memToReg, uc_memWrite, uc_aluSrc, uc_regWrite: bit;
  signal dp_pcsrc, dp_zero: bit;
  signal dp_imAddr, dp_dmAddr, dp_dmIn: bit_vector(63 downto 0);

begin
  AC: alucontrol
    port map(
      aluop => ac_op,
      opcode => ac_opcode,
      aluCtrl => ac_output
    );

  UC: controlunit
    port map(
      reg2loc => uc_reg2loc,
      uncondBranch => uc_uncondBranch,
      branch => uc_branch,
      memRead => uc_memRead,
      memToReg => uc_memToReg,
      aluOp => ac_op,
      memWrite => uc_memWrite,
      aluSrc => uc_aluSrc,
      regWrite => uc_regWrite,
      opcode => ac_opcode
    );
  
  DP: datapath
    port map(
      clock => clock,
      reset => reset,
      reg2loc => uc_reg2loc,
      pcsrc => dp_pcsrc,
      memToReg => uc_memToReg,
      aluCtrl => ac_output,
      aluSrc => uc_aluSrc,
      regWrite => uc_regWrite,
      opcode => ac_opcode,
      zero => dp_zero,
      imAddr => dp_imAddr,
      imOut => imem_data,
      dmAddr => dp_dmAddr,
      dmIn => dp_dmIn,
      dmOut => dmem_dato
    );

    dmem_addr <= dp_dmAddr;
    dmem_dati <= dp_dmIn;
    dmem_we <= uc_memWrite;

    imem_addr <= dp_imAddr;

    dp_pcsrc <= uc_uncondBranch or (uc_branch and dp_zero);
end architecture;
