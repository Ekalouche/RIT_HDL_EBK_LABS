
-------------------------------------------------------------------------------
-- Elie Kalouche
-- Add/Sub 3-Bit Testbench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Add_Sub_3Bit_tb is
end Add_Sub_3Bit_tb;

architecture arch of Add_Sub_3Bit_tb is

    component Add_Sub_3Bit is
        port (
            a          : in std_logic_vector(2 downto 0);
            b          : in std_logic_vector(2 downto 0);
            reset      : in std_logic;
            clk        : in std_logic;
            add_btn    : in std_logic;
            sub_btn    : in std_logic;
            a_bcd      : out std_logic_vector(6 downto 0);
            b_bcd      : out std_logic_vector(6 downto 0);
            result_bcd : out std_logic_vector(6 downto 0)
        );
    end component;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal a          : std_logic_vector(2 downto 0) := "000";
    signal b          : std_logic_vector(2 downto 0) := "000";
    signal add_btn    : std_logic := '1';
    signal sub_btn    : std_logic := '1';
    signal a_bcd      : std_logic_vector(6 downto 0);
    signal b_bcd      : std_logic_vector(6 downto 0);
    signal result_bcd : std_logic_vector(6 downto 0);

begin

    DUT : Add_Sub_3Bit
        port map (
            a          => a,
            b          => b,
            reset      => reset,
            clk        => clk,
            add_btn    => add_btn,
            sub_btn    => sub_btn,
            a_bcd      => a_bcd,
            b_bcd      => b_bcd,
            result_bcd => result_bcd
        );

    -- 50 MHz clock
    clock_process : process
    begin
        clk <= '0';
        wait for 10 ns;

        clk <= '1';
        wait for 10 ns;
    end process;

    stimulus_process : process
    begin
        -- Reset
        reset <= '1';
        wait for 40 ns;

        reset <= '0';
        wait for 40 ns;

        -- Test 1: 3 + 2 = 5
        a <= "011";
        b <= "010";
        wait for 100 ns;

        add_btn <= '0';
        wait for 100 ns;
        add_btn <= '1';
        wait for 100 ns;

        -- Test 2: 3 - 2 = 1
        sub_btn <= '0';
        wait for 100 ns;
        sub_btn <= '1';
        wait for 100 ns;

        -- Test 3: 1 - 2 = 15
        a <= "001";
        b <= "010";
        wait for 100 ns;

        sub_btn <= '0';
        wait for 100 ns;
        sub_btn <= '1';
        wait for 100 ns;

        -- Test 4: 0 - 7 = 9
        a <= "000";
        b <= "111";
        wait for 100 ns;

        sub_btn <= '0';
        wait for 100 ns;
        sub_btn <= '1';
        wait for 100 ns;

        -- Test 5: 7 + 7 = 14
        a <= "111";
        b <= "111";
        wait for 100 ns;

        add_btn <= '0';
        wait for 100 ns;
        add_btn <= '1';
        wait for 100 ns;

        wait;
    end process;

end arch;
