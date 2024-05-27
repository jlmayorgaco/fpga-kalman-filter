library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vector_Derivator_3x1_Testbench is
end entity Vector_Derivator_3x1_Testbench;

architecture testbench of Vector_Derivator_3x1_Testbench is
    -- Constants for simulation parameters
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period (10 ns)

    -- ANSI escape codes for colors
    constant ANSI_RESET : string := "\033[0m";
    constant ANSI_RED : string := "\033[31;1;4m";
    constant ANSI_GREEN : string := "\033[32;1;4m";
    constant ANSI_YELLOW : string := "\033[33m";
    constant ANSI_BLUE : string := "\033[34m";
    constant ANSI_MAGENTA : string := "\033[35m";
    constant ANSI_CYAN : string := "\033[36m";

    -- Component declaration
    component Vector_Derivator_3x1 is
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
    end component;

    -- Signals declaration
    signal clk : std_logic := '0';                 -- Clock signal
    signal rst : std_logic := '1';                 -- Reset signal
    signal x1, x2, x3 : integer := 0;              -- Input vectors
    signal dx1, dx2, dx3 : integer;                -- Output vectors

    -- Signals for unit tests
    signal t : integer := 0;          -- Unit test t

    signal utest1_pass : std_logic := '0';         -- Unit test passed flag
    signal all_tests_passed : boolean := true;     -- Overall test status flag

begin
    -- Instantiate the Vector_Derivator_3x1 module
    dut : Vector_Derivator_3x1
        port map (
            clk => clk,
            rst => rst,
            x1 => x1,
            x2 => x2,
            x3 => x3,
            dx1 => dx1,
            dx2 => dx2,
            dx3 => dx3
        );

    -- Clock process
    clk_process: process
    begin
        while now < 200 ns loop  -- Run for 200 ns
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stimulus: process
    begin

        report " ";
        wait for 20 ns;  -- Wait for initial signal stabilization

        rst <= '1';
        wait for 20 ns;
     
        -----------------------------------------------
        -- Test Case 1
        -- x = [1, 2, 3]
        -- Should calculate derivatives correctly
        -----------------------------------------------
        rst <= '0';
        x1 <= 10;
        x2 <= 20;
        x3 <= 30;

        wait for 10 ns;  -- Wait for clock edge
        if (dx1 = 10 and dx2 = 20 and dx3 = 30) then
            utest1_pass <= '1';
            report "[v/] Test case 1 passed";
        else
            utest1_pass <= '0';
            report "[X] Test case 1 failed: dx1 = " & integer'image(dx1) & ", dx2 = " & integer'image(dx2) & ", dx3 = " & integer'image(dx3);
            all_tests_passed <= false;
        end if;

        wait for 50 ns;

        -----------------------------------------------
        -- Test Case 2
        -- Reset and check reset functionality
        -----------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        if (dx1 = 0 and dx2 = 0 and dx3 = 0) then
            utest1_pass <= '1';
            report "[v/] Test case 2 passed";
        else
            utest1_pass <= '0';
            report "[X] Test case 2 failed: dx1 = " & integer'image(dx1) & ", dx2 = " & integer'image(dx2) & ", dx3 = " & integer'image(dx3);
            all_tests_passed <= false;
        end if;

        wait for 50 ns;


        -----------------------------------------------
        -- Final message indicating if all tests passed
        -----------------------------------------------
        if all_tests_passed then
            report " . . . . . . . .  [v/] All test cases passed!";
        else
            report " x x x x x x x x ";
            report "[X] Some test cases failed!";
        end if;


        wait;
    end process stimulus;

end architecture testbench;
