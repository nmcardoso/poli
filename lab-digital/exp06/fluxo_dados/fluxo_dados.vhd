-- fluxo_dados.vhd
-- contador de idosos

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fluxo_dados is
  port(
    clock, zera: in std_logic;
    vagas: in std_logic_vector(3 downto 0);
    conta_vagas, direcao_vagas: in std_logic;
    conta_idoso, direcao_idoso: in std_logic;
    contagem_vagas, contagem_idoso: out std_logic_vector(3 downto 0);
    cheio: out std_logic
  );
end fluxo_dados;

architecture fluxo_dados_arch of fluxo_dados is
  component contador is
    port(
      clock, zera, conta, direcao: in std_logic;
      contagem: out std_logic_vector(3 downto 0)
    );
  end component;

  component sinalizador is
    port(
      vagas, contagem: in std_logic_vector(3 downto 0);
      fim: out std_logic
    );
  end component;

  signal qtd_vagas, qtd_idoso: std_logic_vector(3 downto 0);
begin
  -- conta_total <= '1' when conta_vagas='1' or conta_idoso='1' else '0';
  -- direcao_total <= 
  --   direcao_vagas when conta_vagas='1' else
  --   direcao_idoso when conta_idoso='1' else
  --   '0';
  contagem_vagas <= qtd_vagas;
  contagem_idoso <= qtd_idoso;
  
  contador_vagas: contador port map(
    clock => clock, 
    zera => zera, 
    conta => conta_vagas, 
    direcao => direcao_vagas, 
    contagem => qtd_vagas
  );

  contador_idosos: contador port map(
    clock => clock, 
    zera => zera, 
    conta => conta_idoso,
    direcao => direcao_idoso, 
    contagem => qtd_idoso
  );

  sinalizador_vagas: sinalizador port map(
    vagas => vagas,
    contagem => qtd_vagas,
    fim => cheio
  );
end fluxo_dados_arch;
