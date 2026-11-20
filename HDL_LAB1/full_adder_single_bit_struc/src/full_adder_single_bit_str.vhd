-------------------------------------------------------------------------------
-- Elie Kalouche
-- single bit full adder [STRUCTURAL Top Level]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Structural full adder built from XOR, AND, and OR gate components
entity full_adder_single_bit_str is
  port (
    a    : in  std_logic;  -- input bit 1
    b    : in  std_logic;  -- input bit 2
    cin  : in  std_logic;  -- carry in
    sum  : out std_logic;  -- sum output
    cout : out std_logic   -- carry out
  );
end full_adder_single_bit_str;

architecture str of full_adder_single_bit_str is

  -- 2-input XOR gate component
  component xor_gate
    port (
      a : in  std_logic;
      b : in  std_logic;
      y : out std_logic
    );
  end component;

  -- 2-input AND gate component
  component and_gate
    port (
      a : in  std_logic;
      b : in  std_logic;
      y : out std_logic
    );
  end component;

  -- 3-input OR gate component
  component or_gate
    port (
      a   : in  std_logic;
      b   : in  std_logic;
      cin : in  std_logic;
      y   : out std_logic
    );
  end component;

  -- internal signals connecting the gates together
  signal a_and_b   : std_logic;  -- a AND b
  signal a_and_cin : std_logic;  -- a AND cin
  signal b_and_cin : std_logic;  -- b AND cin
  signal a_xor_b   : std_logic;  -- a XOR b (intermediate sum term)

begin

  -- compute pairwise ANDs, used to generate carry out
  U1 : and_gate port map (a => a, b => b,   y => a_and_b);
  U2 : and_gate port map (a => a, b => cin, y => a_and_cin);
  U3 : and_gate port map (a => b, b => cin, y => b_and_cin);

  -- compute sum: a XOR b, then XOR with carry in
  U4 : xor_gate port map (a => a,       b => b,   y => a_xor_b);
  U5 : xor_gate port map (a => a_xor_b, b => cin, y => sum);

  -- carry out is high if any of the AND terms are high
  U6 : or_gate port map (a => a_and_b, b => a_and_cin, cin => b_and_cin, y => cout);

end str;