-- Code your testbench here
-- Code your testbench here
library IEEE;
use IEEE.numeric_bit.all;

entity counter16 is
    port (
        clock, reset : in bit;
        count : in bit;
        rco : out bit;
        cval : out bit_vector(15 downto 0)
    );
begin
end entity;

architecture simple of counter16 is
    signal internal : unsigned(15 downto 0);
begin
    process (clock, reset)
    begin
        if reset = '1' then
            internal <= (others => '0'); -- "000000000"
        elsif (rising_edge(clock)) then
            if count = '1'then
                if (internal = "1111111111111111") then
                    rco <= '1';
                else
                    rco <= '0';
                end if;

                internal <= internal + 1;
            end if;
        end if;
    end process;
    cval <= bit_vector(internal);

end architecture;

library IEEE;
use IEEE.numeric_bit.all;
entity testbench is
end testbench;
architecture tb of testbench is
    component mmc is
        port (
            reset, clock : in bit;
            inicia : in bit;
            A, B : in bit_vector(7 downto 0);
            fim : out bit;
            nSomas : out bit_vector(8 downto 0);
            MMC : out bit_vector(15 downto 0)
        );
    end component;
    component counter16 is
        port (
            clock, reset : in bit;
            count : in bit;
            rco : out bit;
            cval : out bit_vector(15 downto 0)
        );
    end component;

    signal clk_in, reset_in, inicia_in, fim_out : bit;
    signal A_in, B_in : bit_vector (7 downto 0);
    signal nSomas_out : bit_vector (8 downto 0);
    signal MMC_out, contador : bit_vector (15 downto 0);
    signal rco : bit;
    signal contadorAux : unsigned(15 downto 0);

    constant clockPeriod : time := 2 ns; -- clock period
    signal keep_simulating : bit := '0'; -- interrompe simulação
    signal clk_proc : bit; -- se construção alternativa do clock

    signal reset_count: bit;
begin
    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
    DUT : mmc port map(reset_in, clk_in, inicia_in, A_in, B_in, fim_out, nSomas_out, MMC_out);

    contadorAux <= unsigned(contador);
    xContador16 : counter16 port map(clk_in, reset_count, keep_simulating, rco, contador);

    stimulus : process is -- Processo de testes
        -- Estrutura de dados com testes
        type test_record is record
            reset : bit; -- Nota: sem clock!
            inicia : bit;
            A, B : bit_vector(7 downto 0);
            fim : bit;
            nSomas : bit_vector(8 downto 0);
            MMC : bit_vector(15 downto 0);
            str : string(1 to 3); -- comment
        end record;
        -- Vetor com testes
        type tests_array is array (natural range <>) of test_record;
        constant tests : tests_array :=
        -- R   in       A           B      fim    nSomas          MMC        str
        (('1', '0', "00000000", "00000000", '0', "000000000", "0000000000000000", "R01"),
        ('0', '1', "00001100", "00010000", '1', "000000101", "0000000000110000", "P01"),
        ('0', '1', "00000000", "00000000", '1', "000000000", "0000000000000000", "P02"),
        ('0', '0', "00000000", "00000000", '0', "000000000", "0000000000000000", "P03"),
        ('0', '1', "00000011", "00000000", '1', "000000000", "0000000000000000", "P04"),
        ('0', '1', "00000000", "01000000", '1', "000000000", "0000000000000000", "P05"),
        ('1', '0', "00000011", "00000000", '0', "000000000", "0000000000000000", "P06"),
        ('1', '0', "00011000", "00000010", '0', "000000000", "0000000000000000", "P07"),
        ('1', '0', "00000000", "00100000", '0', "000000000", "0000000000000000", "P08"),
        ('1', '1', "00000000", "00001100", '0', "000000000", "0000000000000000", "P09"),
        ('1', '1', "10000000", "00000000", '0', "000000000", "0000000000000000", "P10"),
        ('0', '1', "00001100", "00010000", '1', "000000101", "0000000000110000", "P11"),
        ('1', '1', "00000000", "00000000", '0', "000000000", "0000000000000000", "P12"),
        ('1', '0', "00000000", "00000000", '0', "000000000", "0000000000000000", "P13"),
        ('0', '1', "10000000", "00000001", '1', "001111111", "0000000010000000", "P14"),
        ('0', '1', "00000011", "00000011", '1', "000000000", "0000000000000011", "P15"),
        ('0', '1', "10000000", "00000001", '0', "000000000", "0000000000000000", "P16"),
        ('0', '1', "10000000", "00000001", '1', "001111111", "0000000010000000", "P17"),
        ('0', '1', "10000000", "00000001", '1', "000000101", "0000000000110000", "P18"),
        ('0', '0', "00000000", "00000000", '1', "001111111", "0000000010000000", "P19"),
        ('0', '0', "00000000", "00000000", '1', "001111111", "0000000010000000", "P20"),
        ('0', '0', "00000000", "00000000", '1', "001111111", "0000000010000000", "P21"),
        ('0', '1', "00000000", "00010000", '1', "000000000", "0000000000000000", "P22"),
        ('0', '1', "11111111", "00000001", '1', "011111110", "0000000011111111", "P23"),
        ('0', '1', "11111111", "11111110", '1', "111111011", "1111110100000010", "P24"), 
        ('0', '1', "00000001", "00000010", '1', "000000001", "0000000000000010", "P25"),
        ('0', '1', "00001100", "00010000", '1', "000000101", "0000000000110000", "P26"),
        ('0', '1', "10000000", "00000001", '1', "001111111", "0000000010000000", "P27"),
        ('0', '1', "11111111", "00000001", '1', "011111110", "0000000011111111", "P28"),
        ('0', '1', "11111111", "11111110", '1', "111111011", "1111110100000010", "P29"));

    begin -- Conteúdo dos testes
        assert false report "Test start." severity note;
        keep_simulating <= '1'; -- Habilita clock

        for k in tests'range loop
            keep_simulating <= '1';
            reset_count <= '1';

            if (tests(k).str /= "P23" and tests(k).str /= "P24" and tests(k).str /= "P25" and tests(k).str /= "P26" and tests(k).str /= "P27" and tests(k).str /= "P28" and tests(k).str /= "P29") then
                reset_in <= '1';
                inicia_in <= '0';
                A_in <= "00000000";
                B_in <= "00000000";
            end if;

            wait for clockPeriod/8;

            reset_count <= '0';
            reset_in <= tests(k).reset;
            inicia_in <= tests(k).inicia;
            A_in <= tests(k).A;
            B_in <= tests(k).B;

            wait for clockPeriod/8;

            if (tests(k).str = "P16") then
                wait for clockPeriod * 2;
                reset_in <= '1';
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:Resetfim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:ResetnSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:ResetMMC" & tests(k).str severity error;
            end if;

            if (tests(k).str = "P17") then
                wait for clockPeriod * 1.05;
                A_in <= "00000000";
                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:EntradaMudoufim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:EntradaMudounSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:EntradaMudouMMC" & tests(k).str severity error;
            end if;

            if (tests(k).str = "P18") then
                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert ('1' = fim_out)
                report "Fail:2seguidas/1fim" & tests(k).str severity error;
                assert ("001111111" = nSomas_out)
                report "Fail:2seguidas/1nSomas" & tests(k).str severity error;
                assert ("0000000010000000" = MMC_out)
                report "Fail:2seguidas/1MMC" & tests(k).str severity error;
                wait for clockPeriod;
                A_in <= "00001100";
                B_in <= "00010000";
                inicia_in <= '1';
                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:2seguidas/2fim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:2seguidas/2nSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:2seguidas/2MMC" & tests(k).str severity error;
                keep_simulating <= '0';
            end if;

            if (tests(k).str = "P19") then
                wait for clockPeriod;
                A_in <= "11110000";
                B_in <= "01010100";
                wait for clockPeriod;
                A_in <= "01010000";
                B_in <= "11001001";
                wait for clockPeriod;
                A_in <= "10000000";
                B_in <= "00000001";
                inicia_in <= '1';
                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:EntradasVariandofim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:EntradasVariandonSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:EntradasVariandoMMC" & tests(k).str severity error;
                keep_simulating <= '0';
            end if;

            if (tests(k).str = "P20") then
                wait for clockPeriod;
                A_in <= "11110000";
                B_in <= "01010100";
                wait for clockPeriod;
                A_in <= "00000000";
                B_in <= "00000000";
                inicia_in <= '1';
                wait for clockPeriod/320;
                inicia_in <= '0';
                wait for clockPeriod;
                A_in <= "10000000";
                B_in <= "00000001";
                inicia_in <= '1';
                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:EntradasVariandofim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:EntradasVariandonSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:EntradasVariandoMMC" & tests(k).str severity error;
                keep_simulating <= '0';
            end if;

            if (tests(k).str = "P21") then
                wait for clockPeriod;
                A_in <= "10000000";
                B_in <= "00000001";
                inicia_in <= '1';

                wait for clockPeriod;
                inicia_in <= '0';

                wait until(fim_out = '1' or contadorAux > 2001);
                wait for clockPeriod/16;
                assert (tests(k).fim = fim_out)
                report "Fail:IniciaZeroufim" & tests(k).str severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:IniciaZerouSomas" & tests(k).str severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:IniciaZerouMMC" & tests(k).str severity error;
                keep_simulating <= '0';
            end if;

            if (inicia_in = '1' and reset_in = '0' and tests(k).str /= "P16" and tests(k).str /= "P17" and tests(k).str /= "P18" and tests(k).str /= "P19" and tests(k).str /= "P20" and tests(k).str /= "P21") then
                wait until(fim_out = '1' or contadorAux > 2001);
                keep_simulating <= '0';
            end if;

            wait for clockPeriod/16;
            if (contadorAux > 2001) then
                report "Fail:Utilizou mais de 2000 clocks"severity error;
            else 
                assert (tests(k).fim = fim_out)
                report "Fail:fim" & tests(k).str & ": " & bit'image(tests(k).fim) & "->" & bit'image(fim_out) & " (r:"& bit'image(tests(k).reset) & " - i:" & bit'image(tests(k).inicia) & ")" severity error;
                assert (tests(k).nSomas = nSomas_out)
                report "Fail:nSomas" & tests(k).str & ": " & integer'image(to_integer(unsigned(tests(k).nSomas))) & "->" & integer'image(to_integer(unsigned(nSomas_out))) severity error;
                assert (tests(k).MMC = MMC_out)
                report "Fail:MMC" & tests(k).str & ": " & integer'image(to_integer(unsigned(tests(k).MMC))) & "->" & integer'image(to_integer(unsigned(MMC_out))) severity error;
            end if;
            
            inicia_in <= '0';
        end loop;

        -- End of test
        assert false report "Test done." severity note;
        keep_simulating <= '0'; -- Desabilita clock
        wait; -- Fim da execucao
    end process;
end tb;