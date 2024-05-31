library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Inverse_3x3_Testbench is
end entity Matrix_Inverse_3x3_Testbench;

architecture testbench of Matrix_Inverse_3x3_Testbench is

    -- Component declaration
    component Matrix_Inverse_3x3
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            A11, A12, A13 : in integer;
            A21, A22, A23 : in integer;
            A31, A32, A33 : in integer;
            C11, C12, C13 : out integer;
            C21, C22, C23 : out integer;
            C31, C32, C33 : out integer;
            valid         : out std_logic
        );
    end component;

    -- Signals declaration
    signal clk, reset                          : std_logic := '0';  -- Clock and reset signals
    signal A11, A12, A13, A21, A22, A23, A31, A32, A33 : integer := 0;  -- Matrix A elements
    signal C11, C12, C13, C21, C22, C23, C31, C32, C33 : integer := 0;  -- Output matrix elements
    signal valid                                       : std_logic := '0'; -- Valid signal

    signal alpha                                       : integer := 1;  -- Scaling factor

    -- Clock generation
    constant clk_period : time := 10 ns;

begin

    -- Clock process definition
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process clk_process;


    -- Instantiate the Matrix_Inverse_3x3 module
    dut : Matrix_Inverse_3x3
        port map (
            clk => clk,
            reset => reset,
            A11 => A11, A12 => A12, A13 => A13,
            A21 => A21, A22 => A22, A23 => A23,
            A31 => A31, A32 => A32, A33 => A33,
            C11 => C11, C12 => C12, C13 => C13,
            C21 => C21, C22 => C22, C23 => C23,
            C31 => C31, C32 => C32, C33 => C33,
            valid => valid
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Initialize reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test Case 1: Identity Matrix (should result in Identity Matrix)
        alpha <= 100;
        wait for 10 ns;
        A11 <= 1 * alpha; A12 <= 0 * alpha; A13 <= 0 * alpha;
        A21 <= 0 * alpha; A22 <= 1 * alpha; A23 <= 0 * alpha;
        A31 <= 0 * alpha; A32 <= 0 * alpha; A33 <= 1 * alpha;

        wait for 30 ns;
        assert C11 = 1 * alpha and C12 = 0 * alpha and C13 = 0 * alpha and
               C21 = 0 * alpha and C22 = 1 * alpha and C23 = 0 * alpha and
               C31 = 0 * alpha and C32 = 0 * alpha and C33 = 1 * alpha and
               valid = '1'
            report "Test Case 1 Failed: Identity Matrix. Expected (1,0,0; 0,1,0; 0,0,1, valid=1), Got (" & 
               integer'image(C11) & "," & integer'image(C12) & "," & integer'image(C13) & "; " &
               integer'image(C21) & "," & integer'image(C22) & "," & integer'image(C23) & "; " &
               integer'image(C31) & "," & integer'image(C32) & "," & integer'image(C33) & ", valid=" & std_logic'image(valid) & ")"
            severity error;

        -- Test Case 2: Arbitrary invertible matrix
        alpha <= 1;
        wait for 10 ns;
        A11 <=  2 * alpha; A12 <= -1 * alpha; A13 <=  0 * alpha;
        A21 <= -1 * alpha; A22 <=  2 * alpha; A23 <= -1 * alpha;
        A31 <=  0 * alpha; A32 <= -1 * alpha; A33 <=  2 * alpha;

        wait for 30 ns;

        assert C11 = 2 * alpha and C12 = 1 * alpha and C13 = 0 * alpha and
               C21 = 1 * alpha and C22 = 2 * alpha and C23 = 1 * alpha and
               C31 = 0 * alpha and C32 = 1 * alpha and C33 = 2 * alpha and
               valid = '1'
            report "Test Case 2 Failed: Arbitrary invertible matrix. Expected (2,1,0; 1,2,1; 0,1,2, valid=1), Got (" & 
                integer'image(C11) & "," & integer'image(C12) & "," & integer'image(C13) & "; " &
                integer'image(C21) & "," & integer'image(C22) & "," & integer'image(C23) & "; " &
                integer'image(C31) & "," & integer'image(C32) & "," & integer'image(C33) & ", valid=" & std_logic'image(valid) & ")"
            severity error;

        -- Test Case 3: Non-invertible matrix (determinant = 0)
        wait for 10 ns;
        A11 <= 1; A12 <= 2; A13 <= 3;
        A21 <= 4; A22 <= 5; A23 <= 6;
        A31 <= 7; A32 <= 8; A33 <= 9;

        wait for 30 ns;

        assert C11 = 0 and C12 = 0 and C13 = 0 and
               C21 = 0 and C22 = 0 and C23 = 0 and
               C31 = 0 and C32 = 0 and C33 = 0 and
               valid = '0'
            report "Test Case 3 Failed: Non-invertible matrix. Expected (0,0,0; 0,0,0; 0,0,0, valid=0), Got (" & 
                integer'image(C11) & "," & integer'image(C12) & "," & integer'image(C13) & "; " &
                integer'image(C21) & "," & integer'image(C22) & "," & integer'image(C23) & "; " &
                integer'image(C31) & "," & integer'image(C32) & "," & integer'image(C33) & ", valid=" & std_logic'image(valid) & ")"
            severity error;

        -- Test Case 4: Invertible matrix
        wait for 10 ns;
        A11 <= 4; A12 <= 7; A13 <= 2;
        A21 <= 3; A22 <= 6; A23 <= 1;
        A31 <= 2; A32 <= 5; A33 <= 1;

        wait for 30 ns;

        assert C11 = -1 and C12 = 1 and C13 = 0 and
               C21 = 2 and C22 = -2 and C23 = 1 and
               C31 = 1 and C32 = -1 and C33 = 0 and
               valid = '1'
            report "Test Case 4 Failed: Invertible matrix. Expected (-1,1,0; 2,-2,1; 1,-1,0, valid=1), Got (" & 
                integer'image(C11) & "," & integer'image(C12) & "," & integer'image(C13) & "; " &
                integer'image(C21) & "," & integer'image(C22) & "," & integer'image(C23) & "; " &
                integer'image(C31) & "," & integer'image(C32) & "," & integer'image(C33) & ", valid=" & std_logic'image(valid) & ")"
            severity error;

        -- End the simulation
        wait;
    end process stimulus;

end architecture testbench;
