-- comparador.vhd
-- comparador binario com entradas de 2 bits

library IEEE;
use IEEE.std_logic_1164.all;

-- definição das portas de entrada e saída
entity comparador is
  port (
    A, B: in std_logic_vector(1 downto 0);
    igual: out std_logic
  );
end comparador;

-- descrição das ligações internas do circuito
architecture comportamental of comparador is
begin
  -- o sinal igual terá nível lógico alto sempre que os sinais A e B
  -- tiverem o mesmo nível lógico, caso contrário terá nível lógico baixo
  igual <= '1' when A=B else '0';
end comportamental;
