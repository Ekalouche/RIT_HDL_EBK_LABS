
library ieee;
use ieee.std_logic_1164.all;

entity Pader is
    port (
        A     : in std_logic_vector(7 downto 0);
        A_Pad : out std_logic_vector(8 downto 0)
    );
end Pader;

architecture behavior of Pader is
begin

    A_Pad <= '0' & A;

end behavior;
