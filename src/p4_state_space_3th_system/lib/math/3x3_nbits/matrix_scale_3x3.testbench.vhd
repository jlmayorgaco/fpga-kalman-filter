library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Scale_3x3_Testbench is
end entity Matrix_Scale_3x3_Testbench;

architecture testbench of Matrix_Scale_3x3_Testbench is

    -- Component declaration
    component Matrix_Scale_3x3
        Port (
            -- Scalar
            scalar_top     : in  integer;   -- Input scalar value
            scalar_bottom  : in  integer;   -- Input scalar value

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

            -- Matrix C
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
    signal scalar_top, scalar_bottom : integer := 1;  -- Scalar values
    signal A11, A12, A13, A21, A22, A23, A31, A32, A33 : integer := 0;  -- Matrix A elements
    signal C11, C12, C13, C21, C22, C23, C31, C32, C33 : integer := 0;  -- Output matrix elements

begin

    -- Instantiate the Matrix_Scale_3x3 module
    dut : Matrix_Scale_3x3
        port map (
            scalar_top => scalar_top,
            scalar_bottom => scalar_bottom,
            A11 => A11, A12 => A12, A13 => A13,
            A21 => A21, A22 => A22, A23 => A23,
            A31 => A31, A32 => A32, A33 => A33,
            C11 => C11, C12 => C12, C13 => C13,
            C21 => C21, C22 => C22, C23 => C23,
            C31 => C31, C32 => C32, C33 => C33
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Test Case 1: Scale by 1 (should return the original matrix)
        scalar_top <= 1;
        scalar_bottom <= 1;
        A11 <= 1; A12 <= 2; A13 <= 3;
        A21 <= 4; A22 <= 5; A23 <= 6;
        A31 <= 7; A32 <= 8; A33 <= 9;

        wait for 10 ns;

        assert C11 = 1 and C12 = 2 and C13 = 3 and
               C21 = 4 and C22 = 5 and C23 = 6 and
               C31 = 7 and C32 = 8 and C33 = 9
            report "Test Case 1 Failed: Scale by 1"
            severity error;

        -- Test Case 2: Scale by 2 (doubling the matrix)
        scalar_top <= 2;
        scalar_bottom <= 1;

        wait for 10 ns;

        assert C11 = 2 and C12 = 4 and C13 = 6 and
               C21 = 8 and C22 = 10 and C23 = 12 and
               C31 = 14 and C32 = 16 and C33 = 18
            report "Test Case 2 Failed: Scale by 2"
            severity error;

        -- Test Case 3: Scale by 1/2 (halving the matrix)
        scalar_top <= 1;
        scalar_bottom <= 2;

        wait for 10 ns;

        assert C11 = 0 and C12 = 1 and C13 = 1 and
               C21 = 2 and C22 = 2 and C23 = 3 and
               C31 = 3 and C32 = 4 and C33 = 4
            report "Test Case 3 Failed: Scale by 1/2"
            severity error;

        -- Test Case 4: Scale by -1 (negating the matrix)
        scalar_top <= -1;
        scalar_bottom <= 1;

        wait for 10 ns;

        assert C11 = -1 and C12 = -2 and C13 = -3 and
               C21 = -4 and C22 = -5 and C23 = -6 and
               C31 = -7 and C32 = -8 and C33 = -9
            report "Test Case 4 Failed: Scale by -1"
            severity error;

        -- End the simulation
        wait;
    end process stimulus;

end architecture testbench;
