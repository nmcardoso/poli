library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdc1 is
    port(
        A:in STD_LOGIC_VECTOR(7 downto 0);
        B:in STD_LOGIC_VECTOR(7 downto 0);
        MDC:out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture mdc1Arch of mdc1 is
    Begin
    --- Processes ----
    Algoritmo_MDC :process (A, B)
    variable xv, yv, xvv : std_logic_vector(7 downto 0);
    begin
        xv := A;
        yv := B;
        while (xv /= yv) loop -- Idle
            if (xv < yv) then -- Swap
                xvv := xv;
                xv := yv;
                yv := xvv;
            end if;
                xv := std_logic_vector(unsigned(xv) - unsigned(yv)); -- Sub
        end loop;
        MDC <= xv; -- Stop
    end process Algoritmo_MDC;
end mdc1Arch;