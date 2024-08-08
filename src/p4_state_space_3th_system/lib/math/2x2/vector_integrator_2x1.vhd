library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Integrator_2x1 is
    Port (
        clk : in std_logic;    -- Clock input
        rst : in std_logic;    -- Reset input
        x1  : in integer;      -- Input vector x element (1)
        x2  : in integer;      -- Input vector x element (2)
        int_x1 : out integer;  -- Output integral of x element (1)
        int_x2 : out integer   -- Output integral of x element (2)
    );
end entity Integrator_2x1;

architecture Behavioral_Integrator_2x1 of Integrator_2x1 is
    signal sum_x1 : integer := 0;  -- Accumulated sum for x element (1)
    signal sum_x2 : integer := 0;  -- Accumulated sum for x element (2)

    constant DT_TOP : integer := 1;
    constant DT_BOTTOM : integer := 100;

    constant MAX_VALUE : integer := 1000000; -- Define maximum saturation value
    constant MIN_VALUE : integer := -1000000; -- Define minimum saturation value

begin
    process(clk, rst)
    begin
        if rst = '1' then
            sum_x1 <= 0;
            sum_x2 <= 0;
            int_x1 <= 0;
            int_x2 <= 0;
        elsif rising_edge(clk) then
            -- Perform integration (accumulation)
            sum_x1 <= sum_x1 + DT_TOP * (x1 / DT_BOTTOM);
            sum_x2 <= sum_x2 + DT_TOP * (x2 / DT_BOTTOM);

            -- Apply saturation
            if sum_x1 > MAX_VALUE then
                int_x1 <= MAX_VALUE;
            elsif sum_x1 < MIN_VALUE then
                int_x1 <= MIN_VALUE;
            else
                int_x1 <= sum_x1;
            end if;

            if sum_x2 > MAX_VALUE then
                int_x2 <= MAX_VALUE;
            elsif sum_x2 < MIN_VALUE then
                int_x2 <= MIN_VALUE;
            else
                int_x2 <= sum_x2;
            end if;
        end if;
    end process;
end Behavioral_Integrator_2x1;
