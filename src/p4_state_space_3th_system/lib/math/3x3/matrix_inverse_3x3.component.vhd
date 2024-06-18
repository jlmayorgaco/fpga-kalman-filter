library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Inverse_3x3 is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;

        SCALE         : in  integer;

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
    signal determinant : signed(31 downto 0);
    signal p1, p2, p3  : signed(31 downto 0);

    signal pC11        : signed(63 downto 0);
    signal pC12        : signed(63 downto 0);
    signal pC13        : signed(127 downto 0);

    signal nC11        : signed(63 downto 0);
    signal nC12        : signed(63 downto 0);
    signal nC13        : signed(127 downto 0);

    signal topC13        : signed(127 downto 0);
    signal bottomC13     : signed(127 downto 0);
    signal mC13          : signed(127 downto 0);

    -- Convert input integers to signed 32-bit values


    -- Convert input integers to signed 64-bit values
    function to_signed64(value: integer) return signed is
        begin
            return to_signed(value, 64);
        end function;

    function to_signed32(value: integer) return signed is
        begin
            return to_signed(value, 32);
    end function;

    -- Custom function to convert signed value to integer
    function signed_to_integer(value: signed) return integer is
    begin
        return to_integer(value);
    end function;

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

            determinant <= (others => '0');
            p1 <= (others => '0');
            p2 <= (others => '0');
            p3 <= (others => '0');

        elsif rising_edge(clk) then
            -- Calculate the determinant of the 3x3 matrix
            p1 <= (others => '0');
            p2 <= (others => '0');
            p3 <= (others => '0');

            determinant <= 1 + p1 - p2 + p3;

            if determinant /= 0 then

                -- Calculate the inverse matrix elements using larger range types
                -- Example calculation to check for overflow
                pC11 <= to_signed64(10000);
                pC12 <= to_signed32(10000) * to_signed32(10000);
                pC13 <= to_signed32(A11) * to_signed32(A11) * to_signed32(A11) * to_signed32(1);

                topC13 <= to_signed32(21004) * to_signed32(10000) * to_signed32(10000) * to_signed32(1);
                bottomC13 <= to_signed32(10000) * to_signed32(10000) * to_signed32(1) * to_signed32(1);
                mC13 <= topC13 / bottomC13;

                -- Convert back to 32-bit signed integer for output
                C11 <= signed_to_integer(resize(mC13, 32));
                C12 <= 1;
                C13 <= 1;
                C21 <= 1;
                C22 <= 1;
                C23 <= 1;
                C31 <= 1;
                C32 <= 1;
                C33 <= 1;

                valid <= '1'; -- Inverse is valid
            else
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
            end if;
        end if;
    end process;
end architecture Matrix_Inverse_3x3_RTL;
