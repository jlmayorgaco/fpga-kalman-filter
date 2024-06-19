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
    signal topC11, topC12, topC13, topC21, topC22, topC23, topC31, topC32, topC33 : signed(127 downto 0);
    signal bottomC11, bottomC12, bottomC13, bottomC21, bottomC22, bottomC23, bottomC31, bottomC32, bottomC33 : signed(127 downto 0);
    signal mC11, mC12, mC13, mC21, mC22, mC23, mC31, mC32, mC33 : signed(127 downto 0);
    signal determinant : signed(127 downto 0);
    signal det1 : signed(127 downto 0);
    signal det2 : signed(127 downto 0);
    signal det3 : signed(127 downto 0);
    signal det4 : signed(127 downto 0);
    signal det5 : signed(127 downto 0);
    signal det6 : signed(127 downto 0);

    -- Convert input integers to signed 64-bit values
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

            -- Initialize all signals to a known value
            topC11 <= (others => '0');
            topC12 <= (others => '0');
            topC13 <= (others => '0');
            topC21 <= (others => '0');
            topC22 <= (others => '0');
            topC23 <= (others => '0');
            topC31 <= (others => '0');
            topC32 <= (others => '0');
            topC33 <= (others => '0');

            -- Initialize other signals similarly
            bottomC11 <= (others => '0');
            bottomC12 <= (others => '0');
            bottomC13 <= (others => '0');
            bottomC21 <= (others => '0');
            bottomC22 <= (others => '0');
            bottomC23 <= (others => '0');
            bottomC31 <= (others => '0');
            bottomC32 <= (others => '0');
            bottomC33 <= (others => '0');

            mC11 <= (others => '0');
            mC12 <= (others => '0');
            mC13 <= (others => '0');
            mC21 <= (others => '0');
            mC22 <= (others => '0');
            mC23 <= (others => '0');
            mC31 <= (others => '0');
            mC32 <= (others => '0');
            mC33 <= (others => '0');

            determinant <= (others => '0');
            det1 <= (others => '0');
            det2 <= (others => '0');
            det3 <= (others => '0');
            det4 <= (others => '0');
            det5 <= (others => '0');
            det6 <= (others => '0');

            valid <= '0';

        elsif rising_edge(clk) then
            -- Calculate the determinant of the 3x3 matrix

            det1 <= to_signed32(A11) * to_signed32(A22) * to_signed32(A33) * to_signed32(1) / ( SCALE * SCALE );
            det2 <= to_signed32(A12) * to_signed32(A23) * to_signed32(A31) * to_signed32(1) / ( SCALE * SCALE );
            det3 <= to_signed32(A13) * to_signed32(A21) * to_signed32(A32) * to_signed32(1) / ( SCALE * SCALE );
            det4 <= to_signed32(A13) * to_signed32(A22) * to_signed32(A31) * to_signed32(1) / ( SCALE * SCALE );
            det5 <= to_signed32(A12) * to_signed32(A21) * to_signed32(A33) * to_signed32(1) / ( SCALE * SCALE );
            det6 <= to_signed32(A11) * to_signed32(A23) * to_signed32(A32) * to_signed32(1) / ( SCALE * SCALE );

            determinant <=  det1 + det2 + det3 - det4 - det5 - det6 ;

            --if determinant /= 0 then
            if determinant /= 0 then

                -- Calculate the inverse matrix elements
                topC11 <= to_signed32(A22) * to_signed32(A33) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A23) * to_signed32(A32) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC12 <= to_signed32(A13) * to_signed32(A32) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A12) * to_signed32(A33) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC13 <= to_signed32(A12) * to_signed32(A23) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A13) * to_signed32(A22) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC21 <= to_signed32(A23) * to_signed32(A31) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A21) * to_signed32(A33) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC22 <= to_signed32(A11) * to_signed32(A33) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A13) * to_signed32(A31) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC23 <= to_signed32(A13) * to_signed32(A21) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A11) * to_signed32(A23) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC31 <= to_signed32(A21) * to_signed32(A32) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A22) * to_signed32(A31) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC32 <= to_signed32(A12) * to_signed32(A31) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A11) * to_signed32(A32) * to_signed32(1) * to_signed32(1) / ( SCALE );
                topC33 <= to_signed32(A11) * to_signed32(A22) * to_signed32(1) * to_signed32(1) / ( SCALE ) - to_signed32(A12) * to_signed32(A21) * to_signed32(1) * to_signed32(1) / ( SCALE );

                bottomC11 <= determinant;
                bottomC12 <= determinant;
                bottomC13 <= determinant;
                bottomC21 <= determinant;
                bottomC22 <= determinant;
                bottomC23 <= determinant;
                bottomC31 <= determinant;
                bottomC32 <= determinant;
                bottomC33 <= determinant;

                mC11 <= (topC11 + 1) / (bottomC11 + 1);
                mC12 <= (topC12 + 1) / (bottomC12 + 1);
                mC13 <= (topC13 + 1) / (bottomC13 + 1);
                mC21 <= (topC21 + 1) / (bottomC21 + 1);
                mC22 <= (topC22 + 1) / (bottomC22 + 1);
                mC23 <= (topC23 + 1) / (bottomC23 + 1);
                mC31 <= (topC31 + 1) / (bottomC31 + 1);
                mC32 <= (topC32 + 1) / (bottomC32 + 1);
                mC33 <= (topC33 + 1) / (bottomC33 + 1);

                -- Convert back to 32-bit signed integer for output
                C11 <= signed_to_integer(resize(bottomC11, 32));
                C12 <= signed_to_integer(resize(mC12, 32));
                C13 <= signed_to_integer(resize(mC13, 32));
                C21 <= signed_to_integer(resize(mC21, 32));
                C22 <= signed_to_integer(resize(mC22, 32));
                C23 <= signed_to_integer(resize(mC23, 32));
                C31 <= signed_to_integer(resize(mC31, 32));
                C32 <= signed_to_integer(resize(mC32, 32));
                C33 <= signed_to_integer(resize(mC33, 32));

                valid <= '1'; -- Inverse is valid
            else
                -- If determinant is zero, inverse does not exist
                C11 <= signed_to_integer(resize(mC11, 32)); -- 1000000000
                C12 <= 0; -- 1 000 000
                C13 <= 0; -- 1 000 000 000;

                C21 <= 0; -- 500000
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
