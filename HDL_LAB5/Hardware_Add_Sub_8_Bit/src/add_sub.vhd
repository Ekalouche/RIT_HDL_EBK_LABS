
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port (
        A, B   : in std_logic_vector(8 downto 0);
        op     : in std_logic_vector(1 downto 0);
        Result : out std_logic_vector(8 downto 0)
    );
end add_sub;

architecture behavior of add_sub is
begin

    process(A, B, op)
    begin
        case op is
            when "10" =>
                Result <= std_logic_vector(unsigned(A) + unsigned(B));

            when "01" =>
                Result <= std_logic_vector(unsigned(A) - unsigned(B));

            when others =>
                Result <= (others => '0');
        end case;
    end process;

end behavior;
