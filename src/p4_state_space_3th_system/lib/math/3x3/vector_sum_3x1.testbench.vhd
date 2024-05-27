library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vector_Sum_3x1_Testbench is
end entity Vector_Sum_3x1_Testbench;

architecture testbench of Vector_Sum_3x1_Testbench is
    -- Constants for simulation parameters
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period (10 ns)

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

begin
    -- Instantiate the VectorSum_3x1 module
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

        -----------------------------------------------
        -- It                                        --
        -- x = [0,0,0]                               --
        -- y = [0,0,0]                               --
        -- Should be                                 --
        -- z = [0,0,0]                               --
        -----------------------------------------------
        x1 <= 0;
        x2 <= 0;
        x3 <= 0;

        y1 <= 0;
        y2 <= 0;
        y3 <= 0;

        utest1_pass <= (z1 = 0) and (z2 = 0) and (z3 = 0);
        wait for 10 ns;  -- Wait for signal propagation
        -----------------------------------------------


        -----------------------------------------------
        -- It                                        --
        -- x = [1,2,3]                               --
        -- y = [4,5,6]                               --
        -- Should be                                 --
        -- z = [5,7,9]                               --
        -----------------------------------------------
        x1 <= 1;
        x2 <= 2;
        x3 <= 3;

        y1 <= 4;
        y2 <= 5;
        y3 <= 6;

        utest1_pass <= (z1 = 5) and (z2 = 7) and (z3 = 9);
        wait for 10 ns;  -- Wait for signal propagation
        -----------------------------------------------

        -- Display the result
        report "z1 = " & integer'image(z1) & ", z2 = " & integer'image(z2) & ", z3 = " & integer'image(z3);

        wait;
    end process stimulus;

end architecture testbench;
