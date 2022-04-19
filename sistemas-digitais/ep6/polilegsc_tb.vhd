library IEEE;
use IEEE.numeric_bit.all;
use std.textio.all;

entity tb_ram is
  generic (
    addressSize: natural := 64;
    wordSize : natural := 32;
    filename : string := "ram.dat"
  );
  port (
    clock, reset : in bit;
    addr : in bit_vector(addressSize-1 downto 0);
    input: in bit_vector(wordSize-1 downto 0);
    output : out bit_vector(wordSize-1 downto 0) 
  );
end tb_ram;

architecture behavioral of tb_ram is
  constant memSize: natural := 2**addressSize;
  type memType is array (0 to memSize-1) of bit_vector(wordSize-1 downto 0);

  impure function loadFromFile(path : in string) return memType is
    file my_file : text open read_mode is path;
    variable myLine : line;
    variable word : bit_vector(wordSize-1 downto 0);
    variable mem : memType;

    begin for i in memType'range loop
      readline(my_file, myLine);
      read(myLine, word);
      mem(i) := word;
    end loop;
    
    return mem;
  end;

  signal defaultMem: memType := ( 
    "1000000000000000000000000000000000000000000000000000000000000000", 
    "0000000000000000000000000000000000000000000000000000000000010000",
    "0000000000000000000000000000000000000000000000000000000000001100", 
    "0000000000000000000000000000000000000000000000000000000000000000"
  );
  begin
  main: process(clock) begin
    if (clock='1' and clock'event) then 
      if (reset='1') then
        defaultMem(to_integer(unsigned(addr))) <= input;
      end if;
    end if;
  end process;

  output <= defaultMem(to_integer(unsigned(addr)));
end behavioral;

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity tb_rom is
  generic(
    addressSize: natural := 64;
    wordSize : natural := 32;
    filename : string := "ram.dat"
  );
  port(
    addr : in bit_vector(addressSize-1 downto 0);
    output : out bit_vector(wordSize-1 downto 0)
  );
end tb_rom;

architecture behavioral of tb_rom is
  constant memSize: natural := 2**addressSize;
  type memType is array (0 to memSize-1) of bit_vector(wordSize-1 downto 0);

  impure function loadFromFile(path: in string) return memType is
    file my_file : text open read_mode is path;
    variable myLine : line;
    variable word : bit_vector(wordSize-1 downto 0);
    variable mem : memType;

    begin for i in memType'range loop
      readline(my_file, myLine);
      read(myLine, word); mem(i) := word;
    end loop;
    
    return mem;
  end;

  constant defaultMem: memType := ( 
    "11111000010000000000001111100001",
    "11111000010000001000001111100010", 
    "11111000010000010000001111100011", 
    "11001011000000110000000001000100",
    "10110100000000000000000100000100", 
    "11001011000000110000000001000100", 
    "10001010000000010000000010000101", 
    "10110100000000000000000001100101", 
    "11001011000000100000000001100011", 
    "00010111111111111111111111111010", 
    "11001011000000110000000001000010", 
    "00010111111111111111111111111000", 
    "11111000000000000100000000000010", 
    "00010100000000000000000000000000", 
    "00010100000000000000000000000000", 
    "00010100000000000000000000000000" 
  );

  begin output <= defaultMem(to_integer(unsigned(addr)));
end behavioral;

library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.floor;

entity polilegsc_tb is
end entity;

architecture behavioral of polilegsc_tb is
  component polilegsc is port(
    clock, reset: in bit;
    dmem_addr: out bit_vector(63 downto 0);
    dmem_dati: out bit_vector(63 downto 0);
    dmem_dato: in  bit_vector(63 downto 0);
    dmem_we:out bit;
    imem_addr: out bit_vector(63 downto 0);
    imem_data: in  bit_vector(31 downto 0));
  end component;

  component tb_rom is
    generic (
      addressSize : natural;
      wordSize : natural;
      filename : string);
    port (
      addr : in bit_vector(addressSize-1 downto 0);
      output : out bit_vector(wordSize-1 downto 0));
  end component;

  component tb_ram is
    generic (
      addressSize : natural;
      wordSize : natural;
      filename : string);
    port (
      clock, reset : in bit;
      addr : in bit_vector(addressSize-1 downto 0);
      input : in bit_vector(wordSize-1 downto 0);
      output : out bit_vector(wordSize-1 downto 0));
    end component;

  signal rom_data: bit_vector(31 downto 0);
  signal rom_addr, ram_addr, ram_input, ram_output: bit_vector(63 downto 0);
  signal ram_reset: bit;
  constant PERIOD : time := 1 ns;
  signal finished: boolean := false;
  signal clock, reset: bit:='0';

  begin
    clock <= not clock after PERIOD/2 when not finished else '0';

    theROM: tb_rom
      generic map (
        4,
        32,
        "rom.dat"
      )
      port map (
        rom_addr(5 downto 2),
        rom_data
      );

    theRAM: tb_ram
      generic map (
        2, 
        64, 
        "ram.dat"
      )
      port map (
        clock,
        ram_reset,
        ram_addr(4 downto 3),
        ram_input,
        ram_output
      );
    
    theCPU: polilegsc 
      port map (
        clock,
        reset,
        ram_addr,
        ram_input,
        ram_output,
        ram_reset,
        rom_addr,
        rom_data
      );

    main:process
    begin
      report "BOT";

      finished <= false;
      reset <= '1';
      wait until clock'event and clock='1';
      wait until clock'event and clock='0';

      reset <= '0';
      wait until ram_reset='1';
      wait until clock'event and clock='0'; 
      
      report "Valor final obtido: "
        & integer'image(to_integer(unsigned(ram_input)))
        & " esperado: 4.";

      assert to_integer(unsigned(ram_input)) /= 4 
        report "Valor final obtido condiz com o esperado. Teste passou.";
      
      assert to_integer(unsigned(ram_input)) = 4 
        report "Valor final obtido não condiz com o esperado. Teste falhou." 
        severity failure;
      
      wait for 20 ns;
      finished <= true;
      
      report "EOT";
      wait;
    end process;
end architecture behavioral;
