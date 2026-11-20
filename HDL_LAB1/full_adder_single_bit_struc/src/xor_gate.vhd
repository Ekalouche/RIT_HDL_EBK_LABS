-------------------------------------------------------------------------------
-- Elie Kalouche
-- 2 input XOR gate
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Simple 2-input XOR gate
entity xor_gate is
  port (
    a : in  std_logic;  -- input 1
    b : in  std_logic;  -- input 2
    y : out std_logic   -- output = a XOR b
  );
end xor_gate;

architecture beh of xor_gate is
begin
  -- Combinational logic: output high when inputs differ
  y <= a xor b;
end beh;