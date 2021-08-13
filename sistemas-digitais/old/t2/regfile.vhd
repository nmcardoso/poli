library ieee;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- Tentativas:
-- 14056 (5.2)
-- 14058 (5.2)
-- 14060 (9.6)


entity regfile is
  generic(
    regn: natural := 32;
    wordSize: natural := 64
  );

  port(
    clock: in bit;
    reset: in bit;
    regWrite: in bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
    d: in bit_vector(wordSize - 1 downto 0);
    q1, q2: out bit_vector(wordSize - 1 downto 0)
  );
end regfile;


architecture regfile_arch of regfile is
  type register_type is array(0 to regn - 1) of bit_vector(wordSize - 1 downto 0);

  function bv_to_natural(bv: in bit_vector) return natural is
    variable result : natural := 0;
  begin
    for index in bv'range loop
      result := result * 2 + bit'pos(bv(index));
    end loop;
    return result;
  end bv_to_natural;

  signal zeros: bit_vector(wordSize - 1 downto 0) := (others => '0');
  -- signal reg: register_type := (others => zeros);
begin
  process(clock, reset)
    variable reg: register_type := (others => zeros);
  begin
    if reset = '1' then
    -- if rising_edge(reset) then
      reg := (others => zeros);
    -- elsif clock'event and clock = '1' and clock'last_value = '0' then
    elsif rising_edge(clock) then
      if regWrite = '1' then
        if bv_to_natural(wr) /= (natural(ceil(log2(real(regn)))) - 1) then
          reg(bv_to_natural(wr)) := d;
        end if;
      end if;
    end if;
    q1 <= reg(bv_to_natural(rr1));
    q2 <= reg(bv_to_natural(rr2));
  end process;
  
end architecture;