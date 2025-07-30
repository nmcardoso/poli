library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_ClkEnable is
    generic(
        NumeroBits : INTEGER := 8;
        -- synthesis translate_off
        Tprop : TIME := 5 ns;
        Tsetup : TIME := 2 ns
        -- synthesis translate_on
    );
    port (
        C : in STD_LOGIC;
        CE : in STD_LOGIC;
        D : in STD_LOGIC_VECTOR(NumeroBits-1 downto 0);
        R : in STD_LOGIC;
        S : in STD_LOGIC;
        Q : out STD_LOGIC_VECTOR(NumeroBits-1 downto 0)
    );
end entity;

architecture Reg_ClkEnableArch of Reg_ClkEnable is
    begin

    process(C,S,R)
    begin   
        if R = '1' then 
            Q <= (others =>'0');
        elsif S = '1' then
            Q <= (others =>'1');
        elsif rising_edge(C) then
            if (CE='1') then
                Q <= D;
            end if;
        end if;
    end process;
    
end Reg_ClkEnableArch;