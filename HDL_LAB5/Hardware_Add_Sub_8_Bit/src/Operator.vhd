-------------------------------------------------------------------------------
-- Elie Kalouche
-- Lab 5 state machine
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Operator is
    port (
        clk, reset : in std_logic;
        btn_edge   : in std_logic;
        load_a, load_b : out std_logic;
        flag       : out std_logic_vector(1 downto 0);
        led        : out std_logic_vector(3 downto 0)
    );
end Operator;

architecture behavior of Operator is
    type state_type is (input_a, input_b, disp_sum, disp_diff);
    signal current_state, next_state : state_type;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= input_a;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, btn_edge)
    begin
        next_state <= current_state;
        if btn_edge = '1' then
            case current_state is
                when input_a   => next_state <= input_b;
                when input_b   => next_state <= disp_sum;
                when disp_sum  => next_state <= disp_diff;
                when disp_diff => next_state <= input_a;
            end case;
        end if;
    end process;

    process(current_state)
    begin
        load_a <= '0';
        load_b <= '0';
        flag <= "00";
        led <= "0000";
        case current_state is
            when input_a =>
                load_a <= '1';
                led <= "0001";
            when input_b =>
                load_b <= '1';
                led <= "0010";
            when disp_sum =>
                flag <= "10";
                led <= "0100";
            when disp_diff =>
                flag <= "01";
                led <= "1000";
        end case;
    end process;
end behavior;
