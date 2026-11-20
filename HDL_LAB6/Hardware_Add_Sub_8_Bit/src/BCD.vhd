library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    bcd           : in  std_logic_vector(3 downto 0);
    seven_seg_out : out std_logic_vector(6 downto 0)
  );
end BCD;

architecture bcd_to_seven_seg of BCD is

begin

  process(clk, reset)
  begin

    if reset = '1' then
      seven_seg_out <= "1111111";

    elsif rising_edge(clk) then

      case bcd is

        -- Zero
        when "0000" =>
          seven_seg_out <= "1000000";

        -- One
        when "0001" =>
          seven_seg_out <= "1111001";

        -- Two
        when "0010" =>
          seven_seg_out <= "0100100";

        -- Three
        when "0011" =>
          seven_seg_out <= "0110000";

        -- Four
        when "0100" =>
          seven_seg_out <= "0011001";

        -- Five
        when "0101" =>
          seven_seg_out <= "0010010";

        -- Six
        when "0110" =>
          seven_seg_out <= "0000010";

        -- Seven
        when "0111" =>
          seven_seg_out <= "1111000";

        -- Eight
        when "1000" =>
          seven_seg_out <= "0000000";

        -- Nine
        when "1001" =>
          seven_seg_out <= "0010000";

        -- Invalid BCD inputs (10-15)
        when others =>
          seven_seg_out <= "1111111";

      end case;

    end if;

  end process;

end bcd_to_seven_seg;
