library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vector_Integrator_3x1_Testbench is
end entity Vector_Integrator_3x1_Testbench;

architecture testbench of Vector_Integrator_3x1_Testbench is
    -- Constants for simulation parameters
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period (10 ns)

    -- ANSI escape codes for colors
    constant ANSI_RESET : string := "\033[0m";
    constant ANSI_RED : string := "\033[31;1;4m";
    constant ANSI_GREEN : string := "\033[32;1;4m";

    -- Component declaration
    component Vector_Scale_3x1 is
        Port (
            scalar_top : in  integer;   -- Scalar value
            scalar_bottom : in  integer;   -- Scalar value
            x1     : in  integer;   -- Input vector x element (1)
            x2     : in  integer;   -- Input vector x element (2)
            x3     : in  integer;   -- Input vector x element (3)
            y1     : out integer;   -- Output vector y element (1)
            y2     : out integer;   -- Output vector y element (2)
            y3     : out integer    -- Output vector y element (3)
        );
    end component;

    -- Signals declaration
    signal scalar_top, scalar_bottom, x1, x2, x3, y1, y2, y3 : integer := 0;  -- Input and output signals
    signal clk : std_logic := '0';                 -- Clock signal
    signal rst : std_logic := '1';                 -- Reset signal

    -- Signals Unit Test
    signal utest1_pass : std_logic := '0';         -- Unit Test Passed
    signal all_tests_passed : boolean := true;     -- Flag for overall test status

begin
    -- Instantiate the Vector_Scale_3x1 module
    dut : Vector_Scale_3x1
        port map (
            scalar_top => scalar_top,
            scalar_bottom => scalar_bottom,
            x1 => x1,
            x2 => x2,
            x3 => x3,
            y1 => y1,
            y2 => y2,
            y3 => y3
        );

    -- Clock process
    clk_process: process
    begin
        while now < 100 ns loop  -- Run for 100 ns
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
        wait for 20 ns;  -- Wait for initial signal stabilization

        -----------------------------------------------
        -- Test case 1: Scaling by 2
        -----------------------------------------------
        scalar_top <= 2;
        scalar_bottom <= 1;
        x1 <= 1;
        x2 <= 2;
        x3 <= 3;

        wait for 10 ns;  -- Wait for signal propagation

        if (y1 = 2 and y2 = 4 and y3 = 6) then
            utest1_pass <= '1';
            report ANSI_GREEN & "[v/] Test case 1 passed" & ANSI_RESET;
        else
            utest1_pass <= '0';
            report ANSI_RED & "[X] Test case 1 failed: y1 = " & integer'image(y1) & ", y2 = " & integer'image(y2) & ", y3 = " & integer'image(y3) & ANSI_RESET;
            all_tests_passed <= false;
        end if;
        wait for 50 ns;  -- Wait for signal propagation
        -----------------------------------------------

        -----------------------------------------------
        -- Test case 2: Scaling by 3/2 (with negative values)
        -----------------------------------------------
        scalar_top <= 3;
        scalar_bottom <= 2;
        x1 <= -3;
        x2 <= -6;
        x3 <= -9;

        wait for 10 ns;  -- Wait for signal propagation

        if (y1 = -4 and y2 = -9 and y3 = -13) then
            utest1_pass <= '1';
            report ANSI_GREEN & "[v/] Test case 2 passed" & ANSI_RESET;
        else
            utest1_pass <= '0';
            report ANSI_RED & "[X] Test case 2 failed: y1 = " & integer'image(y1) & ", y2 = " & integer'image(y2) & ", y3 = " & integer'image(y3) & ANSI_RESET;
            all_tests_passed <= false;
        end if;
        wait for 50 ns;  -- Wait for signal propagation
        -----------------------------------------------

        --------------------------------------------------
        -- UNIT TEST REPORT ---------------------------
        --------------------------------------------------
        -- Final message indicating if all tests passed
        --------------------------------------------------
        report " ";
        report " ";
         if all_tests_passed then
            report ANSI_GREEN & "[v/] All test cases passed!" & ANSI_RESET;
        else
            report ANSI_RED & "[X] Some test cases failed!" & ANSI_RESET;
            all_tests_passed <= false;
        end if;
        --------------------------------------------------

        wait;
    end process stimulus;

end architecture testbench;
