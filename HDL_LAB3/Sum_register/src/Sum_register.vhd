-------------------------------------------------------------------------------
-- Elie Kalouche
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity sum_register is
    port (
        clk_50_mhz    : in  std_logic;
        reset         : in  std_logic;
        seven_seg_out : out std_logic_vector(6 downto 0)
    );
end sum_register;

architecture structural of sum_register is

    component generic_counter is
        generic (
            max_count : integer := 49999999
        );
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            output : out std_logic
        );
    end component;

    component generic_adder_beh is
        generic (
            bits : integer := 4
        );
        port (
            a    : in  std_logic_vector(bits-1 downto 0);
            b    : in  std_logic_vector(bits-1 downto 0);
            cin  : in  std_logic;
            sum  : out std_logic_vector(bits-1 downto 0);
            cout : out std_logic
        );
    end component;

    component seven_seg is
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            bcd           : in  std_logic_vector(3 downto 0);
            seven_seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal adder_sum : std_logic_vector(3 downto 0);
    signal sum_sig   : std_logic_vector(3 downto 0);
    signal enable    : std_logic;

begin

    U1 : generic_counter
        generic map (
            max_count => 49999999
        )
        port map (
            clk    => clk_50_mhz,
            reset  => reset,
            output => enable
        );

    U2 : generic_adder_beh
        generic map (
            bits => 4
        )
        port map (
            a    => sum_sig,
            b    => "0001",
            cin  => '0',
            sum  => adder_sum,
            cout => open
        );

    process (clk_50_mhz, reset)
    begin
        if reset = '1' then
            sum_sig <= (others => '0');
        elsif rising_edge(clk_50_mhz) then
            if enable = '1' then
                sum_sig <= adder_sum;
            end if;
        end if;
    end process;

    U3 : seven_seg
        port map (
            clk           => clk_50_mhz,
            reset         => reset,
            bcd           => sum_sig,
            seven_seg_out => seven_seg_out
        );

end structural;