library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixVectorProduct_3x3 is
    Port (

        -- Matrix M
        M11  : in  integer;   -- Input matrix A element (1,1)
        M12  : in  integer;   -- Input matrix A element (1,2)
        M13  : in  integer;   -- Input matrix A element (1,3)
        M21  : in  integer;   -- Input matrix A element (2,1)
        M22  : in  integer;   -- Input matrix A element (2,2)
        M23  : in  integer;   -- Input matrix A element (2,3)
        M31  : in  integer;   -- Input matrix A element (3,1)
        M32  : in  integer;   -- Input matrix A element (3,2)
        M33  : in  integer;   -- Input matrix A element (3,3)

        -- Vector X
        x1   : in  integer;   -- Input vector x element (1)
        x2   : in  integer;   -- Input vector x element (2)
        x3   : in  integer;   -- Input vector x element (3)

        -- Vector y = Mx
        y1   : out integer;   -- Output vector y element (1)
        y2   : out integer;   -- Output vector y element (2)
        y3   : out integer    -- Output vector y element (3)
    );
end entity MatrixVectorProduct_3x3;

architecture Combinational of MatrixVectorProduct_3x3 is
begin
    process (M11, M12, M13, M21, M22, M23, M31, M32, M33, x1, x2, x3)
    begin
        -- Perform matrix-vector multiplication
        y1 <= M11 * x1 + M12 * x2 + M13 * x3;
        y2 <= M21 * x1 + M22 * x2 + M23 * x3;
        y3 <= M31 * x1 + M32 * x2 + M33 * x3;
    end process;
end architecture Combinational;
