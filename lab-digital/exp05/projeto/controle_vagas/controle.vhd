-- controle.vhd
-- controle de vagas de estacionamento

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controle is
  port (
    clock, zera, conta, direcao: in std_logic;
    vagas: in std_logic_vector(3 downto 0);
    contagem: out std_logic_vector(3 downto 0);
    cheio: out std_logic
  );
end controle;

architecture controle_arch of controle is

  component contador is
    port (
      clock, zera, conta, direcao: in std_logic;
      contagem: out std_logic_vector(3 downto 0)
    );
  end component;
  
  component sinalizador is
    port (
      vagas, contagem: in std_logic_vector(3 downto 0);
      fim: out std_logic
    );
  end component;
  
  signal quant_vagas: std_logic_vector(3 downto 0);

begin
  contagem <= quant_vagas;
  contador_1: contador port map (clock, zera, conta, direcao, quant_vagas);
  sinalizador_1: sinalizador port map (vagas, quant_vagas, cheio);
end controle_arch;
