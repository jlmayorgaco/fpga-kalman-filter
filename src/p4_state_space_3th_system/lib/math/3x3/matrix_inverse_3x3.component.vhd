library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Inverse_3x3 is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        A11, A12, A13 : in  integer;
        A21, A22, A23 : in  integer;
        A31, A32, A33 : in  integer;
        C11, C12, C13 : out integer;
        C21, C22, C23 : out integer;
        C31, C32, C33 : out integer;
        valid         : out std_logic
    );
end entity Matrix_Inverse_3x3;

architecture Matrix_Inverse_3x3_RTL of Matrix_Inverse_3x3 is
    signal determinant_factor_1 : integer;
    signal determinant_factor_2 : integer;
    signal determinant_factor_3 : integer;
    signal determinant : integer;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset all output signals and internal signals
            C11 <= 0;
            C12 <= 0;
            C13 <= 0;
            C21 <= 0;
            C22 <= 0;
            C23 <= 0;
            C31 <= 0;
            C32 <= 0;
            C33 <= 0;
            valid <= '0';
            determinant_factor_1 <= 0;
            determinant_factor_2 <= 0;
            determinant_factor_3 <= 0;
            determinant <= 0;
        elsif rising_edge(clk) then
            -- Calculate the determinant of the 3x3 matrix
            determinant_factor_1 <= A11 * (A22 * A33 - A23 * A32);
            determinant_factor_2 <= A12 * (A21 * A33 - A23 * A31);
            determinant_factor_3 <= A13 * (A21 * A32 - A22 * A31);
            determinant <= A11 * (A22 * A33 - A23 * A32) - A12 * (A21 * A33 - A23 * A31) + A13 * (A21 * A32 - A22 * A31);

            if determinant = 0 then
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
            else
                -- Calculate the inverse matrix elements
                C11 <= determinant;-- (A22 * A33 - A23 * A32) / determinant;
                C12 <= (A22 * A33 - A23 * A32); --(A13 * A32 - A12 * A33) / determinant;
                C13 <= (A22 * A33 - A23 * A32) / determinant; --(A12 * A23 - A13 * A22) / determinant;

                C21 <= (A23 * A31 - A21 * A33) / determinant;
                C22 <= (A11 * A33 - A13 * A31) / determinant;
                C23 <= (A13 * A21 - A11 * A23) / determinant;

                C31 <= (A21 * A32 - A22 * A31) / determinant;
                C32 <= (A12 * A31 - A11 * A32) / determinant;
                C33 <= (A11 * A22 - A12 * A21) / determinant;

                valid <= '1'; -- Inverse is valid
            end if;
        end if;
    end process;
end architecture Matrix_Inverse_3x3_RTL;
