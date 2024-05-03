library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SecondOrderSystem is
    port (
        clk : in std_logic;
        reset : in std_logic;
        uk : in signed(31 downto 0); -- Input signal (16-bit signed integer)
        yk : out signed(63 downto 0) -- Output signal (16-bit signed integer)
    );
end entity SecondOrderSystem;

architecture Behavioral of SecondOrderSystem is

    constant a : signed(31 downto 0) := to_signed(1, 32);  -- Adjust coefficients as needed
    constant b : signed(31 downto 0) := to_signed(-1, 32); -- Adjust coefficients as needed
    constant c : signed(31 downto 0) := to_signed(-2, 32); -- Adjust coefficients as needed

    signal yk_0, yk_1, yk_2 : signed(32 downto 0); -- Use signed integers for signal initialization

begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Initialize state variables
            yk_0 <= (others => '0'); -- Initialize as signed integer
            yk_1 <= (others => '0'); -- Initialize as signed integer
            yk_2 <= (others => '0'); -- Initialize as signed integer
        elsif rising_edge(clk) then
            -- Update state variables using difference equations
            yk_2 <= yk_1;
            yk_1 <= yk_0;
            yk_0 <= a * u - b * yk_1 - c * yk_2;
        end if;
    end process;

    -- Output response
    yk <= yk_0; -- Assign the current output to the output port

end architecture Behavioral;