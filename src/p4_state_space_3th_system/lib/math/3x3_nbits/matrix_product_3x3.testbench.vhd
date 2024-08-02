library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Product_3x3_Testbench is
end entity Matrix_Product_3x3_Testbench;

architecture testbench of Matrix_Product_3x3_Testbench is

    -- Component declaration
    component Matrix_Product_3x3
        Port (
            A11, A12, A13 : in integer; -- Input matrix A elements
            A21, A22, A23 : in integer;
            A31, A32, A33 : in integer;
            B11, B12, B13 : in integer; -- Input matrix B elements
            B21, B22, B23 : in integer;
            B31, B32, B33 : in integer;
            C11, C12, C13 : out integer; -- Output matrix C elements
            C21, C22, C23 : out integer;
            C31, C32, C33 : out integer
        );
    end component;

    -- Signals declaration
    signal A11, A12, A13, A21, A22, A23, A31, A32, A33 : integer := 0;  -- Matrix A elements
    signal B11, B12, B13, B21, B22, B23, B31, B32, B33 : integer := 0;  -- Matrix B elements
    signal C11, C12, C13, C21, C22, C23, C31, C32, C33 : integer := 0;  -- Output matrix elements

begin

    -- Instantiate the Matrix_Product_3x3 module
    dut : Matrix_Product_3x3
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
        -- Test Case 1: Identity Matrix multiplied by Identity Matrix
        wait for 10 ns;
        A11 <= 1; A12 <= 0; A13 <= 0;
        A21 <= 0; A22 <= 1; A23 <= 0;
        A31 <= 0; A32 <= 0; A33 <= 1;

        B11 <= 1; B12 <= 0; B13 <= 0;
        B21 <= 0; B22 <= 1; B23 <= 0;
        B31 <= 0; B32 <= 0; B33 <= 1;

        wait for 10 ns;

        assert C11 = 1 and C12 = 0 and C13 = 0 and
               C21 = 0 and C22 = 1 and C23 = 0 and
               C31 = 0 and C32 = 0 and C33 = 1
            report "Test Case 1 Failed: Identity Matrix multiplied by Identity Matrix"
            severity error;

        -- Test Case 2: Arbitrary Matrices
        wait for 10 ns;
        A11 <= 1; A12 <= 2; A13 <= 3;
        A21 <= 4; A22 <= 5; A23 <= 6;
        A31 <= 7; A32 <= 8; A33 <= 9;

        B11 <= 9; B12 <= 8; B13 <= 7;
        B21 <= 6; B22 <= 5; B23 <= 4;
        B31 <= 3; B32 <= 2; B33 <= 1;

        wait for 10 ns;

        assert C11 = 30 and C12 = 24 and C13 = 18 and
               C21 = 84 and C22 = 69 and C23 = 54 and
               C31 = 138 and C32 = 114 and C33 = 90
            report "Test Case 2 Failed: Arbitrary Matrices"
            severity error;

        -- Test Case 3: Zero Matrices
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
            report "Test Case 3 Failed: Zero Matrices"
            severity error;

        -- Test Case 4: Multiplying by Identity Matrix
        wait for 10 ns;
        A11 <= 1; A12 <= 0; A13 <= 0;
        A21 <= 0; A22 <= 1; A23 <= 0;
        A31 <= 0; A32 <= 0; A33 <= 1;

        B11 <= 1; B12 <= 2; B13 <= 3;
        B21 <= 4; B22 <= 5; B23 <= 6;
        B31 <= 7; B32 <= 8; B33 <= 9;

        wait for 10 ns;

        assert C11 = 1 and C12 = 2 and C13 = 3 and
               C21 = 4 and C22 = 5 and C23 = 6 and
               C31 = 7 and C32 = 8 and C33 = 9
            report "Test Case 4 Failed: Multiplying by Identity Matrix"
            severity error;

        -- End the simulation
        wait;
    end process stimulus;

end architecture testbench;
