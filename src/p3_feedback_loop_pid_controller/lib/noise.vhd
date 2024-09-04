library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Noise is
    Port (
        clk : in  std_logic;         -- Clock input
        rst : in  std_logic;         -- Reset input
        x   : in  integer;           -- Input signal
        y   : out integer            -- Output signal with noise
    );
end entity Noise;

architecture Behavioral of Noise is

    constant A : integer := 2;
    constant B : integer := 4;
    constant C : integer := 8;
    constant D : integer := 16;
    constant E : integer := 32;
    constant F : integer := 64;

    constant P0 : integer := 128;
    constant P1 : integer := 64;
    constant P2 : integer := 32;
    constant P3 : integer := 16;
    constant P4 : integer := 8;
    constant P5 : integer := 4;

    constant DIVIDER : integer := 1;  -- Integer division factor

    signal s_lfsr_y : integer := 0;             -- Noise signal
    signal s_lfsr_count1 : integer := 0;        -- LFSR count
    signal s_lfsr_count2 : integer := 0;        -- LFSR count
    signal s_lfsr_count3 : integer := 0;        -- LFSR count
    signal s_lfsr_count4 : integer := 0;        -- LFSR count
    signal s_lfsr_count5 : integer := 0;        -- LFSR count
    signal s_lfsr_count6 : integer := 0;        -- LFSR count

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_lfsr_y <= 0;              -- Reset noise signal
            s_lfsr_count1 <= 0;
            s_lfsr_count2 <= 0;
            s_lfsr_count3 <= 0;
            s_lfsr_count4 <= 0;
            s_lfsr_count5 <= 0;
            s_lfsr_count6 <= 0;
            y <= 0;                     -- Reset output
        elsif rising_edge(clk) then

            -- Increment counters
            if s_lfsr_count1 < A then
                s_lfsr_count1 <= s_lfsr_count1 + 1;
            else
                s_lfsr_count1 <= 0;
            end if;

            if s_lfsr_count2 < B then
                s_lfsr_count2 <= s_lfsr_count2 + 1;
            else
                s_lfsr_count2 <= 0;
            end if;

            if s_lfsr_count3 < C then
                s_lfsr_count3 <= s_lfsr_count3 + 1;
            else
                s_lfsr_count3 <= 0;
            end if;

            if s_lfsr_count4 < D then
                s_lfsr_count4 <= s_lfsr_count4 + 1;
            else
                s_lfsr_count4 <= 0;
            end if;

            if s_lfsr_count5 < E then
                s_lfsr_count5 <= s_lfsr_count5 + 1;
            else
                s_lfsr_count5 <= 0;
            end if;

            if s_lfsr_count6 < F then
                s_lfsr_count6 <= s_lfsr_count6 + 1;
            else
                s_lfsr_count6 <= 0;
            end if;

            s_lfsr_y <= P0 * (s_lfsr_count1 - A/2) +
                        P1 * (s_lfsr_count2 - B/2) +
                        P2 * (s_lfsr_count3 - C/2) +
                        P3 * (s_lfsr_count4 - D/2) +
                        P4 * (s_lfsr_count5 - E/2) +
                        P5 * (s_lfsr_count6 - F/2);

            -- Output signal with noise
            y <= x + s_lfsr_y;

        end if;
    end process;

end Behavioral;
