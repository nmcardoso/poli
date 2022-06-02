library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unidade_controle is
  port(
    clock, zera, is_cheio: in std_logic;
    conta, dir, conta_idoso, dir_idoso: in std_logic;
    c_conta, c_dir, c_conta_idoso, c_dir_idoso: out std_logic
  );
end unidade_controle;


architecture unidade_controle_arch of unidade_controle is
  type estado_t is (COUNT, CHEIO, IDLE);
  signal estado_prox, estado_atual: estado_t;
  signal saida: std_logic_vector(3 downto 0);
begin
  sincrono: process(clock, zera, estado_prox)
  begin
    if zera='1' then
      estado_atual <= COUNT;
    elsif clock'event and clock='1' then
      estado_atual <= estado_prox;
    end if;
  end process;

  circ_prox_estado: process(estado_atual, conta, dir, conta_idoso, dir_idoso, is_cheio)
  begin
    case estado_atual is
      when CHEIO =>
        if conta_idoso='1' and dir_idoso='0' then
          estado_prox <= COUNT;
          saida <= "0010";
        elsif conta='1' and dir='0' then
          estado_prox <= COUNT;
          saida <= "1000";
        else
          estado_prox <= CHEIO;
          saida <= "0000";
        end if;
      when COUNT =>
        if is_cheio='1' then
          estado_prox <= CHEIO;
          saida <= "0000";
        elsif conta_idoso='1' and dir_idoso='1' then
          estado_prox <= COUNT;
          saida <= "0011";
        elsif conta_idoso='1' and dir_idoso='0' then
          estado_prox <= COUNT;
          saida <= "0010";
        elsif conta='1' and dir='1' then
          estado_prox <= COUNT;
          saida <= "1100";
        elsif conta='1' and dir='0' then
          estado_prox <= COUNT;
          saida <= "1000";
        else
          estado_prox <= COUNT;
          saida <= "0000";
        end if;
      when IDLE =>
        estado_prox <= IDLE;
        saida <= "0000";
      end case;
  end process;

  c_conta <= saida(3);
  c_dir <= saida(2);
  c_conta_idoso <= saida(1);
  c_dir_idoso <= saida(0);
end unidade_controle_arch;
