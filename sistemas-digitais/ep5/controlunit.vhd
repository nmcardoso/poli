--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #22792 (10)
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