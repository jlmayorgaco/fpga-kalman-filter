library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Scale_3x3 is
    Port (

        -- Scalar
        scalar_top  : in  integer;   -- Input scalar value
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

        -- Matrix C,
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
end entity Matrix_Scale_3x3;

architecture Matrix_Scale_3x3_RTL of Matrix_Scale_3x3 is
begin
    process (scalar_top, scalar_bottom, A11, A12, A13, A21, A22, A23, A31, A32, A33)
    begin
        -- Perform matrix scaling
        C11 <= scalar_top * A11 / scalar_bottom;
        C12 <= scalar_top * A12 / scalar_bottom;
        C13 <= scalar_top * A13 / scalar_bottom;

        C21 <= scalar_top * A21 / scalar_bottom;
        C22 <= scalar_top * A22 / scalar_bottom;
        C23 <= scalar_top * A23 / scalar_bottom;

        C31 <= scalar_top * A31 / scalar_bottom;
        C32 <= scalar_top * A32 / scalar_bottom;
        C33 <= scalar_top * A33 / scalar_bottom;
    end process;
end architecture Matrix_Scale_3x3_RTL;
