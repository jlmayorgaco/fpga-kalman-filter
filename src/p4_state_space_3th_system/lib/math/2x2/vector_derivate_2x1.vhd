library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Derivator_2x1 is
    Port (
        clk : in std_logic;    -- Clock input
        rst : in std_logic;    -- Reset input
        x1  : in integer;      -- Current input vector x element (1)
        x2  : in integer;      -- Current input vector x element (2)
        dx1 : out integer;     -- Output derivative dx/dt element (1)
        dx2 : out integer      -- Output derivative dx/dt element (2)
    );
end entity Derivator_2x1;

architecture Behavioral_Derivator_2x1 of Derivator_2x1 is
    signal prev_x1 : integer := 0;  -- Previous value of x element (1)
    signal prev_x2 : integer := 0;  -- Previous value of x element (2)
begin
    process(clk, rst)
    begin
        if rst = '1' then
            prev_x1 <= 0;
            prev_x2 <= 0;
            dx1 <= 0;
            dx2 <= 0;
        elsif rising_edge(clk) then
            -- Compute the derivative (difference between current and previous values)
            dx1 <= x1 - prev_x1;
            dx2 <= x2 - prev_x2;

            -- Store the current values for the next clock cycle
            prev_x1 <= x1;
            prev_x2 <= x2;
        end if;
    end process;
end Behavioral_Derivator_2x1;
