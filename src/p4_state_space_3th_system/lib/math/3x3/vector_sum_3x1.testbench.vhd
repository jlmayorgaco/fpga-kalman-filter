library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vector_Sum_3x1_Testbench is
end entity Vector_Sum_3x1_Testbench;

architecture testbench of Vector_Sum_3x1_Testbench is
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
    component Vector_Sum_3x1 is
        Port (
            x1  : in  integer;     -- Input vector x element (1)
            x2  : in  integer;     -- Input vector x element (2)
            x3  : in  integer;     -- Input vector x element (3)
            y1  : in  integer;     -- Input vector y element (1)
            y2  : in  integer;     -- Input vector y element (2)
            y3  : in  integer;     -- Input vector y element (3)
            z1  : out integer;     -- Output vector z element (1)
            z2  : out integer;     -- Output vector z element (2)
            z3  : out integer      -- Output vector z element (3)
        );
    end component;

    -- Signals declaration
    signal x1, x2, x3, y1, y2, y3 : integer := 0;  -- Input vectors
    signal z1, z2, z3 : integer;                   -- Output vector
    signal clk : std_logic := '0';                 -- Clock signal
    signal rst : std_logic := '1';                 -- Reset signal

    -- Signals Unit Test
    signal utest1_pass : std_logic := '0';         -- Unit Test Passed
    signal all_tests_passed : boolean := true;     -- Flag for overall test status

begin
    -- Instantiate the Vector_Sum_3x1 module
    dut : Vector_Sum_3x1
        port map (
            x1 => x1,
            x2 => x2,
            x3 => x3,
            y1 => y1,
            y2 => y2,
            y3 => y3,
            z1 => z1,
            z2 => z2,
            z3 => z3
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

        report " ";
        -----------------------------------------------
        -- It                                        --
        -- x = [0,0,0]                               --
        -- y = [0,0,0]                               --
        -- Should be                                 --
        -- z = [0,0,0]                               --
        -----------------------------------------------
        wait for 10 ns;

        x1 <= 0;
        x2 <= 0;
        x3 <= 0;

        y1 <= 0;
        y2 <= 0;
        y3 <= 0;

        wait for 10 ns;
        if (z1 = 0 and z2 = 0 and z3 = 0) then
            utest1_pass <= '1';
            report "[v/] Test case 1 passed";
        else
            utest1_pass <= '0';
            report "[X] Test case 1 failed: z1 = " & integer'image(z1) & ", z2 = " & integer'image(z2) & ", z3 = " & integer'image(z3);
        end if;
        wait for 50 ns;  -- Wait for signal propagation
        -----------------------------------------------

        -----------------------------------------------
        -- It                                        --
        -- x = [1,2,3]                               --
        -- y = [4,5,6]                               --
        -- Should be                                 --
        -- z = [5,7,9]                               --
        -----------------------------------------------
        wait for 10 ns;

        x1 <= 1;
        x2 <= 2;
        x3 <= 3;

        y1 <= 4;
        y2 <= 5;
        y3 <= 6;

        wait for 10 ns;
        if (z1 = 5 and z2 = 7 and z3 = 9) then
            utest1_pass <= '1';
            report "[v/] Test case 2 passed";
        else
            utest1_pass <= '0';
            report "[X] Test case 2 failed: z1 = " & integer'image(z1) & ", z2 = " & integer'image(z2) & ", z3 = " & integer'image(z3);
            all_tests_passed <= false;
        end if;
        wait for 50 ns;  -- Wait for signal propagation
        -----------------------------------------------


     --------------------------------------------------
        -- It                                        --
        -- x = [1,2,3]                               --
        -- y = [4,5,6]                               --
        -- Should be                                 --
        -- z = [5,7,9]                               --
        -----------------------------------------------

        wait for 10 ns;
        x1 <= 1000;
        x2 <= 2000;
        x3 <= 3000;

        y1 <= -1000;
        y2 <= -2000;
        y3 <= -3000;

        wait for 10 ns;
        if (z1 = 0 and z2 = 0 and z3 = 0) then
            utest1_pass <= '1';
            report "[v/] Test case 3 passed";
        else
            utest1_pass <= '0';
            all_tests_passed <= false;
            report "[X] Test case 3 failed: z1 = " & integer'image(z1) & ", z2 = " & integer'image(z2) & ", z3 = " & integer'image(z3);
        end if;
        wait for 50 ns;  -- Wait for signal propagation
        -----------------------------------------------
        -- UNIT TEST REPORT ---------------------------
        -----------------------------------------------
        -- Final message indicating if all tests passed
        -----------------------------------------------
         if all_tests_passed then
            report " . . . . . . . .  [v/] All test cases passed!";
        else
            report " x x x x x x x x ";
            report "[X] Some test cases failed!";
            all_tests_passed <= false;
        end if;
        -----------------------------------------------

        wait;
    end process stimulus;

end architecture testbench;
