---- contador_vagas.vhd
-- contador de idosos

-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity contador_vagas is
--   port (
--     clock, zera, conta, direcao: in std_logic;
--     contagem: out std_logic_vector(3 downto 0)
--   );
-- end contador_vagas;

-- architecture contador_vagas_arch of contador_vagas is
--   component contador is
--     port (
--       clock, zera, conta, direcao: in std_logic;
--       contagem: out std_logic_vector(3 downto 0)
--     );
--   end component;

--   signal qtd_vagas: std_logic_vector(3 downto 0);
--   signal conta: std_logic;
-- begin
--   contador_1: contador port map (
--     clock => clock,
--     zera => zera,
--     conta => conta,
--     direcao => direcao,
--     contagem => qtd_vagas
--   );
-- end contador_vagas_arch;
