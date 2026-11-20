-------------------------------------------------------------------------------
-- Elie Kalouche
-- 2 input and gate
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Simple 2-input AND gate
entity and_gate is
  port (
    a : in  std_logic;  -- input 1
    b : in  std_logic;  -- input 2
    y : out std_logic   -- output = a AND b
  );
end and_gate;

architecture beh of and_gate is
begin
  -- Combinational logic: output high only when both inputs are high
  y <= a and b;
end beh;