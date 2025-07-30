library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDC2 is
    port(
        A:in STD_LOGIC_VECTOR(7 downto 0);
        B:in STD_LOGIC_VECTOR(7 downto 0);
        MDC:out STD_LOGIC_VECTOR(7 downto 0);
        Start: in std_logic;
        Reset: in std_logic;
        Clock: in std_logic;
        Ready: out std_logic
    );
end entity;

architecture mdc2Comp of MDC2 is
    signal a_next,b_next: std_logic_vector(7 downto 0);
    type state is (idle,swap,sub);
    signal state_reg: state := idle;
    signal state_next: state := idle;
    Begin
    
    Timing : process (Reset, Clock)
    begin
        if Reset = '1' then
            state_reg <= idle;
        elsif (clock'event and clock = '1') then
            state_reg <= state_next;
        end if;
    end process Timing;
    
    Proximo_estado_saida : process (A, B, Start, State_reg)
    begin
        case state_reg is
            when idle => -- Estado IDLE
                if start = '1' then
                    a_next <= A;
                    b_next <= B;
                    state_next <= swap;
                else
                    Ready <= '0';
                    state_next <= idle;
                end if;
            when swap => -- Estado SWAP
                if (a_next = b_next) then
                    Ready <= '1';
                    MDC <= a_next;
                    state_next <= idle;
                else
                    if (a_next < b_next) then
                        a_next <= b_next;
                        b_next <= a_next;
                    end if;
                        state_next <= sub;
                end if;
            when sub => -- ESTADO SUB
                a_next <= std_logic_vector(unsigned(a_next) - unsigned(b_next));
                state_next <= swap;
        end case;
    end process Proximo_estado_saida;
end mdc2Comp;