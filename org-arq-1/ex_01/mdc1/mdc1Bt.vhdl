Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdc1Bt is
    port(
        A:out STD_LOGIC_VECTOR(7 downto 0);
        B:out STD_LOGIC_VECTOR(7 downto 0);
        MDC:in STD_LOGIC_VECTOR(7 downto 0)
    );
end mdc1Bt;

architecture mdc1BtArch of mdc1Bt is
    Begin

    estimulos : process
    begin
        -- MDC(10, 26) = 2
        a <= x"0A"; 
        b <= x"1A";
        assert MDC /= x"02" report "Erro";
        wait for 10 ns;
        
        -- MDC(10, 26) = 1
        b <= x"1D";
        assert MDC /= x"01" report "Erro";
        wait for 10 ns;

        -- MDC(15, 45) = 15
        a <= x"0F";
        b <= x"2D";
        assert MDC /= x"0F" report "Erro";
        wait for 10 ns;

        -- MDC(63, 105) = 21
        a <= x"3F";
        b <= x"69";
        assert MDC /= x"15" report "Erro";
        wait for 10 ns;

        -- MDC(117, 195) = 39
        a <= x"75";
        b <= x"C3";
        assert MDC /= x"27" report "Erro";
        wait for 10 ns;
        
        wait;
    end process;
end mdc1BtArch; 