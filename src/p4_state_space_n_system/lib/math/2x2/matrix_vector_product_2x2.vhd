library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixVectorProduct_2x2 is
    Port (
        clk  : in  std_logic; -- Clock input
        rst  : in  std_logic; -- Reset input
        A11  : in  integer;   -- Input matrix A element (1,1)
        A12  : in  integer;   -- Input matrix A element (1,2)
        A21  : in  integer;   -- Input matrix A element (2,1)
        A22  : in  integer;   -- Input matrix A element (2,2)
        x1   : in  integer;   -- Input vector x element (1)
        x2   : in  integer;   -- Input vector x element (2)
        y1   : out integer;   -- Output vector y element (1)
        y2   : out integer    -- Output vector y element (2)
    );
end entity MatrixVectorProduct_2x2;

architecture Behavioral_MatrixVectorProduct_2x2 of MatrixVectorProduct_2x2 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            y1 <= 0;
            y2 <= 0;
        elsif rising_edge(clk) then
            -- Perform matrix-vector multiplication
            y1 <= A11 * x1 + A12 * x2;
            y2 <= A21 * x1 + A22 * x2;
        end if;
    end process;
end Behavioral_MatrixVectorProduct_2x2;
