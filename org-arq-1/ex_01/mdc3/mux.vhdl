library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX is
    port (
        A : in STD_LOGIC_VECTOR(7 downto 0);
        I3 : in STD_LOGIC_VECTOR(7 downto 0);
        Sela : in STD_LOGIC_VECTOR(1 downto 0);
        bq : in STD_LOGIC_VECTOR(7 downto 0);
        sub_s : in STD_LOGIC_VECTOR(7 downto 0);
        ad : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture MUXArch of MUX is
    begin

    with Sela select ad <=
        A when "01",
        bq when "10",
        I3 when "11",
        sub_s when "00",
        "00000000" when others;

end MUXArch;