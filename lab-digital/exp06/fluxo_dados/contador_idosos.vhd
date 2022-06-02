-- contador_idosos.vhd
-- contador de idosos

-- library IEEE;
-- use IEEE.std_logic_1164.all;
-- use IEEE.numeric_std.all;

-- entity contador_idosos is
--   port (
--     clock, zera, conta_i, direcao_i: in std_logic;
--     conta_o, direcao_o: out std_logic;
--     contagem: out std_logic_vector(3 downto 0)
--   );
-- end contador_idosos;

-- architecture contador_idosos_arch of contador_idosos is
--   component contador is
--     port (
--       clock, zera, conta, direcao: in std_logic;
--       contagem: out std_logic_vector(3 downto 0)
--     );
--   end component;

--   signal qtd_vagas: std_logic_vector(3 downto 0);
--   signal conta: std_logic;
-- begin
--   conta_o <= conta_i;
--   direcao_o <= direcao_i;
--   contador_1: contador port map (
--     clock => clock, 
--     zera => zera, 
--     conta => conta_i, 
--     direcao => direcao_i, 
--     contagem => qtd_vagas
--   );
-- end contador_idosos_arch;
