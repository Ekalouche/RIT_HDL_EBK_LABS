
library ieee;
use ieee.std_logic_1164.all;

entity Operator is
    port (
        clk, reset : in std_logic;
        A, B       : in std_logic;
        flag       : out std_logic_vector(1 downto 0)
    );
end Operator;

architecture behavior of Operator is
begin

    process(clk, reset)
    begin
        if reset = '1' then
            flag <= "00";
        elsif rising_edge(clk) then
            if A = '1' then
                flag <= "10";
            elsif B = '1' then
                flag <= "01";
            end if;
        end if;
    end process;

end behavior;
