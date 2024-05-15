library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PID is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        x     : in  integer;
        y     : out integer
    );
end entity PID;

architecture PIDRTL of PID is
    -- Internal signal for storing the previous output value
    signal s_y : integer := 0;
    signal s_y_prev : integer := 0;

    -- Filter coefficients (adjust these based on your desired cutoff frequency)
    constant K_p : integer := 10;
    constant K_i : integer := 10;
    constant K_d : integer := 10;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset the internal state and output when the reset signal is asserted
            s_y <= 0;
            s_y_prev <= 0;
        elsif rising_edge(clk) then
            -- Update the output using the first-order low-pass filter equation
            s_y <= s_y_prev + (x - s_y_prev) / ALPHA;
            -- Store the current output value for the next iteration
            s_y_prev <= s_y;
        end if;

        y <= s_y_prev;
    end process;
end PIDRTL;