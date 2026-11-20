-------------------------------------------------------------------------------
-- Elie Kalouche
-- 3 input or gate
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Simple 3-input OR gate
entity or_gate is
  port (
    a   : in  std_logic;  -- input 1
    b   : in  std_logic;  -- input 2
    cin : in  std_logic;  -- input 3
    y   : out std_logic   -- output = a OR b OR cin
  );
end or_gate;

architecture beh of or_gate is
begin
  -- Combinational logic: output high if any input is high
  y <= a or b or cin;
end beh;