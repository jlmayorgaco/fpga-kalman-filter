library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VectorSum_3x1 is
    Port (
        x1  : in  integer;     -- Input vector x element (1)
        x2  : in  integer;     -- Input vector x element (2)
        x3  : in  integer;     -- Input vector x element (3)
        y1  : in  integer;     -- Input vector y element (1)
        y2  : in  integer;     -- Input vector y element (2)
        y3  : in  integer;     -- Input vector y element (3)
        z1  : out integer;     -- Output vector z element (1)
        z2  : out integer;     -- Output vector z element (2)
        z3  : out integer      -- Output vector z element (3)
    );
end entity VectorSum_3x1;

architecture Behavioral_VectorSum_3x1 of VectorSum_3x1 is
begin
    -- Perform vector addition
    z1 <= x1 + y1;
    z2 <= x2 + y2;
    z3 <= x3 + y3;
end Behavioral_VectorSum_3x1;
