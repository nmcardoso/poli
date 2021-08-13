library ieee;
-- use ieee.numeric_std.all;
use ieee.numeric_bit.all;

-- Tentativas:
-- 14110 (falha)


entity alu is
  generic(
    size: natural := 10 -- bit size
  );

  port(
    A, B: in bit_vector(size-1 downto 0); --inputs
    F: out bit_vector(size-1 downto 0); -- outputs
    S: in bit_vector(3 downto 0); -- op selection
    Z: out bit; -- zero flag
    Ov: out bit; -- overflow flag
    Co: out bit -- carry out
  );
end entity alu;

architecture alu_arch of alu is
  signal zeros: bit_vector(size-1 downto 0) := (others => '0');
  signal a_signed, b_signed, f_signed: signed(size downto 0) := (others => '0');
  signal f_expanded: bit_vector(size downto 0) := (others => '0');
  -- signal result: signed(size downto 0);
begin
  a_signed <= resize(signed(A), size + 1);
  b_signed <= resize(signed(B), size + 1);

  process(A, B, S)
    variable result: signed(size downto 0);
    -- variable f_expanded: bit_vector(size downto 0) := (others => '0');
  begin
    case S is
      when "0000" =>
        result := a_signed and b_signed;
      when "0001" =>
        result := a_signed or b_signed;
      when "0010" =>
        result := a_signed + b_signed;
      when "0110" =>
        result := a_signed - b_signed;
      when "0111" =>
        result := a_signed - b_signed;
        result := (size downto 1 => '0') & not(result(size));
      when others =>
        result := not(a_signed or b_signed);
    end case;

    if result = signed(zeros) then
      Z <= '1';
    else
      Z <= '0';
    end if;

    if result(size - 1) /= result(size) then
      Ov <= '1';
    else 
      Ov <= '0';
    end if;
    
    if result(size - 1) = '1' then
      Co <= '1';
    else
      Co <= '0';
    end if;

    -- Ov <= '1' when result(size - 1) /= output(size) else '0';
    -- Co <= '1' when result(size - 1) = '1' else '0';
    f_expanded <= bit_vector(result);
  end process;
  F <= f_expanded(size) & f_expanded(size - 2 downto 0);
end architecture alu_arch;