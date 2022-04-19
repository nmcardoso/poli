--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #24749 (0.0 - VHDL simulation took too long)
-- 02: #24750 (0.0 - VHDL simulation took too long)
-- 03: #24801 (0.0 - VHDL simulation took too long)
-- 04: #24815 (5.0)
-- 05: #24847 (10.0)
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- DEPENDENCIAS:
-- [D01] FULLADDER
-- [D02] MUX 2 TO 1
-- [D03] MUX 4 TO 1
-- [D04] ALU 1 BIT
-- [D05] ALU
-- [D06] REGFILE
-- [D07] SIGN EXTEND
-- [D08] SHIFT LEFT 
-- [D09] PROGRAM COUNTER
-- [D10] 64BIT MUX 2 TO 1
-- [D11] CONTROL UNIT
-- [D12] ALU CONTROL
-- [D13] DATAPATH
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- COMOPENTE: [D01] FULLADDER
--------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.ALL;

entity fulladder is
  port (
    a, b, cin: in bit;
    s, cout: out bit
  );
end entity;

architecture structural of fulladder is
  signal axorb: bit;
begin
  axorb <= a xor b;
  s <= axorb xor cin;
  cout <= (axorb and cin) or (a and b);
end architecture;




--------------------------------------------------------------------------------
-- COMPONENTE: [D02] MUX 2 TO 1
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity mux_2to1 is
  port (
    SEL : in  bit;    
    A :   in  bit;
    B :   in  bit;
    Y :   out bit
    );
end entity mux_2to1;

architecture with_select of mux_2to1 is
begin
  with SEL select
    Y <= A when '0',
         B when '1',
         '0' when others;
end architecture with_select;




--------------------------------------------------------------------------------
-- COMPONENTE: [D03] MUX 4 TO 1
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity mux_4to1 is
  port (
    SEL :     in  bit_vector (1 downto 0);    
  A,B,C,D :   in  bit;
    Y :       out bit
    );
end entity mux_4to1;

architecture with_select of mux_4to1 is
begin
  with SEL select
    Y <= A when "00",
         B when "01",
         C when "10",
         D when "11",
         '0' when others;
end architecture with_select;




--------------------------------------------------------------------------------
-- COMPONENTE: [D04] ALU 1 BIT
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity alu1bit is
  port(
    a, b, less, cin: in bit;
    result, cout, set, overflow: out bit;
    ainvert, binvert: in bit;
    operation : in bit_vector (1 downto 0)
  );
end alu1bit;

architecture alu1bit_arch of alu1bit is
  component fulladder is
  port (
    a, b, cin: in bit;
    s, cout:  out bit
  );
  end component;
  
  component mux_2to1 is
  port (
      SEL : in  bit;    
      A :   in  bit;
      B :   in  bit;
      Y :   out bit
    );
    end component;
    
    component mux_4to1 is
    port (
      SEL :     in  bit_vector (1 downto 0);    
    A,B,C,D :   in  bit;
      Y :       out bit
    );
    end component;
      
     signal nota, notb,aprep, bprep : bit;
     signal andentry, orentry, addentry : bit;
     signal coutsignal : bit;
begin
  nota <= not(a);
  notb <= not(b);
  MUXAINV : mux_2to1  port map (
    SEL => ainvert,
    A => a ,
    B => nota,
    Y => aprep
  );
  
  MUXBINV : mux_2to1  port map (
    SEL => binvert,
    A => b ,
    B => notb,
    Y => bprep
  );
  
  ADDER : fulladder port map(
    a => aprep,
    b => bprep,
    cin => cin,
    s => addentry,
    cout => coutsignal               
  );
  
  andentry <= aprep and bprep;
  orentry <= aprep or bprep;
  overflow <= cin xor coutsignal;
  cout <= coutsignal;
  set <= addentry;
  
  MUXRESULT: mux_4to1 port map(
    SEL => operation,
    A => andentry,
    B => orentry,
    C => addentry,
    D => b,
    Y => result
  );
  
end alu1bit_arch;




--------------------------------------------------------------------------------
-- COMPONENTE: [D05] ALU
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity alu is
  generic (
    size: natural := 64
  );
  port (
    A,B  : in  bit_vector(size-1 downto 0);
    F  : out  bit_vector(size-1 downto 0);
    S  : in  bit_vector(3 downto 0);
    Z  : out bit;
    Ov  : out bit;
    Co  : out bit
  );
end entity alu;

architecture alu_arch of alu is
  component alu1bit is
  port(
    a, b, less, cin: in bit;
    result, cout, set, overflow: out bit;
    ainvert, binvert: in bit;
    operation : in bit_vector (1 downto 0)
  );
  end component;
  signal carryvector : bit_vector(size downto 0);
  signal lessvector, setvector, overflowvector, result : bit_vector(size-1 downto 0);
  signal singlebitoperation: bit_vector (1 downto 0);
  signal a_inv_signal, b_inv_signal : bit; 
  
begin 
  process (lessvector,setvector)
  begin
       LESSVECTORFILL: FOR i IN 0 to size-1 LOOP
      if i = 0 then
        lessvector(i) <= setvector(size-1);
      else
        lessvector(i) <= '0';
      end if;
    END LOOP LESSVECTORFILL;
  end process;
  
  PREPAREENTRIES : process(S) is
  begin
    if     S = "0000" then --AND bit by bit
      singlebitoperation <= "00";
      a_inv_signal <= '0';
      b_inv_signal <= '0';
      carryvector(0) <= '0';
    elsif   S = "0001" then --OR bit by bit
        singlebitoperation <= "01";
        a_inv_signal <= '0';
      b_inv_signal <= '0';
      carryvector(0) <= '0';
    elsif  S = "0010" then  --ADD
      singlebitoperation <= "10";
      a_inv_signal <= '0';
      b_inv_signal <= '0';
      carryvector(0) <= '0';
    elsif  S = "0110" then --SUBTRACT
      singlebitoperation <= "10";
      a_inv_signal <= '0';
      b_inv_signal <= '1';
      carryvector(0) <= '1';
    elsif   S = "0111" then --SLT
      singlebitoperation <= "11";
      a_inv_signal <= '0';
      b_inv_signal <= '1';
      carryvector(0) <= '1';
    elsif   S = "1100" then --NOR bit by bit
      singlebitoperation <= "00";
      a_inv_signal <= '1';
      b_inv_signal <= '1';
      carryvector(0) <= '1'; 
    end if;
  end process PREPAREENTRIES;
  
  ALUGEN: FOR i IN size-1 downto 0 GENERATE
    ALURIPPLEi : alu1bit port map(
    A(i),
    B(i),
    lessvector(i),
    carryvector(i),
    result(i),
    carryvector(i+1),
    setvector(i),
    overflowvector(i),
    a_inv_signal,
    b_inv_signal,
    singlebitoperation 
    );
  END GENERATE ALUGEN;
  F <= result;
  Ov <= overflowvector(size-1);
  Z  <= '1' when result =(result'range => '0') else '0';
  Co <= carryvector(size); 
  
end alu_arch;




--------------------------------------------------------------------------------
-- COMPONENTE: [D06] REGFILE
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;
use ieee.math_real.ALL;

entity regfile is 
  generic(
    regn: natural := 32;
    wordSize: natural := 64
  );
  port(
    clock :     in  bit;
    reset :   in  bit;
    regWrite :   in  bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn)))) -1 downto 0);
    d    : in  bit_vector(wordSize-1 downto 0);
    q1, q2: out bit_vector(wordSize-1 downto 0)
  );
end regfile;

architecture dados of regfile is  
  type   reg_array is array (0 to regn-1) of bit_vector (wordSize-1 downto 0);
  signal registradores: reg_array;
    begin
    wrt: process(clock,reset) begin
      if reset = '1' then
        regfor: FOR i IN 0 to regn-1 LOOP
          bitfor: FOR j IN 0 to wordSize-1 LOOP
            registradores(i)(j) <= '0';
          END LOOP bitfor;
        END LOOP regfor;
      elsif clock = '1' and clock'event then
        if regWrite = '1' then
          if to_integer(unsigned(wr)) < regn - 1 then
            registradores(to_integer(unsigned(wr))) <= d;
          end if;
        end if;
      end if;
    end process;  
  q1 <= registradores(to_integer(unsigned(rr1)));
  q2 <= registradores(to_integer(unsigned(rr2)));
end dados;




--------------------------------------------------------------------------------
-- COMPONENTE: [D07] SIGN EXTEND
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity signExtend is
    port (
        i : in  bit_vector(31 downto 0);
        o : out bit_vector(63 downto 0)
    );
end entity signExtend;

architecture signExtend_arch of signExtend is
begin
    with i(31 downto 30) select o <=
        bit_vector(resize(signed(i(25 downto  0)), o'length)) when "00", -- CBZ
        bit_vector(resize(signed(i(23 downto  5)), o'length)) when "10", -- B
        bit_vector(resize(signed(i(20 downto 12)), o'length)) when "11", -- LDUR and STUR
        (others => '0') when others;
end architecture signExtend_arch;




--------------------------------------------------------------------------------
-- COMPONENTE: [D08] SHIFT LEFT
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity shiftLeft2 is 
  generic (
    wordSize : natural := 64
  );
  port(
    input : in bit_vector(wordSize-1 downto 0);
    output: out bit_vector(wordSize-1 downto 0)
  );
end entity shiftLeft2;

architecture shiftLeft2_arch of shiftLeft2 is
  begin
    output <= input(wordSize-3 downto 0) & "00";
end architecture shiftLeft2_arch;




--------------------------------------------------------------------------------
-- COMPONENTE: [D09] PROGRAM COUNTER
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity PC is
  generic(
    wordSize : natural := 64
  );
  port(
    clock: in bit;
    reset: in bit;
    load: in bit;
    newAddress: in bit_vector(wordSize-1 downto 0);
    currentAddress: out bit_vector(wordSize-1 downto 0)
  );
end entity PC;

architecture PC_arch of PC is
  signal address: bit_vector(wordSize-1 downto 0);
  begin
    process(clock,reset) begin
      if(reset = '1') then
        address <= (others => '0');
      elsif(rising_edge(clock)) then
        if(load = '1') then
          address <= newAddress;
        end if;
      end if;
    end process;
    currentAddress <= address;

end architecture PC_arch;





--------------------------------------------------------------------------------
-- COMPONENT: D[10] 64BIT MUX 2 TO 1
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity bigmux2_to1 is
  generic(
    wordSize: natural := 64
  );
  port(
    sel: in bit;
    A: in bit_vector(wordSize -1 downto 0);
    B: in bit_vector(wordSize -1 downto 0);
    O: out bit_vector(wordSize -1 downto 0)
  );
end entity bigmux2_to1;

architecture with_select of bigmux2_to1 is
  begin
    with sel select
      O <= A when '0',
         B when '1';
    
end architecture with_select;




--------------------------------------------------------------------------------
-- COMPONENTE: [D11] CONTROL UNIT
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;

entity controlunit is
  port(
    reg2loc: out bit;
    uncondbranch: out bit;
    branch : out bit;
    memRead : out bit;
    memToReg: out bit;
    aluOp : out bit_vector(1 downto 0);
    memWrite: out bit;
    aluSrc : out bit;
    regWrite : out bit;
    opcode: in bit_vector(10 downto 0)
  );
end entity;
  
architecture uc_arch of controlunit is
  begin
  CTRL_UNIT: process (opcode) is
  begin
    if opcode = "11111000010" then
      reg2loc <= '0';
      uncondbranch <= '0';
      branch <= '0';
      memRead <= '1';
      memToReg <= '1';
      aluop <= "00";
      memWrite <= '0';
      aluSrc <= '1';
      regWrite <= '1';
    elsif opcode = "11111000000" then
      reg2loc <= '1';
      uncondbranch <= '0';
      branch <= '0';
      memRead <= '0';
      memToReg <= '0';
      aluop <= "00";
      memWrite <= '1';
      aluSrc <= '1';
      regWrite <= '0';
    elsif opcode(10 downto 3) = "10110100" then
      reg2loc <= '1';
      uncondbranch <= '0';
      branch <= '1';
      memRead <= '0';
      memToReg <= '0';
      aluop <= "01";
      memWrite <= '0';
      aluSrc <= '0';
      regWrite <= '0';
    elsif opcode(10 downto 5) = "000101" then
      reg2loc <= '1';
      uncondbranch <= '1';
      branch <= '1';
      memRead <= '0';
      memToReg <= '0';
      aluop <= "01";
      memWrite <= '0';
      aluSrc <= '0';
      regWrite <= '0';
    elsif opcode = "10001011000" or opcode = "11001011000" or opcode = "10001010000" or opcode = "10101010000" then
      reg2loc <= '0';
      uncondbranch <= '0';
      branch <= '0';
      memRead <= '0';
      memToReg <= '0';
      aluop <= "10";
      memWrite <= '0';
      aluSrc <= '0';
      regWrite <= '1';
    end if;
  end process;
end architecture;




--------------------------------------------------------------------------------
-- COMPONENTE: [D12] ALU CONTROL
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity alucontrol is
  port (
    aluop:   in  bit_vector(1 downto 0);
    opcode:  in  bit_vector(10 downto 0);
    aluCtrl: out bit_vector(3 downto 0)
  );
  end entity;
  
architecture alucontrol_arch of alucontrol is  
  begin
    process(aluop, opcode) is
    begin
      if    aluop = "00" then aluCtrl <= "0010";
      elsif aluop = "01" then aluCtrl <= "0111";
      elsif aluop = "10" then
        if    opcode = "10001011000" then aluCtrl <= "0010"; -- ADD
        elsif opcode = "11001011000" then aluCtrl <= "0110"; -- SUB
        elsif opcode = "10001010000" then aluCtrl <= "0000"; -- AND
        elsif opcode = "10101010000" then aluCtrl <= "0001"; -- ORR
        end if;
      end if;
    end process;
end architecture alucontrol_arch;




--------------------------------------------------------------------------------
-- COMPONENTE: [D13] DATAPATH
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;
use ieee.math_real.ALL;

entity datapath is
  generic(
    wordSize: natural := 64
  );
  port(
    -- Comum
    clock: in bit;
    reset: in bit;
    -- Da Unidade de Controle
    reg2loc: in bit;
    pcsrc: in bit;
    memToReg: in bit;
    aluCtrl: in bit_vector(3 downto 0);
    aluSrc: in bit;
    regWrite: in bit;
    -- Para a Unidade de Controle
    opcode: out bit_vector(10 downto 0);
    zero: out bit;
    -- Interface com a memoria das instrucoes
    imAddr: out bit_vector(63 downto 0);
    imOut: in bit_vector(31 downto 0);
    -- Interface com a memoria dos dados
    dmAddr: out bit_vector(63 downto 0);
    dmIn: out bit_vector(63 downto 0);
    dmOut: in bit_vector(63 downto 0)
  );
end entity datapath;

architecture datapath_arch of datapath is
  component alu is
    generic (
      size: natural := 64
    );
    port (
      A, B: in  bit_vector(size-1 downto 0);
      F: out  bit_vector(size-1 downto 0);
      S: in  bit_vector(3 downto 0);
      Z: out bit;
      Ov: out bit;
      Co: out bit
    );
  end component alu;

  component signExtend is
    port (
      i : in  bit_vector(31 downto 0);
      o : out bit_vector(63 downto 0)
    );
  end component signExtend;

  component PC is
    generic(
      wordSize : natural := 64
    );
    port(
      clock: in bit;
      reset: in bit;
      load: in bit;
      newAddress: in bit_vector(wordSize-1 downto 0);
      currentAddress: out bit_vector(wordSize-1 downto 0)
    );
  end component PC;

  component regfile is 
    generic(
      regn: natural := 32;
      wordSize: natural := 64
    );
    port(
      clock:     in  bit;
      reset:   in  bit;
      regWrite :   in  bit;
      rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn)))) -1 downto 0);
      d: in  bit_vector(wordSize-1 downto 0);
      q1, q2: out bit_vector(wordSize-1 downto 0)
    );
  end component regfile;

  component shiftLeft2 is 
    generic (
      wordSize : natural := 64
    );
    port(
      input : in bit_vector(wordSize-1 downto 0);
      output: out bit_vector(wordSize-1 downto 0)
    );
  end component shiftLeft2;

  component bigmux2_to1 is
    generic(
      wordSize: natural := 64
    );
    port(
      sel: in bit;
      A: in bit_vector(wordSize -1 downto 0);
      B: in bit_vector(wordSize -1 downto 0);
      O: out bit_vector(wordSize -1 downto 0)
    );
  end component bigmux2_to1;

  -- PC signals
  signal pc_input: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal pc_output: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal four_vector: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal pc_adder_output: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal branch_alu_output: bit_vector(wordSize-1 downto 0) := (others => '0');
  -- Shift left Signal --
  signal sl2_output: bit_vector(wordSize-1 downto 0) := (others => '0');
  -- Sign extend signal --
  signal instruction: bit_vector(31 downto 0) := (others => '0');
  signal extended_address: bit_vector(wordSize-1 downto 0) := (others => '0');
  -- Register signals --
  signal read_register1: bit_vector(4 downto 0) := (others => '0');
  signal read_register2: bit_vector(4 downto 0) := (others => '0');
  signal write_register: bit_vector(4 downto 0) := (others => '0');
  signal write_data: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal reg_output1: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal reg_output2: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal regmux_entry0: bit_vector(4 downto 0) := (others => '0');
  signal regmux_entry1: bit_vector(4 downto 0) := (others => '0');
  -- Main Alu Signals --
  signal main_alu_entry1: bit_vector(wordSize-1 downto 0) := (others => '0');
  signal main_alu_out: bit_vector(wordSize-1 downto 0) := (others => '0');
  
  begin
    four_vector <= "0000000000000000000000000000000000000000000000000000000000000100";
    instruction <= imOut;
    regmux_entry0 <= instruction(20 downto 16);
    regmux_entry1 <= instruction(4 downto 0);
    read_register1 <= instruction(9 downto 5);
    write_register <= instruction(4 downto 0);
    opcode <= 
      ("10110100" & "000") when instruction(31 downto 24) = "10110100" else
      ("000101" & "00000") when instruction(31 downto 26) = "000101" else
      instruction(31 downto 21);

    program_counter : PC 
      generic map (
        wordSize => 64
      )
      port map (
        clock => clock,
        reset => reset,
        load => '1',
        newAddress => pc_input,
        currentAddress => pc_output
      );

    pc_adder : alu
      generic map (
        size => 64
      )
      port map(
        A => pc_output,
        B => four_vector,
        F => pc_adder_output,
        S => "0010",
        Z => open,
        Ov => open,
        Co => open
      );

    branch_alu : alu 
      generic map (
        size => 64
      )
      port map(
        A => pc_output,
        B => sl2_output,
        F => branch_alu_output,
        S => "0010",
        Z => open,
        Ov => open,
        Co => open
      );

    main_alu : alu
      generic map(
        size => 64
      )
      port map(
        A => reg_output1,
        B => main_alu_entry1,
        F => main_alu_out,
        S => aluCtrl,
        Z => zero,
        Ov => open,
        Co => open
      );

    alu_mux : bigmux2_to1
      generic map(
        wordSize => 64
      )
      port map(
        sel => aluSrc,
        A => reg_output2,
        B => extended_address,
        O => main_alu_entry1
      );

    pc_mux : bigmux2_to1 
      generic map(
        wordSize => 64
        )
      port map(
        sel => pcsrc,
        A => pc_adder_output,
        B => branch_alu_output,
        O => pc_input
      );

    reg_mux: bigmux2_to1
      generic map(5)
      port map(
        sel => reg2loc,
        A => regmux_entry0,
        B => regmux_entry1,
        O => read_register2
      );

    memtoreg_mux: bigmux2_to1
      generic map(
        wordSize => 64
      )
      port map(
        sel => memToReg,
        A => main_alu_out,
        B => dmOut,
        O => write_data
      );

    registers: regfile
      generic map (
        regn => 32,
        wordSize => 64
      )
      port map(
        clock => clock,
        reset => reset,
        regWrite => regWrite,
        rr1 => read_register1,
        rr2 => read_register2,
        wr => write_register,
        d => write_data,
        q1 => reg_output1,
        q2 => reg_output2
      );

    sign_extend: signExtend
      port map(
        i => instruction,
        o => extended_address
      );

    sl2: shiftLeft2
      generic map (
        wordSize => 64
      )
      port map(
        input => extended_address,
        output => sl2_output
      );

    dmAddr <= main_alu_out;
    dmIn <= reg_output2;
    imAddr <= pc_output;

end architecture datapath_arch;




--------------------------------------------------------------------------------
-- COMPONENTE PRINCIPAL: POLILEG
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.ALL;
use ieee.math_real.ALL;

entity polilegsc is
  port (
    clock, reset: in bit;
    -- Memoria de Dados
    dmem_addr: out bit_vector(63 downto 0);
    dmem_dati: out bit_vector(63 downto 0);
    dmem_dato: in  bit_vector(63 downto 0);
    dmem_we:   out bit;
    -- Memoria de Instrucoes
    imem_addr: out bit_vector(63 downto 0);
    imem_data: in  bit_vector(31 downto 0)
  );
end entity polilegsc;

architecture polilegsc_arch of polilegsc is
  component datapath is
    generic(
      wordSize: natural := 64
    );
    port(
      -- Comum
      clock: in bit;
      reset: in bit;
      -- Da Unidade de Controle
      reg2loc: in bit;
      pcsrc: in bit;
      memToReg: in bit;
      aluCtrl: in bit_vector(3 downto 0);
      aluSrc: in bit;
      regWrite: in bit;
      -- Para a Unidade de Controle
      opcode: out bit_vector(10 downto 0);
      zero: out bit;
      -- Interface com a memoria das instrucoes
      imAddr: out bit_vector(63 downto 0);
      imOut: in bit_vector(31 downto 0);
      -- Interface com a memoria dos dados
      dmAddr: out bit_vector(63 downto 0);
      dmIn: out bit_vector(63 downto 0);
      dmOut: in bit_vector(63 downto 0)
    );
  end component datapath;

  component alucontrol is
    port (
      aluop:   in  bit_vector(1 downto 0);
      opcode:  in  bit_vector(10 downto 0);
      aluCtrl: out bit_vector(3 downto 0)
    );
  end component alucontrol;
  
  component controlunit is
    port(
      reg2loc: out bit;
      uncondbranch: out bit;
      branch : out bit;
      memRead : out bit;
      memToReg: out bit;
      aluOp : out bit_vector(1 downto 0);
      memWrite: out bit;
      aluSrc : out bit;
      regWrite : out bit;
      opcode: in bit_vector(10 downto 0)
    );
  end component controlunit;

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
    dmem_we <=   '0' when memRead_s = '1' else
          '1' when memWrite_s = '1';
    
    zero_branch <= branch_s and zero_s;
    pcsrc_s <= uncondBranch_s or zero_branch;
    
    pl_datapath: datapath
      generic map(
        wordSize => 64
      )
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
        zero => zero_s, 
        imAddr => imem_addr, 
        imOut => imem_data, 
        dmAddr => dmem_addr, 
        dmIn => dmem_dati, 
        dmOut => dmem_dato
      );
          
    pl_controlunit: controlunit
      port map(
        reg2loc => reg2loc_s, 
        uncondbranch => uncondBranch_s, 
        branch => branch_s, 
        memRead => memRead_s, 
        memToReg => memToReg_s, 
        aluOp => aluOp_s, 
        memWrite => memWrite_s, 
        aluSrc => aluSrc_s, 
        regWrite => regWrite_s, 
        opcode => opcode_s
      );
    
    pl_alucontrol: alucontrol
      port map(
        aluop => aluOp_s, 
        opcode => opcode_s, 
        aluCtrl => aluctrl_s
      );
          
end architecture polilegsc_arch;
