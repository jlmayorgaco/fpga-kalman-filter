library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Sum_3x3 is
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
end entity Matrix_Sum_3x3;

architecture Combinational of Matrix_Sum_3x3 is
begin
    process (A11, A12, A13, A21, A22, A23, A31, A32, A33, B11, B12, B13, B21, B22, B23, B31, B32, B33)
    begin
        -- Perform matrix sum
        C11 <= A11 + B11;
        C12 <= A12 + B12;
        C13 <= A13 + B13;

        C21 <= A21 + B21;
        C22 <= A22 + B22;
        C23 <= A23 + B23;

        C31 <= A31 + B31;
        C32 <= A32 + B32;
        C33 <= A33 + B33;
    end process;
end architecture Combinational;
