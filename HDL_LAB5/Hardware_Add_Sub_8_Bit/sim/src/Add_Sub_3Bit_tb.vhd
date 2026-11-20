-------------------------------------------------------------------------------
-- Elie Kalouche
-- Lab 5 testbench (original filename retained)
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Add_Sub_3Bit_tb is
end Add_Sub_3Bit_tb;

architecture arch of Add_Sub_3Bit_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal btn : std_logic := '1';
    signal switch : std_logic_vector(7 downto 0) := (others => '0');
    signal led : std_logic_vector(3 downto 0);
    signal bcd_0, bcd_1, bcd_2 : std_logic_vector(6 downto 0);
    signal done : boolean := false;

    -- Expected active-low seven-segment patterns.
    function digit(n : natural) return std_logic_vector is
    begin
        case n is
            when 0 => return "1000000";
            when 1 => return "1111001";
            when 2 => return "0100100";
            when 3 => return "0110000";
            when 4 => return "0011001";
            when 5 => return "0010010";
            when 6 => return "0000010";
            when 7 => return "1111000";
            when 8 => return "0000000";
            when 9 => return "0010000";
            when others => return "1111111";
        end case;
    end function;
begin
    DUT : entity work.Add_Sub_3Bit
        port map (switch => switch, reset => reset, clk => clk, btn => btn,
                  led => led, bcd_0 => bcd_0, bcd_1 => bcd_1, bcd_2 => bcd_2);

    clock_process : process
    begin
        while not done loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    stimulus_process : process
        procedure check(value : natural; state_led : std_logic_vector) is
        begin
            assert led = state_led report "Wrong state LED" severity failure;
            assert bcd_0 = digit(value mod 10)
               and bcd_1 = digit((value / 10) mod 10)
               and bcd_2 = digit((value / 100) mod 10)
                report "Wrong decimal display: expected " & integer'image(value)
                severity failure;
        end procedure;
    begin
        wait for 100 ns;
        reset <= '0';
        wait for 200 ns;
        check(0, "0001");

        -- A=5, B=2, SUM=7, DIFF=3
        switch <= std_logic_vector(to_unsigned(5, 8));
        wait for 200 ns;
        check(5, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(2, 8));
        wait for 200 ns;
        check(2, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(7, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(7, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(3, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;

        -- A=2, B=5, SUM=7, DIFF=509
        switch <= std_logic_vector(to_unsigned(2, 8));
        wait for 200 ns;
        check(2, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(5, 8));
        wait for 200 ns;
        check(5, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(7, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(7, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(509, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;

        -- A=200, B=100, SUM=300, DIFF=100
        switch <= std_logic_vector(to_unsigned(200, 8));
        wait for 200 ns;
        check(200, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(100, 8));
        wait for 200 ns;
        check(100, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(300, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(300, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(100, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;

        -- A=100, B=200, SUM=300, DIFF=412
        switch <= std_logic_vector(to_unsigned(100, 8));
        wait for 200 ns;
        check(100, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(200, 8));
        wait for 200 ns;
        check(200, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(300, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(300, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(412, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;

        -- A=0, B=1, SUM=1, DIFF=511
        switch <= std_logic_vector(to_unsigned(0, 8));
        wait for 200 ns;
        check(0, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(1, 8));
        wait for 200 ns;
        check(1, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(1, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(1, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(511, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;

        -- A=255, B=255, SUM=510, DIFF=0
        switch <= std_logic_vector(to_unsigned(255, 8));
        wait for 200 ns;
        check(255, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        switch <= std_logic_vector(to_unsigned(255, 8));
        wait for 200 ns;
        check(255, "0010");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(510, "0100");
        -- Moving switches in a result state must not change stored A/B.
        switch <= (others => '0');
        wait for 100 ns;
        check(510, "0100");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        check(0, "1000");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        -- Hold a button down: only one transition.
        btn <= '0';
        wait for 1000 ns;
        check(0, "0010");
        btn <= '1';
        wait for 200 ns;
        check(0, "0010");
        -- Reset from input_b.
        reset <= '1';
        wait for 100 ns;
        assert led = "0001" report "Reset state failed" severity failure;
        assert bcd_0 = "1111111" and bcd_1 = "1111111"
           and bcd_2 = "1111111" report "Reset blanking failed" severity failure;
        reset <= '0';
        wait for 200 ns;
        check(0, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        -- Reset from disp_sum.
        reset <= '1';
        wait for 100 ns;
        assert led = "0001" report "Reset state failed" severity failure;
        assert bcd_0 = "1111111" and bcd_1 = "1111111"
           and bcd_2 = "1111111" report "Reset blanking failed" severity failure;
        reset <= '0';
        wait for 200 ns;
        check(0, "0001");
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        btn <= '0';
        wait for 200 ns;
        btn <= '1';
        wait for 200 ns;
        -- Reset from disp_diff.
        reset <= '1';
        wait for 100 ns;
        assert led = "0001" report "Reset state failed" severity failure;
        assert bcd_0 = "1111111" and bcd_1 = "1111111"
           and bcd_2 = "1111111" report "Reset blanking failed" severity failure;
        reset <= '0';
        wait for 200 ns;
        check(0, "0001");
        report "PASS: required cases, boundaries, button hold, operand hold and reset" severity note;
        done <= true;
        wait;
    end process;
end arch;
