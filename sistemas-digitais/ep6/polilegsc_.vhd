--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #24749 (0.0 - VHDL simulation took too long)
-- 02: #24750 (0.0 - VHDL simulation took too long)
-- 03: #24801 (0.0 - VHDL simulation took too long)
-- 04: #24815 (5.0)
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- DEPENDENCIES:
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

  signal pc_reg_d, pc_reg_q : bit_vector(63 downto 0);
  signal pc_plus_4 : bit_vector(63 downto 0);
  signal sign_extension_shifted, pc_plus_sign : bit_vector(63 downto 0);
  signal rr1_in, rr2_in, wr_in : bit_vector(4 downto 0);
  signal write_data : bit_vector(63 downto 0);
  signal read_data_1, read_data_2 : bit_vector(63 downto 0);
  signal sign_extension : bit_vector(63 downto 0);
  signal main_alu_in_2, main_alu_result : bit_vector(63 downto 0);
  signal zero_flag : bit;
begin
  -- PROGRAM COUNTER (PC)
  PC: reg
    generic map(
      wordSize  => 64
    )
    port map(
      clock => clock,
      reset => reset,
      load => '1',
      d => pc_reg_d,
      q => pc_reg_q
    );

  -- REGFILE
  RF: regfile
    generic map(
      regn => 32,
      wordSize => 64
    )
    port map(
      clock => clock,
      reset => reset,
      regWrite => regWrite,
      rr1 => rr1_in,
      rr2 => rr2_in,
      wr => wr_in,
      d => write_data,
      q1 => read_data_1,
      q2 => read_data_2
    );

  -- SIGNAL EXTEND
  SE: signExtend
    port map(
      i => imOut,
      o => sign_extension
    );
  
  -- ALU
  MAIN_ALU: alu
    generic map(
      size => 64
    )
    port map(
      A => read_data_1,
      B => main_alu_in_2,
      F => main_alu_result,
      S => aluCtrl,
      Z => zero_flag,
      Ov => open,
      Co => open
    );

  pc_plus_4 <= bit_vector(unsigned(pc_reg_q) + 4);
  sign_extension_shifted <= sign_extension(61 downto 0) & "00";
  pc_plus_sign <= bit_vector(unsigned(pc_reg_q) + unsigned(sign_extension_shifted));

  with pcsrc select
  pc_reg_d <= 
    pc_plus_sign when '1',
    pc_plus_4 when others;

  rr1_in <= imOut(9 downto 5);

  with reg2loc select
    rr2_in <=   
      imOut(4 downto 0) when '1',
      imOut(20 downto 16) when others;

  wr_in <= imOut(4 downto 0);

  with memToReg select
    write_data <=   
      dmOut when '1',
      main_alu_result when '0';

  with aluSrc select
    main_alu_in_2 <=
      sign_extension when '1',
      read_data_2 when others;

  opcode <= imOut(31 downto 21);
  zero <= zero_flag;

  imAddr <= pc_reg_q;

  dmAddr <= main_alu_result;
  dmIn <= read_data_2;
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

  signal opcode_s: bit_vector(10 downto 0);
	signal reg2loc_s: bit := '0';
	signal uncondBranch_s: bit := '0';
	signal branch_s: bit := '0';
	signal memRead_s: bit := '0';
	signal memToReg_s: bit := '0';
	signal aluOp_s: bit_vector(1 downto 0) := (others => '0');
	signal memWrite_s: bit := '0';
	signal aluSrc_s: bit := '0';
	signal regWrite_s: bit := '0';
	signal aluCtrl_s: bit_vector(3 downto 0) := (others => '0');
	signal pcsrc_s: bit := '0';
	signal zero_s: bit := '0';
	signal zero_branch: bit := '0';
begin	
  polileg_datapath: datapath
    port map(
      clock => clock, 
      reset => reset, 
      reg2loc => reg2loc_s, 
      pcsrc => pcsrc_s, 
      memToReg => memtoreg_s, 
      aluCtrl => aluctrl_s,
      aluSrc => alusrc_s, 
      regWrite => regwrite_s, 
      opcode => opcode_s, 
      zero =>  zero_s, 
      imAddr => imem_addr, 
      imOut => imem_data, 
      dmAddr => dmem_addr, 
      dmIn => dmem_dati, 
      dmOut => dmem_dato
    );
        
  polileg_controlunit: controlunit
    port map(
      reg2loc => reg2loc_s, 
      uncondBranch => uncondBranch_s, 
      branch => branch_s, 
      memRead => memRead_s, 
      memToReg => memToReg_s, 
      aluOp => aluOp_s, 
      memWrite => memWrite_s, 
      aluSrc => aluSrc_s, 
      regWrite => regWrite_s, 
      opcode => opcode_s
    );
		
	polileg_alucontrol: alucontrol
    port map(
      aluop => aluOp_s, 
      opcode => opcode_s, 
      aluCtrl => aluctrl_s
    );

  dmem_we <= 	
    '0' when memRead_s = '1' else
    '1' when memWrite_s = '1';

  zero_branch <= branch_s and zero_s;
  
  pcsrc_s <= uncondBranch_s or zero_branch;
end architecture;
