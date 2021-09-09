library IEEE;
use IEEE.numeric_bit.all;

-- Tentativas:
-- 01: #18522 (10)

entity ram is
  generic (
    addressSize: natural := 5;
    wordSize: natural := 8
  );
  port (
    ck, wr: in bit;
    addr: in bit_vector(addressSize - 1 downto 0);
    data_i: in bit_vector(wordSize - 1 downto 0);
    data_o: out bit_vector(wordSize - 1 downto 0)
  );
end ram;

architecture ram_arch of ram is
  
  type mem_type is array(0 to 2 ** addressSize - 1) of bit_vector(wordSize - 1 downto 0);
  signal mem: mem_type;

begin

  process(ck)
  begin
    if (ck'event and ck = '1') then
      if (wr = '1') then
        mem(to_integer(unsigned(addr))) <= data_i;
      end if;
    end if;
  end process;

  data_o <= mem(to_integer(unsigned(addr)));

end architecture;