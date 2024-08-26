library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MatrixScale_2x2 is
    Port (
        clk     : in  std_logic; -- Clock input
        rst     : in  std_logic; -- Reset input
        scalar  : in  integer;   -- Input scalar value
        A11     : in  integer;   -- Input matrix A element (1,1)
        A12     : in  integer;   -- Input matrix A element (1,2)
        A21     : in  integer;   -- Input matrix A element (2,1)
        A22     : in  integer;   -- Input matrix A element (2,2)
        C11     : out integer;   -- Output matrix C element (1,1)
        C12     : out integer;   -- Output matrix C element (1,2)
        C21     : out integer;   -- Output matrix C element (2,1)
        C22     : out integer    -- Output matrix C element (2,2)
    );
end entity MatrixScale_2x2;

architecture Behavioral_MatrixScale_2x2 of MatrixScale_2x2 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            C11 <= 0;
            C12 <= 0;
            C21 <= 0;
            C22 <= 0;
        elsif rising_edge(clk) then
            C11 <= scalar * A11;
            C12 <= scalar * A12;
            C21 <= scalar * A21;
            C22 <= scalar * A22;
        end if;
    end process;
end Behavioral_MatrixScale_2x2;