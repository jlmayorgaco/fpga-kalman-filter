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
            sum_x1 <= sum_x1 + x1;
            sum_x2 <= sum_x2 + x2;

            -- Output the integrated values
            int_x1 <= sum_x1;
            int_x2 <= sum_x2;
        end if;
    end process;
end Behavioral_Integrator_2x1;