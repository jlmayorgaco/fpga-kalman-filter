library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixInverse_3x3 is
    Port (
        A11, A12, A13 : in  integer;
        A21, A22, A23 : in  integer;
        A31, A32, A33 : in  integer;
        C11, C12, C13 : out integer;
        C21, C22, C23 : out integer;
        C31, C32, C33 : out integer;
        valid         : out std_logic
    );
end entity MatrixInverse_3x3;

architecture Combinational of MatrixInverse_3x3 is
    signal determinant : integer;
begin
    process (A11, A12, A13, A21, A22, A23, A31, A32, A33)
    begin
        -- Calculate the determinant of the 3x3 matrix
        determinant <= A11 * (A22 * A33 - A23 * A32) -
                       A12 * (A21 * A33 - A23 * A31) +
                       A13 * (A21 * A32 - A22 * A31);

        if determinant /= 0 then
            -- Calculate the inverse matrix elements
            C11 <= (A22 * A33 - A23 * A32) / determinant;
            C12 <= (A13 * A32 - A12 * A33) / determinant;
            C13 <= (A12 * A23 - A13 * A22) / determinant;

            C21 <= (A23 * A31 - A21 * A33) / determinant;
            C22 <= (A11 * A33 - A13 * A31) / determinant;
            C23 <= (A13 * A21 - A11 * A23) / determinant;

            C31 <= (A21 * A32 - A22 * A31) / determinant;
            C32 <= (A12 * A31 - A11 * A32) / determinant;
            C33 <= (A11 * A22 - A12 * A21) / determinant;

            valid <= '1'; -- Inverse is valid
        else
            -- If determinant is zero, inverse does not exist
            C11 <= 0;
            C12 <= 0;
            C13 <= 0;
            C21 <= 0;
            C22 <= 0;
            C23 <= 0;
            C31 <= 0;
            C32 <= 0;
            C33 <= 0;
            valid <= '0'; -- Inverse is not valid
        end if;
    end process;
end architecture Combinational;
