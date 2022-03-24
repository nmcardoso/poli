library IEEE;
use IEEE.numeric_bit.all;

entity exp_tb is
end exp_tb;

architecture testbench of exp_tb is
  component exp is
    port(
      A: in bit;
      B: in bit;
      Y: out bit
    );
  end component;

  type bits_type is array(0 to 1) of bit;
  constant bits: bits_type := ('0', '1');
  signal A_sig, B_sig, Y_sig: bit;
begin
  DUT: exp port map(A_sig, B_sig, Y_sig);

  stim: process is
  begin
    for A_i in bits'range loop
      for B_i in bits'range loop
        A_sig <= bits(A_i);
        B_sig <= bits(B_i);

        wait for 10 ns;

        report "A_sig=" & bit'image(bits(A_i)) 
          & "; B_sig=" & bit'image(bits(B_i)) 
          & "; Y_sig=" & bit'image(Y_sig);
      end loop;
    end loop;
    wait;
  end process;

end architecture;
