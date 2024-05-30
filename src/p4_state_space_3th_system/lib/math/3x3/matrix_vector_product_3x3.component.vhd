library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixVectorProduct_3x3 is
    Port (
        clk  : in  std_logic; -- Clock input
        rst  : in  std_logic; -- Reset input

        M11  : in  integer;   -- Input matrix A element (1,1)
        M12  : in  integer;   -- Input matrix A element (1,2)
        M13  : in  integer;   -- Input matrix A element (1,2)
        M21  : in  integer;   -- Input matrix A element (2,1)
        M22  : in  integer;   -- Input matrix A element (2,2)
        M23  : in  integer;   -- Input matrix A element (2,2)
        M31  : in  integer;   -- Input matrix A element (2,2)
        M32  : in  integer;   -- Input matrix A element (2,2)
        M33  : in  integer;   -- Input matrix A element (2,2)

        x1   : in  integer;   -- Input vector x element (1)
        x2   : in  integer;   -- Input vector x element (2)
        x3   : in  integer;   -- Input vector x element (2)

        y1   : out integer;   -- Output vector y element (1)
        y2   : out integer;   -- Output vector y element (1)
        y3   : out integer    -- Output vector y element (2)
    );
end entity MatrixVectorProduct_3x3;

architecture Behavioral_MatrixVectorProduct_3x3 of MatrixVectorProduct_3x3 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            y1 <= 0;
            y2 <= 0;
            y3 <= 0;
        elsif rising_edge(clk) then
            -- Perform matrix-vector multiplication
            y1 <= M11 * x1 + M12 * x2 + M13 * x3;
            y2 <= M21 * x1 + M22 * x2 + M23 * x3;
            y3 <= M31 * x1 + M32 * x2 + M33 * x3;
        end if;
    end process;
end Behavioral_MatrixVectorProduct_3x3;