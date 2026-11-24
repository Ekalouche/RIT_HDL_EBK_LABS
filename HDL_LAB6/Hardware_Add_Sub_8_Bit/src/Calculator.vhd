-------------------------------------------------------------------------------
-- Elie Kalouche
-- 8-Bit Calculator Top-Level Design
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Calculator_8Bit is
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        execute_btn    : in  std_logic;
        b              : in  std_logic_vector(7 downto 0);
        op_select      : in  std_logic_vector(1 downto 0);
        ones_bcd       : out std_logic_vector(6 downto 0);
        tens_bcd       : out std_logic_vector(6 downto 0);
        hundreds_bcd   : out std_logic_vector(6 downto 0);
        state_led      : out std_logic_vector(4 downto 0)
    );
end Calculator_8Bit;

architecture behavior of Calculator_8Bit is

    -- 8-bit input synchronizer
    component synchronizer_8bit is
        port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            async_in : in  std_logic_vector(7 downto 0);
            sync_out : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Execute button rising edge synchronizer
    component rising_edge_synchronizer is
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            input : in  std_logic;
            edge  : out std_logic
        );
    end component;

    -- Calculator state machine
    component state_machine is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            execute      : in  std_logic;
            op_select    : in  std_logic_vector(1 downto 0);
            memory_data  : in  std_logic_vector(7 downto 0);
            op           : out std_logic_vector(1 downto 0);
            a            : out std_logic_vector(7 downto 0);
            write_enable : out std_logic;
            addr         : out std_logic_vector(1 downto 0);
            state_led    : out std_logic_vector(4 downto 0)
        );
    end component;

    -- Arithmetic logic unit
    component alu is
        port (
            reset  : in  std_logic;
            a      : in  std_logic_vector(7 downto 0);
            b      : in  std_logic_vector(7 downto 0);
            op     : in  std_logic_vector(1 downto 0);
            result : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Memory for storing calculator results
    component memory is
        generic (
            addr_width : integer := 2;
            data_width : integer := 4
        );
        port (
            clk  : in  std_logic;
            we   : in  std_logic;
            addr : in  std_logic_vector(addr_width - 1 downto 0);
            din  : in  std_logic_vector(data_width - 1 downto 0);
            dout : out std_logic_vector(data_width - 1 downto 0)
        );
    end component;

    -- Binary to decimal converter
    component double_dabble is
        port (
            result_padded : in  std_logic_vector(11 downto 0);
            ones          : out std_logic_vector(3 downto 0);
            tens          : out std_logic_vector(3 downto 0);
            hundreds      : out std_logic_vector(3 downto 0)
        );
    end component;

    -- BCD to seven-segment converter
    component BCD is
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            bcd           : in  std_logic_vector(3 downto 0);
            seven_seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Internal signals
    signal reset_sig        : std_logic;
    signal reset_meta       : std_logic;
    signal B_sync           : std_logic_vector(7 downto 0);
    signal Op_sync          : std_logic_vector(7 downto 0);
    signal Execute_sync     : std_logic;
    signal A                : std_logic_vector(7 downto 0);
    signal Operation        : std_logic_vector(1 downto 0);
    signal Write_enable_sig : std_logic;
    signal Memory_address   : std_logic_vector(1 downto 0);
    signal Memory_data      : std_logic_vector(7 downto 0);
    signal Result           : std_logic_vector(7 downto 0);
    signal Result_padded    : std_logic_vector(11 downto 0);
    signal Ones             : std_logic_vector(3 downto 0);
    signal Tens             : std_logic_vector(3 downto 0);
    signal Hundreds         : std_logic_vector(3 downto 0);

begin

    -- Synchronize the 8-bit calculator input
    U1 : synchronizer_8bit
        port map (
            clk      => clk,
            reset    => reset_sig,
            async_in => b,
            sync_out => B_sync
        );

    -- Synchronize the two operation selection switches
    -- Pad the remaining six bits with zeros
    U2 : synchronizer_8bit
        port map (
            clk      => clk,
            reset    => reset_sig,
            async_in => "000000" & op_select,
            sync_out => Op_sync
        );

    -- Detect when the execute pushbutton is pressed
    U3 : rising_edge_synchronizer
        port map (
            clk   => clk,
            reset => reset_sig,
            input => not execute_btn,
            edge  => Execute_sync
        );

    -- Control the ALU operation and memory
    U4 : state_machine
        port map (
            clk          => clk,
            reset        => reset_sig,
            execute      => Execute_sync,
            op_select    => Op_sync(1 downto 0),
            memory_data  => Memory_data,
            op           => Operation,
            a            => A,
            write_enable => Write_enable_sig,
            addr         => Memory_address,
            state_led    => state_led
        );

    -- Perform the selected arithmetic operation
    U5 : alu
        port map (
            reset  => reset_sig,
            a      => A,
            b      => B_sync,
            op     => Operation,
            result => Result
        );

    -- Store the calculator results in a 4 x 8-bit memory
    U6 : memory
        generic map (
            addr_width => 2,
            data_width => 8
        )
        port map (
            clk  => clk,
            we   => Write_enable_sig,
            addr => Memory_address,
            din  => Result,
            dout => Memory_data
        );

    -- Pad the stored 8-bit result to 12 bits
    Result_padded <= "0000" & Memory_data;

    -- Convert the stored result into three decimal digits
    U7 : double_dabble
        port map (
            result_padded => Result_padded,
            ones          => Ones,
            tens          => Tens,
            hundreds      => Hundreds
        );

    -- Display the ones digit
    U8 : BCD
        port map (
            clk           => clk,
            reset         => reset_sig,
            bcd           => Ones,
            seven_seg_out => ones_bcd
        );

    -- Display the tens digit
    U9 : BCD
        port map (
            clk           => clk,
            reset         => reset_sig,
            bcd           => Tens,
            seven_seg_out => tens_bcd
        );

    -- Display the hundreds digit
    U10 : BCD
        port map (
            clk           => clk,
            reset         => reset_sig,
            bcd           => Hundreds,
            seven_seg_out => hundreds_bcd
        );

end behavior;