library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity completo is
  port(
    clock, zera: in std_logic;
    conta, dir, conta_idoso, dir_idoso: in std_logic;
    vagas: in std_logic_vector(3 downto 0);
    contagem, contagem_idoso: out std_logic_vector(3 downto 0);
    cheio: out std_logic;
    uc_conta, uc_dir, uc_conta_idoso, uc_dir_idoso: out std_logic
  );
end completo;


architecture completo_arch of completo is
  component fluxo_dados is
    port (
      clock, zera: in std_logic;
      vagas: in std_logic_vector(3 downto 0);
      conta_vagas, direcao_vagas: in std_logic;
      conta_idoso, direcao_idoso: in std_logic;
      contagem_vagas, contagem_idoso: out std_logic_vector(3 downto 0);
      cheio: out std_logic
    );
  end component;
  
  component unidade_controle is
    port (
      clock, zera, is_cheio: in std_logic;
      conta, dir, conta_idoso, dir_idoso: in std_logic;
      c_conta, c_dir, c_conta_idoso, c_dir_idoso: out std_logic
    );
  end component;

  signal c_conta, c_dir, c_conta_idoso, c_dir_idoso: std_logic;
  signal fd_cheio: std_logic;
  signal qtd: std_logic_vector(3 downto 0);
begin
  contagem <= qtd;
  cheio <= fd_cheio;
  uc_conta <= c_conta;
  uc_dir <= c_dir;
  uc_conta_idoso <= c_conta_idoso;
  uc_dir_idoso <= c_dir_idoso;

  fd: fluxo_dados port map (
    clock=>clock,
    zera=>zera,
    vagas=>vagas,
    conta_vagas=>c_conta,
    direcao_vagas=>c_dir,
    conta_idoso=>c_conta_idoso,
    direcao_idoso=>c_dir_idoso,
    contagem_vagas=>qtd,
    contagem_idoso=>contagem_idoso,
    cheio=>fd_cheio
  );

  uc: unidade_controle port map (
    clock=>clock,
    zera=>zera,
    is_cheio=>fd_cheio,
    conta=>conta,
    dir=>dir,
    conta_idoso=>conta_idoso,
    dir_idoso=>dir_idoso,
    c_conta=>c_conta,
    c_dir=>c_dir,
    c_conta_idoso=>c_conta_idoso,
    c_dir_idoso=>c_dir_idoso
  );
end completo_arch;
