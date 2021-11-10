--------------------------------------------------------------------------------
-- TENTATIVAS:
-- 01: #22761 (10)
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