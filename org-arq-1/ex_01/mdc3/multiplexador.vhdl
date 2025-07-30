library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplexador is
    generic(
        NumeroBits : integer := 8;
        Tsel : time := 2 ns;
        Tdata : time := 1 ns
    );
    port (
        I0 : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
        I1 : in STD_LOGIC_VECTOR(NumeroBits - 1 downto 0);
        S : in STD_LOGIC;
        O : out STD_LOGIC_VECTOR(NumeroBits - 1 downto 0)
    );
end entity;

architecture multiplexadorArch of multiplexador is
    begin

    process(S)
    begin
        if (S='0') then 
            O <= I0;
        else 
            O <= I1;
        end if;
    end process;
    
end multiplexadorArch; 