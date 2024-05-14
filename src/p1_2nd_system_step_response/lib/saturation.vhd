library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Include the saturation module
-- Change the path to match the location of your Saturation.vhdl file
entity Saturation is
    Port (
        x       : in  integer;
        max_val : in  integer;
        min_val : in  integer;
        y       : out integer
    );
end entity Saturation;

architecture SaturationRTL of Saturation is
begin
    process(x, max_val, min_val)
    begin
        if x > max_val then
            y <= max_val;
        elsif x < min_val then
            y <= min_val;
        else
            y <= x;
        end if;
    end process;
end SaturationRTL;