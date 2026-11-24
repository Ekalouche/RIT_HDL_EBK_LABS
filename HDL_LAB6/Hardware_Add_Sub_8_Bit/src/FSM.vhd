library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    execute       : in  std_logic;
    op_select     : in  std_logic_vector(1 downto 0);
    memory_data   : in  std_logic_vector(7 downto 0);
    op            : out std_logic_vector(1 downto 0);
    a             : out std_logic_vector(7 downto 0);
    write_enable  : out std_logic;
    addr          : out std_logic_vector(1 downto 0);
    state_led     : out std_logic_vector(4 downto 0)
  );
end state_machine;

architecture beh of state_machine is

-- State declarations using one-hot encoding
constant sWait   : std_logic_vector(4 downto 0) := "00001";
constant sSelect : std_logic_vector(4 downto 0) := "00010";
constant sWrite  : std_logic_vector(4 downto 0) := "00100";
constant sRead   : std_logic_vector(4 downto 0) := "01000";
constant sDone   : std_logic_vector(4 downto 0) := "10000";

-- Present and next state signals
signal state_reg  : std_logic_vector(4 downto 0);
signal state_next : std_logic_vector(4 downto 0);

-- Stores the current memory address
signal addr_reg   : unsigned(1 downto 0);

-- Stores the selected ALU operation
signal op_reg     : std_logic_vector(1 downto 0);

-- Stores the previous calculator result
signal a_reg      : std_logic_vector(7 downto 0);

begin

-- State register
process(clk, reset)
begin

  -- Reset to the wait state
  if (reset = '1') then
    state_reg <= sWait;

  -- Update the present state on the rising edge
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;
  end if;

end process;

-- Next state logic
process(state_reg, execute)
begin

  -- Default value prevents a latch
  state_next <= state_reg;

  case state_reg is

    -- Wait for the execute button to be pressed
    when sWait =>
      if (execute = '1') then
        state_next <= sSelect;
      end if;

    -- Select the operation and capture the previous result
    when sSelect =>
      state_next <= sWrite;

    -- Write the ALU result into memory
    when sWrite =>
      state_next <= sRead;

    -- Read the newly stored result from memory
    when sRead =>
      state_next <= sDone;

    -- Return to the wait state
    when sDone =>
      state_next <= sWait;

    -- Return to the wait state if the state is invalid
    when others =>
      state_next <= sWait;

  end case;

end process;

-- Operation, operand, and memory address registers
process(clk, reset)
begin

  -- Reset all registers to zero
  if (reset = '1') then
    addr_reg <= "00";
    op_reg   <= "00";
    a_reg    <= "00000000";

  elsif (clk'event and clk = '1') then

    -- Update the registers during the select state
    if (state_reg = sSelect) then

      -- Store the operation selected by the switches
      -- 00 = Addition
      -- 01 = Subtraction
      -- 10 = Multiplication
      -- 11 = Division
      op_reg <= op_select;

      -- Store the previous memory result as ALU input A
      -- Prevents A from changing when the address changes
      a_reg <= memory_data;

      -- Increment the memory address for the next result
      -- Address 00 is reserved for the reset value
      if (addr_reg = "11") then
        addr_reg <= "01";
      else
        addr_reg <= addr_reg + 1;
      end if;

    end if;

  end if;

end process;

-- Output logic
process(state_reg)
begin

  case state_reg is

    -- Disable memory writing while waiting
    when sWait =>
      write_enable <= '0';

    -- Disable memory writing while selecting the operation
    when sSelect =>
      write_enable <= '0';

    -- Enable memory writing to store the ALU result
    when sWrite =>
      write_enable <= '1';

    -- Disable memory writing to read the stored result
    when sRead =>
      write_enable <= '0';

    -- Disable memory writing after the calculation
    when sDone =>
      write_enable <= '0';

    -- Disable memory writing during an invalid state
    when others =>
      write_enable <= '0';

  end case;

end process;

-- Send the selected operation to the ALU
op <= op_reg;

-- Send the previous calculator result to ALU input A
a <= a_reg;

-- Send the current memory address to memory
addr <= std_logic_vector(addr_reg);

-- Display the present state using the FPGA LEDs
state_led <= state_reg;

end beh;