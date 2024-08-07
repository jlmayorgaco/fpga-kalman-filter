library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Sum_3x3_Testbench is
end entity Matrix_Sum_3x3_Testbench;

architecture testbench of Matrix_Sum_3x3_Testbench is
    -- Constants for simulation parameters
    constant CLOCK_PERIOD : time := 10 ns;  -- Clock period (10 ns)

    -- Component declaration
    component Matrix_Sum_3x3
        Port (
            -- Matrix A
            A11     : in  integer;   -- Input matrix A element (1,1)
            A12     : in  integer;   -- Input matrix A element (1,2)
            A13     : in  integer;   -- Input matrix A element (1,3)
            A21     : in  integer;   -- Input matrix A element (2,1)
            A22     : in  integer;   -- Input matrix A element (2,2)
            A23     : in  integer;   -- Input matrix A element (2,3)
            A31     : in  integer;   -- Input matrix A element (3,1)
            A32     : in  integer;   -- Input matrix A element (3,2)
            A33     : in  integer;   -- Input matrix A element (3,3)

            -- Matrix B
            B11     : in  integer;   -- Input matrix B element (1,1)
            B12     : in  integer;   -- Input matrix B element (1,2)
            B13     : in  integer;   -- Input matrix B element (1,3)
            B21     : in  integer;   -- Input matrix B element (2,1)
            B22     : in  integer;   -- Input matrix B element (2,2)
            B23     : in  integer;   -- Input matrix B element (2,3)
            B31     : in  integer;   -- Input matrix B element (3,1)
            B32     : in  integer;   -- Input matrix B element (3,2)
            B33     : in  integer;   -- Input matrix B element (3,3)

            -- Matrix C = A + B
            C11     : out integer;   -- Output matrix C element (1,1)
            C12     : out integer;   -- Output matrix C element (1,2)
            C13     : out integer;   -- Output matrix C element (1,3)
            C21     : out integer;   -- Output matrix C element (2,1)
            C22     : out integer;   -- Output matrix C element (2,2)
            C23     : out integer;   -- Output matrix C element (2,3)
            C31     : out integer;   -- Output matrix C element (3,1)
            C32     : out integer;   -- Output matrix C element (3,2)
            C33     : out integer    -- Output matrix C element (3,3)
        );
    end component;

    -- Signals declaration
    signal A11, A12, A13, A21, A22, A23, A31, A32, A33 : integer := 0;  -- Matrix A elements
    signal B11, B12, B13, B21, B22, B23, B31, B32, B33 : integer := 0;  -- Matrix B elements
    signal C11, C12, C13, C21, C22, C23, C31, C32, C33 : integer := 0;  -- Output matrix elements

begin

    -- Instantiate the MatrixSum_3x3 module
    dut : Matrix_Sum_3x3
        port map (
            A11 => A11, A12 => A12, A13 => A13,
            A21 => A21, A22 => A22, A23 => A23,
            A31 => A31, A32 => A32, A33 => A33,
            B11 => B11, B12 => B12, B13 => B13,
            B21 => B21, B22 => B22, B23 => B23,
            B31 => B31, B32 => B32, B33 => B33,
            C11 => C11, C12 => C12, C13 => C13,
            C21 => C21, C22 => C22, C23 => C23,
            C31 => C31, C32 => C32, C33 => C33
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test Case 1
        -- Identity Matrix (A = I), B = zeros
        wait for 10 ns;
        A11 <= 1; A12 <= 0; A13 <= 0;
        A21 <= 0; A22 <= 1; A23 <= 0;
        A31 <= 0; A32 <= 0; A33 <= 1;

        B11 <= 0; B12 <= 0; B13 <= 0;
        B21 <= 0; B22 <= 0; B23 <= 0;
        B31 <= 0; B32 <= 0; B33 <= 0;

        wait for 10 ns;

        assert C11 = 1 and C12 = 0 and C13 = 0 and
               C21 = 0 and C22 = 1 and C23 = 0 and
               C31 = 0 and C32 = 0 and C33 = 1
            report "Test Case 1 Failed: Identity Matrix (A = I), B = zeros"
            severity error;

        -- Test Case 2
        -- Arbitrary Matrices
        wait for 10 ns;
        A11 <= 1; A12 <= 2; A13 <= 3;
        A21 <= 4; A22 <= 5; A23 <= 6;
        A31 <= 7; A32 <= 8; A33 <= 9;

        B11 <= 9; B12 <= 8; B13 <= 7;
        B21 <= 6; B22 <= 5; B23 <= 4;
        B31 <= 3; B32 <= 2; B33 <= 1;

        wait for 10 ns;

        assert C11 = 10 and C12 = 10 and C13 = 10 and
               C21 = 10 and C22 = 10 and C23 = 10 and
               C31 = 10 and C32 = 10 and C33 = 10
            report "Test Case 2 Failed: Arbitrary Matrices"
            severity error;

        -- Test Case 3
        -- Zero Matrix
        wait for 10 ns;
        A11 <= 0; A12 <= 0; A13 <= 0;
        A21 <= 0; A22 <= 0; A23 <= 0;
        A31 <= 0; A32 <= 0; A33 <= 0;

        B11 <= 0; B12 <= 0; B13 <= 0;
        B21 <= 0; B22 <= 0; B23 <= 0;
        B31 <= 0; B32 <= 0; B33 <= 0;

        wait for 10 ns;

        assert C11 = 0 and C12 = 0 and C13 = 0 and
               C21 = 0 and C22 = 0 and C23 = 0 and
               C31 = 0 and C32 = 0 and C33 = 0
            report "Test Case 3 Failed: Zero Matrix"
            severity error;

        -- Test Case 4
        -- Identity Matrix
        wait for 10 ns;
        A11 <= 1; A12 <= 0; A13 <= 0;
        A21 <= 0; A22 <= 1; A23 <= 0;
        A31 <= 0; A32 <= 0; A33 <= 1;

        B11 <= 1; B12 <= 0; B13 <= 0;
        B21 <= 0; B22 <= 1; B23 <= 0;
        B31 <= 0; B32 <= 0; B33 <= 1;

        wait for 10 ns;

        assert C11 = 2 and C12 = 0 and C13 = 0 and
               C21 = 0 and C22 = 2 and C23 = 0 and
               C31 = 0 and C32 = 0 and C33 = 2
            report "Test Case 4 Failed: Identity Matrix"
            severity error;

        -- End the simulation
        wait;
    end process stimulus;

end architecture testbench;
