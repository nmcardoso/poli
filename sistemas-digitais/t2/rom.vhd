library ieee;
use ieee.numeric_std.all;
use std.textio.all;

-- Tentativas:
-- #13962
-- #13963 (sucesso)

entity rom is
  port(
    addr: in  bit_vector(7 downto 0);
    data: out bit_vector(31 downto 0)
  );
end rom;

