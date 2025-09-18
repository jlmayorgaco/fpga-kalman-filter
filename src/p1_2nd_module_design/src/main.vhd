library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Declare the entity
entity Main is
    Port (
        clk   : in  std_logic;   -- Clock input
        rst   : in  std_logic;   -- Reset input
        u     : in  integer;     -- Input integer
        y     : out integer      -- Output scaled integer
    );
end Main;

-- Define the architecture
architecture Behavioral of Main is

    signal s_y : integer := 0;   -- Intermediate signal to store scaled value
    signal s_dy : integer := 0;   -- Intermediate signal to store scaled value
    signal s_ddy : integer := 0;   -- Intermediate signal to store scaled value

    constant SCALE_VALUE : integer := 8192; -- Scaled Value to Represent 1
    constant SCALE_DT : integer := 100; -- Scaled Value to Represent 1

    constant MAX_VALUE : integer := 65536;  -- Maximum value to saturate
    constant MIN_VALUE : integer := -65536;  -- Maximum value to saturate

    constant K : integer := 1 * SCALE_VALUE;

    constant b2 : integer := 1 * SCALE_VALUE;
    constant b1 : integer := 1 * SCALE_VALUE;
    constant b0 : integer := 10 * SCALE_VALUE;

    constant a0 : integer := 4 * SCALE_VALUE;

begin
    -- Process for scaling the input
    process(clk, rst)
    begin
        -- If reset is asserted, reset the scaled output
        if rst = '1' then
            s_y <= 0;
            s_dy <= 0;
            s_ddy <= 0;

        -- Else if rising edge of the clock
        elsif rising_edge(clk) then
            s_ddy <= (u) * (a0 / b2) - s_dy * (b1 / b2) - s_y * (b0 / b2);
            s_dy  <= s_dy + s_ddy / SCALE_DT;
            s_y  <= s_y + s_dy / SCALE_DT;

        -- Saturate the result if it goes beyond the maximum or minimum value
        if s_y > MAX_VALUE then
            s_y <= MAX_VALUE;
        elsif s_y < MIN_VALUE then
            s_y <= MIN_VALUE;
        end if;

        end if;
    end process;

    -- Assign the scaled output to the output port
    y <= s_y;
end Behavioral;