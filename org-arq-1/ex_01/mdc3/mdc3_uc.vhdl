library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdc3_uc is 
    --type state_type is(idle,swap,sub);
    port(
        --state_reg: out state_type;
        --state_next: out state_type;
        Reset: in std_logic;
        Clock: in std_logic;
        Start: in std_logic;
        Igual: in std_logic;
        Menor: in std_logic;
        Ready: out std_logic;
        Sela: out std_logic_vector(1 downto 0);
        Selb: out std_logic;
        CEar: out std_logic;
        CEbr: out std_logic;
        compara: out std_logic
    );
end entity;

architecture mdc3_ucArch of mdc3_uc is
    type state_type is(idle,swap,sub);
    signal state_reg,state_next: state_type:=idle;
    begin
    
    Timing : process (Reset, Clock)
    begin
        if Reset = '1' then
            state_reg <= idle;
        elsif (clock'event and clock = '0') then
            state_reg <= state_next;
        end if;
    end process Timing;
        
    Proximo_estado_saida : process (Start, State_reg)
    begin
        -- Posiciona todos os sinais de controle em Zero
        Sela <= "00"; Selb <= '0'; CEar <= '0'; CEbr <= '0'; Ready <= '0'; compara <= '0';
        -- Analisa a máquina de estado e posiciona os sinais de controle que devem ser acionados
        case state_reg is

            when idle => -- Estado Idle
                if start = '1' then
                    -- ar <= A;
                    Sela <= "01"; CEar <= '1';
                    -- br <= B;
                    CEbr <= '1';
                    state_next <= swap;
                else
                    state_next <= idle;
                end if;

            when swap => -- Estado Swap
                compara <= '1';
                if (igual = '1') then
                    Ready <= '1';
                    -- MDC <= ar;
                    state_next <= idle;
                else
                    if (Menor = '1') then
                        -- ar <= br;
                        Sela <= "10"; CEar <= '1';
                        -- br <= ar;
                        Selb <= '1'; CEbr <= '1';
                    end if;
                    state_next <= sub;
                end if;

            when sub => -- Estado Sub
                -- ar <= ar - br;
                CEar <= '1';
                state_next <= swap;

        end case;
    end process Proximo_estado_saida;

end mdc3_ucArch;