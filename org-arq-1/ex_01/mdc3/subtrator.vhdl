library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtrator is
    generic(
        NumeroBits : integer := 8;
        Tsub : time := 3 ns
        );
    port (
        In1 : in STD_LOGIC_VECTOR(numeroBits - 1 downto 0);
        In2 : in STD_LOGIC_VECTOR(numeroBits - 1 downto 0);
        Out1 : out STD_LOGIC_VECTOR(numeroBits - 1 downto 0)
    );
end entity;

architecture subtratorArch of subtrator is
    begin
    
    process(In1,In2)
    begin
        Out1 <= std_logic_vector(unsigned(In1) - unsigned(In2));
    end process;

end subtratorArch;