library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sinalizador is
  port (
    vagas, contagem: in std_logic_vector(3 downto 0);
    cheio: out std_logic
  );
end sinalizador;

architecture sinalizador_arch of sinalizador is
begin  
  cheio <= '0' when vagas > contagem else '1';
  -- vazio <= '1' when contagem = "0000" else '0';
end sinalizador_arch;
