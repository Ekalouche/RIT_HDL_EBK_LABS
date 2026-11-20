-------------------------------------------------------------------------------
-- Elie Kalouche
-- Lab 5: 8-bit Add/Sub with State Machine
-- Original filename and entity name retained from the working lab.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Add_Sub_3Bit is
    port (
        switch : in std_logic_vector(7 downto 0);
        reset, clk, btn : in std_logic;
        led : out std_logic_vector(3 downto 0);
        bcd_0, bcd_1, bcd_2 : out std_logic_vector(6 downto 0)
    );
end Add_Sub_3Bit;

architecture behavior of Add_Sub_3Bit is
    component synchronizer_3bit is
        port (
            clk, reset : in std_logic;
            async_in : in std_logic_vector(7 downto 0);
            sync_out : out std_logic_vector(7 downto 0)
        );
    end component;
    component rising_edge_synchronizer is
        port (
            clk, reset, input : in std_logic;
            edge : out std_logic
        );
    end component;
    component Operator is
        port (
            clk, reset, btn_edge : in std_logic;
            load_a, load_b : out std_logic;
            flag : out std_logic_vector(1 downto 0);
            led : out std_logic_vector(3 downto 0)
        );
    end component;
    component Pader is
        port (
            A : in std_logic_vector(7 downto 0);
            A_Pad : out std_logic_vector(8 downto 0)
        );
    end component;
    component add_sub is
        port (
            A, B : in std_logic_vector(8 downto 0);
            op : in std_logic_vector(1 downto 0);
            Result : out std_logic_vector(8 downto 0)
        );
    end component;
    component double_dabble is
        port (
            result_padded : in std_logic_vector(11 downto 0);
            ones, tens, hundreds : out std_logic_vector(3 downto 0)
        );
    end component;
    component BCD is
        port (
            clk, reset : in std_logic;
            bcd : in std_logic_vector(3 downto 0);
            seven_seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    signal reset_z, reset_sync : std_logic := '0';
    signal switch_sync : std_logic_vector(7 downto 0);
    signal A_reg, B_reg : std_logic_vector(7 downto 0);
    signal A_Pad, B_Pad, Result : std_logic_vector(8 downto 0);
    signal display_value : std_logic_vector(8 downto 0);
    signal result_padded : std_logic_vector(11 downto 0);
    signal ones, tens, hundreds : std_logic_vector(3 downto 0);
    signal btn_pressed, btn_edge, load_a, load_b : std_logic;
    signal Flag : std_logic_vector(1 downto 0);
begin
    -- Synchronize the active-high reset switch to the 50 MHz clock.
    process(clk)
    begin
        if rising_edge(clk) then
            reset_z <= reset;
            reset_sync <= reset_z;
        end if;
    end process;

    -- DE1-SoC KEY0 is low when pressed.
    btn_pressed <= not btn;

    U1 : synchronizer_3bit
        port map (clk => clk, 
		          reset => reset_sync,
                  async_in => switch, 
				  sync_out => switch_sync
				 );
				 
    U2 : rising_edge_synchronizer
        port map (clk => clk, 
		reset => reset_sync,
                  input => btn_pressed, 
				  edge => btn_edge
				  );
				  
    U3 : Operator
        port map (clk => clk, 
		reset => reset_sync, 
		btn_edge => btn_edge,
                  load_a => load_a, 
				  load_b => load_b, 
				  flag => Flag, 
				  led => led
				 );

    -- Track switches only in the matching input state; otherwise hold.
    process(clk, reset_sync)
    begin
        if reset_sync = '1' then
            A_reg <= (others => '0');
            B_reg <= (others => '0');
        elsif rising_edge(clk) then
            if load_a = '1' then
                A_reg <= switch_sync;
            end if;
            if load_b = '1' then
                B_reg <= switch_sync;
            end if;
        end if;
    end process;

    U4 : Pader port map (A => A_reg, 
	                     A_Pad => A_Pad
						 );
						 
    U5 : Pader port map (A => B_reg, 
	                     A_Pad => B_Pad
	                     );
						 
    U6 : add_sub
        port map (A => A_Pad, 
		          B => B_Pad, 
			      op => Flag, 
		          Result => Result
		          );

    process(load_a, load_b, switch_sync, Result)
    begin
        if load_a = '1' or load_b = '1' then
            display_value <= '0' & switch_sync;
        else
            display_value <= Result;
        end if;
    end process;

    result_padded <= "000" & display_value;
    U7 : double_dabble
        port map (result_padded => result_padded, 
		          ones => ones,
                  tens => tens, 
				  hundreds => hundreds
				  );
    U8 : BCD
        port map (clk => clk,
            	  reset => reset_sync,
                  bcd => ones, 
				  seven_seg_out => bcd_0
				  );
				  
    U9 : BCD
        port map (clk => clk, 
		          reset => reset_sync,
                  bcd => tens, 
				  seven_seg_out => bcd_1
				  );
				  
    U10 : BCD
        port map (clk => clk, 
		          reset => reset_sync,
                  bcd => hundreds, 
				  seven_seg_out => bcd_2
				  );
end behavior;
