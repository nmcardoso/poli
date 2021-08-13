library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	generic(
		address_size_in_bits: natural := 64;
		word_size_in_bits: natural := 32;
		delay_in_clocks: positive := 1
	);
	port(
		ck, enable, write_enable: in bit;
		addr: in std_logic_vector(address_size_in_bits - 1 downto 0);
		data: inout std_logic_vector(word_size_in_bits - 1 downto 0);
		bsy: out bit
	);
end ram;

architecture ram_arch of ram is
type mem_type is array(0 to 2 ** address_size_in_bits - 1) of std_logic_vector(word_size_in_bits - 1 downto 0);
signal mem: mem_type;
signal timer: std_logic_vector(delay_in_clocks downto 0) := (others => '0');
signal bsy_signal: bit := '0';
begin
	b: process(ck) is 
		begin
			if (ck'event and ck = '1') then
				if bsy_signal = '1' then
					timer <= timer(timer'high - 1 downto 0) & '0';
					
					if unsigned(timer) = 0 then
						bsy <= '0';
						bsy_signal <= '0';
					end if;
				end if;
				
				if (enable = '1') and (enable'last_value = '0') then
					bsy <= '1';
					bsy_signal <= '1';
					timer <= (others => '1');
				end if;	
			end if;
		end process b;
	p: process(bsy_signal) is
		begin
			if (bsy_signal = '1') then
				data <= (others => 'Z');
				if write_enable = '0' then
					mem(to_integer(unsigned(addr))) <= data;
				end if;
				if (write_enable = '1') and (enable = '0') then
					data <= mem(to_integer(unsigned(addr)));
				else
					data <= (others => 'Z');
				end if;
			end if;
	end process p;
--	process(ck, addr, write_enable, enable) is
--		begin
--		if (ck'event and ck = '1') then
--			data <= (others => 'Z');
--			if write_enable = '0' then
--				mem(to_integer(unsigned(addr))) <= data;
--			end if;
--			if (write_enable = '1') and (enable = '0') then
--				data <= mem(to_integer(unsigned(addr)));
--			else
--				data <= (others => 'Z');
--			end if;
--		end if;
--	end process;
end ram_arch;