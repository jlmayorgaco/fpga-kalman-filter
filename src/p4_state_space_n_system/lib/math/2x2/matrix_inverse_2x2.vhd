library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixInverse_2x2 is
    Port (
        clk  : in  std_logic; -- Clock input
        rst  : in  std_logic; -- Reset input
        A11  : in  integer;   -- Input matrix A element (1,1)
        A12  : in  integer;   -- Input matrix A element (1,2)
        A21  : in  integer;   -- Input matrix A element (2,1)
        A22  : in  integer;   -- Input matrix A element (2,2)
        C11  : out integer;   -- Output matrix C element (1,1)
        C12  : out integer;   -- Output matrix C element (1,2)
        C21  : out integer;   -- Output matrix C element (2,1)
        C22  : out integer;   -- Output matrix C element (2,2)
        valid : out std_logic -- Output signal to indicate valid inverse
    );
end entity MatrixInverse_2x2;

architecture Behavioral_MatrixInverse_2x2 of MatrixInverse_2x2 is
    signal determinant : integer;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            C11 <= 0;
            C12 <= 0;
            C21 <= 0;
            C22 <= 0;
            determinant <= 0;
            valid <= '0';
        elsif rising_edge(clk) then
            determinant <= A11 * A22 - A12 * A21;
            if determinant /= 0 then
                C11 <= A22 / determinant;
                C12 <= -A12 / determinant;
                C21 <= -A21 / determinant;
                C22 <= A11 / determinant;
                valid <= '1'; -- Inverse is valid
            else
                C11 <= 0;
                C12 <= 0;
                C21 <= 0;
                C22 <= 0;
                valid <= '0'; -- Inverse is not valid
            end if;
        end if;
    end process;
end Behavioral_MatrixInverse_2x2;
