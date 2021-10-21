--------------------------------------------------------------------------------
-- Tentativas:
-- 01: #21825 (10)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- COMPONENTE: FULL ADDER 1 BIT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.numeric_bit.all;

entity fa1bit is
  port(
    a, b, cin: in bit;
    s, cout: out bit
  );
 end entity;

architecture fa1bit_arch of fa1bit is
  signal axorb: bit;
begin
  axorb <= a xor b;
  s <= axorb xor cin;
  cout <= (axorb and cin) or (a and b);
end architecture;



--------------------------------------------------------------------------------
-- COMPONENTE: ULA 1 BIT
--------------------------------------------------------------------------------

-- DESCRIÇÃO DE ALGUNS SINAIS
-- OPERATION: AND: 00; OR: 01; Soma: 10; SLT: 11.
-- SET: retorna a saída do somador idependentemente da seleção do multiplexador 
-- de saída.
-- OVERFLOW: alta se houver overflow no somador, idependentemente da seleção do 
-- multiplexador de saída.
-- LESS: copiada diretamente para RESULT se OPERATION = 11.
-- COUT: sinal carry-out do full adder.

library IEEE;
use IEEE.numeric_bit.all;

entity alu1bit is
  port(
    a, b, less, cin: in bit;
    result, cout, set, overflow: out bit;
    ainvert, binvert: in bit;
    operation: in bit_vector(1 downto 0)
  );
end entity;

architecture alu1bit_arch of alu1bit is
  component fa1bit is
    port(
      a, b, cin: in bit;
      s, cout: out bit
    );
   end component;
  signal a_in, b_in, fa_sum, fa_cout: bit;
begin
  adder: fa1bit port map(
    a => a_in,
    b => b_in,
    cin => cin,
    s => fa_sum,
    cout => fa_cout
  );

  -- ainvert multiplex
  with ainvert select
    a_in <= 
      not(a) when '1',
      a when others;
  
  -- binvert multiplex
  with binvert select
    b_in <=
      not(b) when '1',
      b when others;

  -- operation multiplex
  with operation select
    result <=
      a_in and b_in when "00",
      a_in or b_in when "01",
      fa_sum when "10",
      less when "11";

  cout <= fa_cout;
  set <= fa_sum;
  overflow <= cin xor fa_cout;
end architecture;

