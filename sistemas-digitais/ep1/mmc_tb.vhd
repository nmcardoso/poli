library IEEE;
use IEEE.numeric_bit.all;

entity mmc_tb is
end mmc_tb;

architecture tb_arch of mmc_tb is
  component mmc is
    port(
      reset, clock: in bit;
      inicia: in bit;
      A, B: in bit_vector(7 downto 0);
      fim: out bit;
      nSomas: out bit_vector(8 downto 0);
      MMC: out bit_vector(15 downto 0)
    );
  end component;

  signal reset_in, inicia_in: bit;
  signal A_in, B_in: bit_vector(7 downto 0);
  signal MMC_out: bit_vector(15 downto 0);
  signal nSomas_out: bit_vector(8 downto 0);
  signal fim_out: bit;

  constant clock_period: time := 2 ns;
  signal clock_in: bit := '0';
  signal simulating: bit := '0';
  signal numSimu: integer := 0;
  signal rco: bit;
  signal contadorAux: unsigned(15 downto 0);
begin

  DUT: mmc port map (
    reset_in,
    clock_in,
    inicia_in,
    A_in,
    B_in,
    fim_out,
    nSomas_out,
    MMC_out
  );

  clock_in <= (simulating and (not clock_in)) after clock_period/2;

  stimulus: process is
    type test_record is record
      reset, inicia: bit;
      A, B: bit_vector(7 downto 0);
      fim: bit;
      nSomas: bit_vector(8 downto 0);
      MMC: bit_vector(15 downto 0);
      str: string(1 to 3);
    end record;

    type test_type is array (natural range <>) of test_record;
    constant tests: test_type := (
      ('1', '0', "00000000", "00000000", '0', "000000000", "0000000000000000", "R01"),
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
      ('0', '0', "00000000", "00000000", '1', "001111111", "0000000010000000", "P20")
    );

  
    begin
      report "Test start." severity note;

      -- simulating <= '1';

      -- reset_in <= '0';
      -- inicia_in <= '1';
      -- B_in <= "00010000";
      -- -- B_in <= "00001100";

      -- -- A_in <= "10000000";
      -- A_in <= "00000000";

      -- wait for  2 ns;

      -- inicia_in <= '0';

      -- wait for 34 ns;


      -- inicia_in <= '1';


      -- wait for 600 ns;




      -- for t in tests'range loop
      --   reset_in <= tests(t).reset;
      --   inicia_in <= tests(t).inicia;
      --   A_in <= tests(t).A;
      --   B_in <= tests(t).B;

      --   wait for clock_period;

      --   wait until (fim_out = '1');

      --   wait for clock_period / 2;

      --   assert ()

      --   wait for 4 * clock_period;
      -- end loop;


      for k in tests'range loop
        simulating <= '1';
        reset_in <= '1';
        inicia_in <= '0';
        A_in <= "00000000";
        B_in <= "00000000";
          
        wait for clock_period/8;
        
        reset_in <= tests(k).reset;
        inicia_in <= tests(k).inicia;
        A_in <= tests(k).A;
        B_in <= tests(k).B;
      
        wait for clock_period/8;
      
        if (tests(k).str = "P16") then
          wait for clock_period*2;
          reset_in <= '1';
          wait for clock_period/16;
          assert (tests(k).fim = fim_out)
            report "Fail:Resetfim" & tests(k).str severity error;
          assert (tests(k).nSomas = nSomas_out)
            report "Fail:ResetnSomas" & tests(k).str severity error;
          assert (tests(k).MMC = MMC_out)
            report "Fail:ResetMMC" & tests(k).str severity error;
        end if;
      
        if (tests(k).str = "P17") then
          wait for clock_period*1.05;
          A_in <= "00000000";
          wait until (fim_out = '1' or contadorAux > 2001);
          wait for clock_period/16;
          assert (tests(k).fim = fim_out)
            report "Fail:EntradaMudoufim" & tests(k).str severity error;
          assert (tests(k).nSomas = nSomas_out)
            report "Fail:EntradaMudounSomas" & tests(k).str severity error;
          assert (tests(k).MMC = MMC_out)
            report "Fail:EntradaMudouMMC" & tests(k).str severity error;
        end if;
        
        if (tests(k).str = "P18") then
          wait until (fim_out = '1' or contadorAux > 2001);
          wait for clock_period/16;
          assert ('1' = fim_out)
            report "Fail:2seguidas/1fim" & tests(k).str severity error;
          assert ("001111111" = nSomas_out)
            report "Fail:2seguidas/1nSomas" & tests(k).str severity error;
          assert ("0000000010000000" = MMC_out)
            report "Fail:2seguidas/1MMC" & tests(k).str severity error;
          wait for clock_period;
          reset_in<='1';
          wait for clock_period;
          reset_in<='0';
          A_in <= "00001100";
          B_in <= "00010000";
          inicia_in <= '1';
          wait until( fim_out = '1' or contadorAux > 2001);
          wait for clock_period/16;
          assert (tests(k).fim = fim_out)
            report "Fail:2seguidas/2fim" & tests(k).str severity error;
          assert (tests(k).nSomas = nSomas_out)
            report "Fail:2seguidas/2nSomas" & tests(k).str severity error;
          assert (tests(k).MMC = MMC_out)
            report "Fail:2seguidas/2MMC" & tests(k).str severity error;
          simulating <= '0';
        end if;

        numSimu <= numSimu + 1;
        
        if (tests(k).str = "P19") then
          wait for clock_period;
          A_in <= "11110000";
          B_in <= "01010100";
          wait for clock_period;
          A_in <= "01010000";
          B_in <= "11001001";
          wait for clock_period;
          A_in <= "10000000";
          B_in <= "00000001";
          inicia_in <= '1';
          wait until( fim_out = '1' or contadorAux > 2001);
          wait for clock_period/16;
          assert (tests(k).fim = fim_out)
            report "Fail:EntradasVariandofim" & tests(k).str severity error;
          assert (tests(k).nSomas = nSomas_out)
            report "Fail:EntradasVariandonSomas" & tests(k).str severity error;
          assert (tests(k).MMC = MMC_out)
            report "Fail:EntradasVariandoMMC" & tests(k).str severity error;
          simulating <= '0';
        end if;
        
        if (tests(k).str = "P20") then
          wait for clock_period;
          A_in <= "11110000";
          B_in <= "01010100";
          wait for clock_period;
          A_in <= "00000000";
          B_in <= "00000000";
          inicia_in <= '1';
          wait for clock_period/320;
          inicia_in <= '0';
          wait for clock_period;
          A_in <= "10000000";
          B_in <= "00000001";
          inicia_in <= '1';
          wait until (fim_out = '1' or contadorAux > 2001);
          wait for clock_period/16;
          assert (tests(k).fim = fim_out)
            report "Fail:EntradasVariandofim" & tests(k).str severity error;
          assert (tests(k).nSomas = nSomas_out)
            report "Fail:EntradasVariandonSomas" & tests(k).str severity error;
          assert (tests(k).MMC = MMC_out)
            report "Fail:EntradasVariandoMMC" & tests(k).str severity error;
          simulating <= '0';
        end if;


        if (inicia_in = '1' and reset_in = '0' and tests(k).str /= "P16" 
            and tests(k).str /= "P17" and tests(k).str /= "P18" 
            and tests(k).str /= "P19" and tests(k).str /= "P20") then
          wait until (fim_out = '1' or contadorAux > 2001);
          simulating <= '0';
        end if;
        
        wait for clock_period/16;
        assert (tests(k).fim = fim_out)
          report "Fail:fim" & tests(k).str severity error;
        assert (tests(k).nSomas = nSomas_out)
          report "Fail:nSomas" & tests(k).str severity error;
        assert (tests(k).MMC = MMC_out)
          report "Fail:MMC" & tests(k).str severity error;
        if (contadorAux > 2001) then
          report "Fail:Utilizou mais de 2000 clocks"severity error;
        end if;

        wait for 8 * clock_period;
      end loop;

      report "Test end." severity note;
      simulating <= '0';
      wait;
    end process;
end architecture;
