library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdc3Tb is
end entity;

architecture mdc3TbArch of mdc3Tb is
    signal Set,Reset,Clock,Start,Ready,CEar,CEbr: std_logic;
    signal compara,igual,Menor,Selb: std_logic;
    signal Sela: std_logic_vector(1 downto 0);
    signal A,B,MDC: std_logic_vector(7 downto 0);
    signal done: std_logic:='0';

    begin
    Set<='0';
    gateFD: entity work.mdc3_fd
        port map(
            CEar=>CEar,
            CEbr=>CEbr,
            Clock=>Clock,
            Reset=>Reset,
            Selb=>Selb,
            Set=>Set,
            compara=>compara,
            A=>A,
            B=>B,
            Sela=>Sela,
            Igual=>Igual,
            Menor=>Menor,
            mdc=>MDC
        );

   gateUC: entity work.mdc3_uc
        port map(
            Reset=>Reset,
            Clock=>Clock,
            Start=>Start,
            Igual=>Igual,
            Menor=>Menor,
            Ready=>Ready,
            Sela=>Sela,
            Selb=>Selb,
            CEar=>CEar,
            CEbr=>CEbr,
            compara=>compara
        );

    Estimulos : process (Ready)
    begin
        start <= '1';
        A <= x"0A";
        B <= x"1A";
        if Ready = '1' then
            start <= '0';
            if MDC = x"02" then
                report "Correto!";
            else    
                report "Errado!";
            end if;
            done <= '1';
        end if;
    end process Estimulos;

    LAL : process
    begin
        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
        wait;
    end process LAL;
    
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
end mdc3TbArch;