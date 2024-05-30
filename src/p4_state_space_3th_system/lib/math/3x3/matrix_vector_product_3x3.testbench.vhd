library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixVectorProduct_3x3_Testbench is
end entity MatrixVectorProduct_3x3_Testbench;

architecture testbench of MatrixVectorProduct_3x3_Testbench is
    -- Constants for simulation parameters
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period (10 ns)

    -- Component declaration
    component MatrixVectorProduct_3x3
        Port (
            clk  : in  std_logic; -- Clock input
            rst  : in  std_logic; -- Reset input

            M11  : in  integer;   -- Input matrix A element (1,1)
            M12  : in  integer;   -- Input matrix A element (1,2)
            M13  : in  integer;   -- Input matrix A element (1,2)
            M21  : in  integer;   -- Input matrix A element (2,1)
            M22  : in  integer;   -- Input matrix A element (2,2)
            M23  : in  integer;   -- Input matrix A element (2,2)
            M31  : in  integer;   -- Input matrix A element (2,2)
            M32  : in  integer;   -- Input matrix A element (2,2)
            M33  : in  integer;   -- Input matrix A element (2,2)

            x1   : in  integer;   -- Input vector x element (1)
            x2   : in  integer;   -- Input vector x element (2)
            x3   : in  integer;   -- Input vector x element (2)

            y1   : out integer;   -- Output vector y element (1)
            y2   : out integer;   -- Output vector y element (1)
            y3   : out integer    -- Output vector y element (2)
        );
    end component;

    -- Signals declaration
    signal clk : std_logic := '0';     -- Clock signal
    signal rst : std_logic := '1';     -- Reset signal
    signal M11, M12, M13, M21, M22, M23, M31, M32, M33 : integer := 0;  -- Matrix elements
    signal x1, x2, x3 : integer := 0;              -- Vector elements
    signal y1, y2, y3 : integer := 0;              -- Output vector elements

begin

    -- Instantiate the MatrixVectorProduct_3x3 module
    dut : MatrixVectorProduct_3x3
        port map (
            clk => clk,
            rst => rst,
            M11 => M11,
            M12 => M12,
            M13 => M13,
            M21 => M21,
            M22 => M22,
            M23 => M23,
            M31 => M31,
            M32 => M32,
            M33 => M33,
            x1  => x1,
            x2  => x2,
            x3  => x3,
            y1  => y1,
            y2  => y2,
            y3  => y3
        );

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop  -- Run for 100 ns
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
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

       -- Test Case 1
        -- Identity Matrix (M = I), x = [1, 0, 0]
        wait for 10 ns;
        M11 <= 1; M12 <= 0; M13 <= 0;
        M21 <= 0; M22 <= 1; M23 <= 0;
        M31 <= 0; M32 <= 0; M33 <= 1;
        x1 <= 1; x2 <= 0; x3 <= 0;
        wait for 10 ns;
        assert y1 = 1 and y2 = 0 and y3 = 0
            report "Test Case 1 Failed: Identity Matrix, x = [1, 0, 0]"
            severity error;

        -- Test Case 2
        -- Arbitrary Matrix, x = [0, 1, 0]
        wait for 10 ns;
        M11 <= 1; M12 <= 2; M13 <= 3;
        M21 <= 4; M22 <= 5; M23 <= 6;
        M31 <= 7; M32 <= 8; M33 <= 9;
        x1 <= 0; x2 <= 1; x3 <= 0;
        wait for 10 ns;
        assert y1 = 2 and y2 = 5 and y3 = 8
            report "Test Case 2 Failed: Arbitrary Matrix, x = [0, 1, 0]"
            severity error;

        -- End the simulation
        wait;
    end process stimulus;

end architecture testbench;
