library IEEE;
use IEEE.numeric_bit.all;

entity rom_arquivo_generica_tb is
end rom_arquivo_generica_tb;

architecture rom_arquivo_generica_tb_arch of rom_arquivo_generica_tb is

  component rom_arquivo_generica is
    generic (
      addressSize: natural := 5;
      wordSize: natural := 8;
      datFileName: string := "conteudo_rom_ativ_02_carga.dat"
    );
    port (
      addr: in bit_vector(4 downto 0);
      data: out bit_vector(7 downto 0)
    );
  end component;

  signal addr_in: bit_vector(4 downto 0);
  signal data_out: bit_vector(7 downto 0);

  constant clock_period: time := 2 ns;
  signal clock_in: bit := '0';
  signal simulating: bit := '0';

  constant addressSize: natural := 5;
  constant wordSize: natural := 8;
  constant datFileName: string := "conteudo_rom_ativ_02_carga.dat";

begin

  DUT: rom_arquivo_generica 
  generic map(
    addressSize => 5,
    wordSize => 8,
    datFileName => "conteudo_rom_ativ_02_carga.dat"
  )
  port map(
    addr_in,
    data_out
  );
  
  clock_in <= (simulating and (not clock_in)) after clock_period/2;

  stimulus: process is
    type test_record is record
      addr: bit_vector(4 downto 0);
      data: bit_vector(7 downto 0);
    end record;

    type test_type is array (natural range <>) of test_record;
    constant tests: test_type := (
      ("00000", "00000000"),
      ("00001", "00000011"),
      ("00010", "11000000"),
      ("00011", "00001100"),
      ("00100", "00110000"),
      ("00101", "01010101"),
      ("00110", "10101010"),
      ("00111", "11111111"),
      ("01000", "11100000"),
      ("01001", "11100111"),
      ("01010", "00000111"),
      ("01011", "00011000"),
      ("01100", "11000011"),
      ("01101", "00111100"),
      ("01110", "11110000"),
      ("01111", "00001111"),
      ("10000", "11101101"),
      ("10001", "10001010"),
      ("10010", "00100100"),
      ("10011", "01010101"),
      ("10100", "01001100"),
      ("10101", "01000100"),
      ("10110", "01110011"),
      ("10111", "01011101"),
      ("11000", "11100101"),
      ("11001", "01111001"),
      ("11010", "01010000"),
      ("11011", "01000011"),
      ("11100", "01010011"),
      ("11101", "10110000"),
      ("11110", "11011110"),
      ("11111", "00110001")
    );
  begin
    report "Test start";

    for k in tests'range loop
      simulating <= '1';

      addr_in <= tests(k).addr;

      wait for clock_period;

      assert (tests(k).data = data_out)
        report "Fail: Expected value " & integer'image(to_integer(unsigned(tests(k).data)))
          & " at memory position " & integer'image(to_integer(unsigned(tests(k).addr)))
          & ". Encountered " & integer'image(to_integer(unsigned(data_out))) & "."
          severity error;
    end loop;

    report "Test end";
    simulating <= '0';
    wait;
  end process;

end architecture;
