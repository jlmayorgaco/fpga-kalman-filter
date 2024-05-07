library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Declare the entity
entity p1_2nd_system_step_response is
    Port (
        clk   : in  std_logic;   -- Clock input
        rst   : in  std_logic;   -- Reset input
        u     : in  integer;     -- Input integer
        y     : out integer      -- Output scaled integer
    );
end p1_2nd_system_step_response;

-- Define the architecture
architecture Behavioral of p1_2nd_system_step_response is
    signal scaled_u : integer := 0;   -- Intermediate signal to store scaled value
    signal sy : integer := 0;   -- Intermediate signal to store scaled value
    signal dy : integer := 0;   -- Intermediate signal to store scaled value
    signal ddy : integer := 0;   -- Intermediate signal to store scaled value
    constant MAX_VALUE : integer := 4095;  -- Maximum value to saturate
    constant MIN_VALUE : integer := -4095;  -- Maximum value to saturate
begin
    -- Process for scaling the input
    process(clk, rst)
    begin
        -- If reset is asserted, reset the scaled output
        if rst = '1' then
            scaled_u <= 0;
            sy <= 0;
            dy <= 0;
            ddy <= 0;

        -- Else if rising edge of the clock, scale the input by 2
        elsif rising_edge(clk) then
            scaled_u <= u * 2;
            ddy <= (u - 1) * 500 / 1024 - dy * 50 / 1024 - sy * 50 / 1024;
            dy  <= dy + ddy;
            sy  <= dy + sy;

            if ddy > MAX_VALUE then
                ddy <= MAX_VALUE;
            end if;

            if ddy < MIN_VALUE then
                ddy <= MIN_VALUE;
            end if;

            if dy > MAX_VALUE then
                dy <= MAX_VALUE;
            end if;

            if dy < MIN_VALUE then
                dy <= MIN_VALUE;
            end if;

            if sy > MAX_VALUE then
                sy <= MAX_VALUE;
            end if;

            if sy < MIN_VALUE then
                sy <= MIN_VALUE;
            end if;

        end if;
    end process;

    -- Assign the scaled output to the output port
    y <= sy;
end Behavioral;