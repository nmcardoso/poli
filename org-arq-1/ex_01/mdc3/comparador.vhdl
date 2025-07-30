library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador is
    port (
        aq : in STD_LOGIC_VECTOR(7 downto 0);
        bq : in STD_LOGIC_VECTOR(7 downto 0);
        compara : in STD_LOGIC;
        Igual : out STD_LOGIC;
        Menor : out STD_LOGIC
    );
end entity;

architecture ComparadorArch of comparador is
    begin

    process(aq,bq,compara)
    begin
            if (aq = bq) then
                Igual <= '1';
                Menor <= '0';
            elsif (bq<aq) then
                Igual <= '0';
                Menor <= '0';
            else 
                Igual <= '0';
                Menor <= '1';
            end if;
    end process;
    
end ComparadorArch;