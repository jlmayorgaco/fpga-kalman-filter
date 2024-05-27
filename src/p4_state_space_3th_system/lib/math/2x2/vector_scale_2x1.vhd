library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VectorScale_2x1 is
    Port (
        clk    : in std_logic; -- Clock input
        rst    : in std_logic; -- Reset input
        scalar : in integer;   -- Scalar value
        x1     : in integer;   -- Input vector x element (1)
        x2     : in integer;   -- Input vector x element (2)
        y1     : out integer;  -- Output vector y element (1)
        y2     : out integer   -- Output vector y element (2)
    );
end entity VectorScale_2x1;

architecture Behavioral_VectorScale_2x1 of VectorScale_2x1 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            y1 <= 0;
            y2 <= 0;
        elsif rising_edge(clk) then
            -- Perform vector scaling
            y1 <= x1 * scalar;
            y2 <= x2 * scalar;
        end if;
    end process;
end Behavioral_VectorScale_2x1;
