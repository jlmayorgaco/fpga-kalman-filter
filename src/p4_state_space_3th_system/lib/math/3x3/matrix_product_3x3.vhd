library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixProduct_3x3 is
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
end entity MatrixProduct_3x3;

architecture Combinational of MatrixProduct_3x3 is
begin
    process (A11, A12, A13, A21, A22, A23, A31, A32, A33,
             B11, B12, B13, B21, B22, B23, B31, B32, B33)
    begin
        -- Perform matrix multiplication
        C11 <= A11 * B11 + A12 * B21 + A13 * B31;
        C12 <= A11 * B12 + A12 * B22 + A13 * B32;
        C13 <= A11 * B13 + A12 * B23 + A13 * B33;

        C21 <= A21 * B11 + A22 * B21 + A23 * B31;
        C22 <= A21 * B12 + A22 * B22 + A23 * B32;
        C23 <= A21 * B13 + A22 * B23 + A23 * B33;

        C31 <= A31 * B11 + A32 * B21 + A33 * B31;
        C32 <= A31 * B12 + A32 * B22 + A33 * B32;
        C33 <= A31 * B13 + A32 * B23 + A33 * B33;
    end process;
end architecture Combinational;

