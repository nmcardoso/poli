library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mdc2Tb is
end mdc2Tb;

architecture BancadaDeTeste2  of mdc2Tb is
    signal Ready: STD_LOGIC;
    signal MDC: STD_LOGIC_VECTOR(7 downto 0);
    signal Clock: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal Start: STD_LOGIC;
    signal A: STD_LOGIC_VECTOR(7 downto 0);
    signal B: STD_LOGIC_VECTOR(7 downto 0);
    signal done: std_logic := '0';	 
	
    begin
    gate0: entity work.MDC2
        port map(A=>A,B=>B,MDC=>MDC,Reset=>Reset,Start=>Start,Clock=>Clock,Ready=>Ready);

    stim_proc : process (Ready)
    begin
        start <= '1';
        A <= x"12";
        B <= x"0C";
        if Ready = '1' then
            start <= '0';
            assert MDC = x"06" report "Erro";
            done <= '1';
        end if;
    end process;

    lal_proc : process
    begin
        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
        wait;
    end process;
    
    relogio_proc : process
    variable relogio: std_logic := '0';
    begin
        while done = '0' loop
            Clock <= relogio;
            relogio := not relogio;
            wait for 10 ns;
        end loop;
        wait;
    end process;
end BancadaDeTeste2;