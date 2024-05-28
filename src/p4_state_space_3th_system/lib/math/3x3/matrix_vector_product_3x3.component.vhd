library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Vector_Product_3x3 is
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
end entity Matrix_Vector_Product_3x3;

architecture Matrix_Vector_Product_3x3_RTL of Matrix_Vector_Product_3x3 is
    -- Define saturation range
    constant MIN_SATURATION : integer := -1000;  -- Minimum saturation value
    constant MAX_SATURATION : integer := 1000;   -- Maximum saturation value
begin
    process (M11, M12, M13, M21, M22, M23, M31, M32, M33, x1, x2, x3)
        variable temp_y1, temp_y2, temp_y3 : integer;
    begin
        -- Perform matrix-vector multiplication
        temp_y1 := M11; --M11 * x1 + M12 * x2 + M13 * x3;
        temp_y2 := 2 * M11; --M21 * x1 + M22 * x2 + M23 * x3;
        temp_y3 := M11; --M31 * x1 + M32 * x2 + M33 * x3;
        
        -- Saturation logic
        if temp_y1 < MIN_SATURATION then
            y1 <= MIN_SATURATION;
        elsif temp_y1 > MAX_SATURATION then
            y1 <= MAX_SATURATION;
        else
            y1 <= temp_y1;
        end if;
        
        if temp_y2 < MIN_SATURATION then
            y2 <= MIN_SATURATION;
        elsif temp_y2 > MAX_SATURATION then
            y2 <= MAX_SATURATION;
        else
            y2 <= temp_y2;
        end if;
        
        if temp_y3 < MIN_SATURATION then
            y3 <= MIN_SATURATION;
        elsif temp_y3 > MAX_SATURATION then
            y3 <= MAX_SATURATION;
        else
            y3 <= temp_y3;
        end if;
    end process;
end architecture Matrix_Vector_Product_3x3_RTL;

