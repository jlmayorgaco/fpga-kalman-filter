library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Vector_Product_3x3_Testbench is
end entity Matrix_Vector_Product_3x3_Testbench;

architecture testbench of Matrix_Vector_Product_3x3_Testbench is

    -- Component declaration
    component Matrix_Vector_Product_3x3 is
        Port (
            M11  : in  integer;   -- Input matrix M element (1,1)
            M12  : in  integer;   -- Input matrix M element (1,2)
            M13  : in  integer;   -- Input matrix M element (1,3)
            M21  : in  integer;   -- Input matrix M element (2,1)
            M22  : in  integer;   -- Input matrix M element (2,2)
            M23  : in  integer;   -- Input matrix M element (2,3)
            M31  : in  integer;   -- Input matrix M element (3,1)
            M32  : in  integer;   -- Input matrix M element (3,2)
            M33  : in  integer;   -- Input matrix M element (3,3)

            x1   : in  integer;   -- Input vector x element (1)
            x2   : in  integer;   -- Input vector x element (2)
            x3   : in  integer;   -- Input vector x element (3)

            y1   : out integer;   -- Output vector y element (1)
            y2   : out integer;   -- Output vector y element (2)
            y3   : out integer    -- Output vector y element (3)
        );
    end component;

    -- Signals declaration
    signal M11, M12, M13 : integer;
    signal M21, M22, M23 : integer;
    signal M31, M32, M33 : integer;
    signal x1, x2, x3 : integer;
    signal y1, y2, y3 : integer;

    -- Signals for unit tests
    signal all_tests_passed : boolean := true;

begin

    -- Instantiate the Matrix_Vector_Product_3x3 module
    dut : Matrix_Vector_Product_3x3
        port map (
            M11 => M11,
            M12 => M12,
            M13 => M13,
            M21 => M21,
            M22 => M22,
            M23 => M23,
            M31 => M31,
            M32 => M32,
            M33 => M33,
            x1 => x1,
            x2 => x2,
            x3 => x3,
            y1 => y1,
            y2 => y2,
            y3 => y3
        );

    -- Stimulus process
    stimulus: process
    begin

        report " ";

        ------------------------------------------------
        -- Test Case 1
        -- Matrix M = identity matrix, vector x = [1, 2, 3]
        -- Expected result: y = [1, 2, 3]
        ------------------------------------------------
        M11 <= 1; M12 <= 0; M13 <= 0;
        M21 <= 0; M22 <= 1; M23 <= 0;
        M31 <= 0; M32 <= 0; M33 <= 1;
        x1 <= 1; x2 <= 2; x3 <= 3;
        wait for 10 ns;

        if (y1 = 1 and y2 = 2 and y3 = 3) then
            report "Test case 1 passed";
        else
            report "Test case 1 failed: y1 = " & integer'image(y1) & ", y2 = " & integer'image(y2) & ", y3 = " & integer'image(y3);
            all_tests_passed <= false;
        end if;

        ------------------------------------------------
        -- Test Case 2
        -- Matrix M = [[1, 2, 3], [4, 5, 6], [7, 8, 9]], vector x = [1, 1, 1]
        -- Expected result: y = [6, 15, 24]
        ------------------------------------------------
        M11 <= 1; M12 <= 2; M13 <= 3;
        M21 <= 4; M22 <= 5; M23 <= 6;
        M31 <= 7; M32 <= 8; M33 <= 9;
        x1 <= 1; x2 <= 1; x3 <= 1;
        wait for 10 ns;

        if (y1 = 6 and y2 = 15 and y3 = 24) then
            report "Test case 2 passed";
        else
            report "Test case 2 failed: y1 = " & integer'image(y1) & ", y2 = " & integer'image(y2) & ", y3 = " & integer'image(y3);
            all_tests_passed <= false;
        end if;

        ------------------------------------------------
        -- Test Case 3
        -- Matrix M = [[2, 0, 1], [0, -1, 3], [1, 1, 1]], vector x = [1, 2, 3]
        -- Expected result: y = [5, 7, 6]
        ------------------------------------------------
        M11 <= 2; M12 <= 0; M13 <= 1;
        M21 <= 0; M22 <= -1; M23 <= 3;
        M31 <= 1; M32 <= 1; M33 <= 1;
        x1 <= 1; x2 <= 2; x3 <= 3;
        wait for 10 ns;

        if (y1 = 5 and y2 = 7 and y3 = 6) then
            report "Test case 3 passed";
        else
            report "Test case 3 failed: y1 = " & integer'image(y1) & ", y2 = " & integer'image(y2) & ", y3 = " & integer'image(y3);
            all_tests_passed <= false;
        end if;

        -----------------------------------------------
        -- Final message indicating if all tests passed
        -----------------------------------------------
        if all_tests_passed then
            report " . . . . . . . .  [v/] All test cases passed!";
        else
            report " x x x x x x x x ";
            report "[X] Some test cases failed!";
        end if;

        wait;
    end process stimulus;

end architecture testbench;
