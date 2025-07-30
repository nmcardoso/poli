Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mdc1Tb is
end mdc1Tb;

architecture mdc1TbArch of mdc1Tb is
    signal A,B,MDC: std_logic_vector(7 downto 0); 
    Begin

    gate0: entity work.mdc1
        port map(
            A=>A,
            B=>B,
            MDC=>MDC
        );

    gate1: entity work.mdc1Bt
        port map(
            A=>A,
            B=>B,
            MDC=>MDC
    );    
end mdc1TbArch; 