
-------------------------------------------------------------------------------
-- Elie Kalouche
-- Add/Sub 3-Bit Top-Level Design
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Add_Sub_3Bit is
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
end Add_Sub_3Bit;

architecture behavior of Add_Sub_3Bit is

    component synchronizer_3bit is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            async_in : in std_logic_vector(2 downto 0);
            sync_out : out std_logic_vector(2 downto 0)
        );
    end component;

    component rising_edge_synchronizer is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            input : in std_logic;
            edge  : out std_logic
        );
    end component;

    component BCD is
        port (
            clk           : in std_logic;
            reset         : in std_logic;
            bcd           : in std_logic_vector(3 downto 0);
            seven_seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    component Pader is
        port (
            A     : in std_logic_vector(2 downto 0);
            A_Pad : out std_logic_vector(3 downto 0)
        );
    end component;

    component Operator is
        port (
		    clk, reset : in std_logic;
            A, B : in std_logic;
            flag : out std_logic_vector(1 downto 0)
        );
    end component;

    component add_sub is
        port (
            A, B   : in std_logic_vector(3 downto 0);
            op     : in std_logic_vector(1 downto 0);
            Result : out std_logic_vector(3 downto 0)
        );
    end component;

    signal A_sync : std_logic_vector(2 downto 0);
    signal B_sync : std_logic_vector(2 downto 0);
    signal A_Pad  : std_logic_vector(3 downto 0);
    signal B_Pad  : std_logic_vector(3 downto 0);
    signal Result : std_logic_vector(3 downto 0);
    signal Add_op : std_logic;
    signal Sub_op : std_logic;
    signal Flag   : std_logic_vector(1 downto 0);

begin

    U1 : synchronizer_3bit
        port map (
            clk      => clk,
            reset    => reset,
            async_in => a,
            sync_out => A_sync
        );

    U2 : synchronizer_3bit
        port map (
            clk      => clk,
            reset    => reset,
            async_in => b,
            sync_out => B_sync
        );

    U3 : rising_edge_synchronizer
        port map (
            clk   => clk,
            reset => reset,
            input => add_btn,
            edge  => Add_op
        );

    U4 : rising_edge_synchronizer
        port map (
            clk   => clk,
            reset => reset,
            input => sub_btn,
            edge  => Sub_op
        );

    U5 : Pader
        port map (
            A     => A_sync,
            A_Pad => A_Pad
        );

    U6 : Pader
        port map (
            A     => B_sync,
            A_Pad => B_Pad
        );

    U7 : Operator
        port map (
            clk           => clk,
            reset         => reset,		
            A    => Add_op,
            B    => Sub_op,
            flag => Flag
        );

    U8 : add_sub
        port map (
            A      => A_Pad,
            B      => B_Pad,
            op     => Flag,
            Result => Result
        );

    U9 : BCD
        port map (
            clk           => clk,
            reset         => reset,
            bcd           => A_Pad,
            seven_seg_out => a_bcd
        );

    U10 : BCD
        port map (
            clk           => clk,
            reset         => reset,
            bcd           => B_Pad,
            seven_seg_out => b_bcd
        );

    U11 : BCD
        port map (
            clk           => clk,
            reset         => reset,
            bcd           => Result,
            seven_seg_out => result_bcd
        );

end behavior;
