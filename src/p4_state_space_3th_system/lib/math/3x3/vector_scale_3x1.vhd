library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VectorScale_3x1 is
    Port (
        scalar_top : in  integer;   -- Scalar value
        scalar_bottom : in  integer;   -- Scalar value
        x1     : in  integer;   -- Input vector x element (1)
        x2     : in  integer;   -- Input vector x element (2)
        x3     : in  integer;   -- Input vector x element (3)
        y1     : out integer;   -- Output vector y element (1)
        y2     : out integer;   -- Output vector y element (2)
        y3     : out integer    -- Output vector y element (3)
    );
end entity VectorScale_3x1;

architecture Behavioral_VectorScale_3x1 of VectorScale_3x1 is
begin
    -- Perform vector scaling
    y1 <= scalar_top * x1 / scalar_bottom;
    y2 <= scalar_top * x2 / scalar_bottom;
    y3 <= scalar_top * x3 / scalar_bottom;
end Behavioral_VectorScale_3x1;
