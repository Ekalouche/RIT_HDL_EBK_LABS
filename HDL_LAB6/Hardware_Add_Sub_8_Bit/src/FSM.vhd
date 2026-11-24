-------------------------------------------------------------------------------
-- Elie Kalouche
-- 8-Bit Calculator State Machine
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    execute        : in  std_logic;
    op_select      : in  std_logic_vector(1 downto 0);
    memory_data    : in  std_logic_vector(7 downto 0);
    switch_data    : in  std_logic_vector(7 downto 0);
    op             : out std_logic_vector(1 downto 0);
    a              : out std_logic_vector(7 downto 0);
    write_enable   : out std_logic;
    addr           : out std_logic_vector(1 downto 0);
    state_led      : out std_logic_vector(4 downto 0);
    display_select : out std_logic
  );
end state_machine;

architecture beh of state_machine is

-- State declarations using one-hot encoding
constant sWait   : std_logic_vector(2 downto 0) := "001";
constant sSelect : std_logic_vector(2 downto 0) := "010";
constant sResult : std_logic_vector(2 downto 0) := "100";

-- Present and next state signals
signal state_reg  : std_logic_vector(2 downto 0);
signal state_next : std_logic_vector(2 downto 0);

-- Stores the current memory address
signal addr_reg : unsigned(1 downto 0);

-- Stores the selected operation
signal op_reg : std_logic_vector(1 downto 0);

-- Stores the previous calculator result
signal a_reg : std_logic_vector(7 downto 0);

-- Controls the memory write operation
signal write_reg : std_logic;

-- Indicates that the newly stored result is ready to be read
signal read_pending : std_logic;

begin

-- State register
process(clk, reset)
begin

  -- Return to the wait state after reset
  if (reset = '1') then
    state_reg <= sWait;

  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;

end process;

-- Next state logic
process(state_reg, execute, write_reg, read_pending)
begin

  -- Remain in the current state by default
  state_next <= state_reg;

  case state_reg is

    -- Enter the first number
    when sWait =>
      if (execute = '1') then
        state_next <= sSelect;
      end if;

    -- Enter the second number and select the operation
    when sSelect =>
      if (execute = '1' and write_reg = '0'
                        and read_pending = '0') then
        state_next <= sResult;
      end if;

    -- Display the calculated result
    when sResult =>
      if (execute = '1' and write_reg = '0'
                        and read_pending = '0') then
        state_next <= sSelect;
      end if;

    -- Return to wait if the state is invalid
    when others =>
      state_next <= sWait;

  end case;

end process;

-- Memory, operand, and operation registers
process(clk, reset)
begin

  -- Reset all registers to zero
  if (reset = '1') then

    addr_reg     <= "00";
    op_reg       <= "00";
    a_reg        <= "00000000";
    write_reg    <= '0';
    read_pending <= '0';

  elsif (clk'event and clk = '1') then

    -- Disable memory writing by default
    write_reg <= '0';

    -- Memory output becomes valid after the read clock edge
    read_pending <= write_reg;

    -- Save the first number using 0 + switch input
    if (state_reg = sWait and execute = '1') then

      a_reg     <= "00000000";
      op_reg    <= "00";
      addr_reg  <= "01";
      write_reg <= '1';

    -- Calculate using the previous result and second number
    elsif (state_reg = sSelect and execute = '1'
                               and write_reg = '0'
                               and read_pending = '0') then

      -- Capture the previous result from memory
      a_reg <= memory_data;

      -- Capture the selected operation
      -- 00 = Addition
      -- 01 = Subtraction
      -- 10 = Multiplication
      -- 11 = Division
      op_reg <= op_select;

      -- Move to the next memory address
      -- Address 00 is reserved for reset
      if (addr_reg = "11") then
        addr_reg <= "01";
      else
        addr_reg <= addr_reg + 1;
      end if;

      -- Enable memory writing for one clock cycle
      write_reg <= '1';

    end if;

  end if;

end process;

-- Display output logic
process(state_reg)
begin

  case state_reg is

    -- Display the first number being entered
    when sWait =>
      display_select <= '0';

    -- Display the second number being entered
    when sSelect =>
      display_select <= '0';

    -- Display the calculated result from memory
    when sResult =>
      display_select <= '1';

    when others =>
      display_select <= '0';

  end case;

end process;

-- Send the selected operation to the ALU
op <= op_reg;

-- Send the previous calculator result to the ALU
a <= a_reg;

-- Send the current memory address to memory
addr <= std_logic_vector(addr_reg);

-- Enable memory writing
write_enable <= write_reg;

-- Display the current state using the first three LEDs
-- LED3 and LED4 remain off
state_led <= "00" & state_reg;

end beh;