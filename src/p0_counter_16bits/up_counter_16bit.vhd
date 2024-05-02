library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter_16bit is
    port (
        clk    : in  std_logic;             -- Clock input
        reset  : in  std_logic;             -- Reset input
        count  : out std_logic_vector(15 downto 0)  -- 16-bit count output
    );
end entity up_counter_16bit;

architecture rtl of up_counter_16bit is
    signal counter : unsigned(15 downto 0);  -- 16-bit counter signal
begin
    process (clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');  -- Reset counter to zero
        elsif rising_edge(clk) then
            counter <= counter + 1;      -- Increment counter on rising edge of clock
        end if;
    end process;

    -- Output the counter value
    count <= std_logic_vector(counter);
end architecture rtl;
