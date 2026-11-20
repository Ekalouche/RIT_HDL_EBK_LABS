-------------------------------------------------------------------------------
-- Elie Kalouche
-- Sum register testbench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Sum_register_tb is
end Sum_register_tb;

architecture arch of Sum_register_tb is

    component sum_register is
        port (
            clk_50_mhz    : in  std_logic;
            reset         : in  std_logic;
            seven_seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '1';
    signal seven_seg_out : std_logic_vector(6 downto 0);

begin

    DUT : sum_register
        port map (
            clk_50_mhz    => clk,
            reset         => reset,
            seven_seg_out => seven_seg_out
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
        reset <= '1';
        wait for 40 ns;

        reset <= '0';
        wait;
    end process;

end arch;