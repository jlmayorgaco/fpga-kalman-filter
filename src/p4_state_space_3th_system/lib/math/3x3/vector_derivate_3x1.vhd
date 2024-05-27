library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Derivator_3x1 is
    Port (
        clk : in std_logic;    -- Clock input
        rst : in std_logic;    -- Reset input
        x1  : in integer;      -- Current input vector x element (1)
        x2  : in integer;      -- Current input vector x element (2)
        x3  : in integer;      -- Current input vector x element (3)
        dx1 : out integer;     -- Output derivative dx/dt element (1)
        dx2 : out integer;     -- Output derivative dx/dt element (2)
        dx3 : out integer      -- Output derivative dx/dt element (3)
    );
end entity Derivator_3x1;

architecture Behavioral_Derivator_3x1 of Derivator_3x1 is

    constant DT_TOP : integer := 1;
    constant DT_BOTTOM : integer := 1;

    signal prev_x1 : integer := 0;  -- Previous value of x element (1)
    signal prev_x2 : integer := 0;  -- Previous value of x element (2)
    signal prev_x3 : integer := 0;  -- Previous value of x element (3)

begin
    process(clk, rst)
    begin
        if rst = '1' then
            prev_x1 <= 0;
            prev_x2 <= 0;
            prev_x3 <= 0;
            dx1 <= 0;
            dx2 <= 0;
            dx3 <= 0;
        elsif rising_edge(clk) then
            -- Compute the derivative (difference between current and previous values)
            dx1 <= DT_TOP * (x1 - prev_x1) / DT_BOTTOM;
            dx2 <= DT_TOP * (x2 - prev_x2) / DT_BOTTOM;
            dx3 <= DT_TOP * (x3 - prev_x3) / DT_BOTTOM;

            -- Store the current values for the next clock cycle
            prev_x1 <= x1;
            prev_x2 <= x2;
            prev_x3 <= x3;
        end if;
    end process;
end Behavioral_Derivator_3x1;
