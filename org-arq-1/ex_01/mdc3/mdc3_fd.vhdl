library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mdc3_fd is
    port(
        CEar : in STD_LOGIC;
        CEbr : in STD_LOGIC;
        Clock : in STD_LOGIC;
        Reset : in STD_LOGIC;
        Selb : in STD_LOGIC;
        Set : in STD_LOGIC;
        compara : in STD_LOGIC;
        A : in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC_VECTOR(7 downto 0);
        Sela : in STD_LOGIC_VECTOR(1 downto 0);
        Igual : out STD_LOGIC;
        Menor : out STD_LOGIC;
        mdc : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture mdc3_fdArch of mdc3_fd is
    signal ad,bd: std_logic_vector(7 downto 0);
    signal sub_s,bq: std_logic_vector(7 downto 0);
    signal aq: std_logic_vector(7 downto 0);
    begin

    mdc<=aq;
    gate1: entity work.Reg_ClkEnable
        generic map(
            Tprop => 0 ns,
            Tsetup => 0 ns
        )
        port map(
            S=>Set,
            D=>bd,
            Ce=>CEbr,
            C=>Clock,
            Q=>bq,
            R=>Reset
        );

    gate2: entity work.Reg_ClkEnable
        generic map(
            Tprop => 0 ns,
            Tsetup => 0 ns
        )
        port map(
            S=>Set,
            D=>ad,
            Ce=>CEar,
            C=>Clock,
            Q=>aq,
            R=>Reset
        );

    gate3: entity work.multiplexador
        generic map(
            Tsel => 0 ns,
            Tdata => 0 ns
        )
        port map(
            I0=>B,
            I1=>aq,
            S=>Selb,
            O=>bd
        );

    gate5: entity work.subtrator
        generic map(
            Tsub => 0 ns
        )
        port map(
            In1=>aq,
            In2=>bq,
            Out1=>sub_s
        );

    gate6: entity work.comparador
        port map(
            aq=>aq,
            bq=>bq,
            compara=>compara,
            Igual=>Igual,
            Menor=>Menor
        );

    gate7: entity work.MUX
        port map(
            A=>A,
            bq=>bq,
            I3=>"00000000",
            sub_s=>sub_s,
            Sela=>Sela,
            ad=>ad
        );

end mdc3_fdArch;