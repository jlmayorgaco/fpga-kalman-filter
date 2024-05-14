library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Noise is
    Port (
        clk : in  std_logic;                     -- Clock input
        rst : in  std_logic;                     -- Reset input
        x   : in  integer;                       -- Input signal
        y   : out integer                        -- Output signal with noise
    );
end entity Noise;

architecture Behavioral of Noise is

    constant a : integer := 1;
    constant b : integer := 1;
    constant c : integer := 1;
    constant d : integer := 1;

    constant LFSR_WIDTH : integer := 16;
    signal s_lfsr_y : integer := 0;             -- Noise signal
    signal s_lfsr_count : integer := 0;          -- LFSR count
    signal s_lfsr_reg : std_logic_vector(31 downto 0) := (others => '0');   -- LFSR register
    signal s_lfsr_reg2 : std_logic_vector(31 downto 0) := (others => '0');  -- LFSR register
    signal s_lfsr_reg3 : std_logic_vector(31 downto 0) := (others => '0');  -- LFSR register
    signal s_lfsr_reg4 : std_logic_vector(31 downto 0) := (others => '0');  -- LFSR register
    signal lfsr_tap : std_logic;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_lfsr_y <= 0;                          -- Reset noise signal
            s_lfsr_count <= 0;                      -- Reset LFSR count
            s_lfsr_reg <= (others => '0');          -- Reset LFSR register
            s_lfsr_reg2 <= (others => '0');         -- Reset LFSR register
            s_lfsr_reg3 <= (others => '0');         -- Reset LFSR register
            s_lfsr_reg4 <= (others => '0');         -- Reset LFSR register
            y <= 0;                                 -- Reset output
        elsif rising_edge(clk) then
            -- Increment counters
            -- Increment counters
            if s_lfsr_count < 16 then
                s_lfsr_reg <= std_logic_vector(unsigned(s_lfsr_reg) + 1);
            end if;
            if s_lfsr_count < 8 then
                s_lfsr_reg2 <= std_logic_vector(unsigned(s_lfsr_reg2) + 1);
            end if;
            if s_lfsr_count < 4 then
                s_lfsr_reg3 <= std_logic_vector(unsigned(s_lfsr_reg3) + 1);
            end if;
            if s_lfsr_count < 2 then
                s_lfsr_reg4 <= std_logic_vector(unsigned(s_lfsr_reg4) + 1);
            end if;


            -- Update noise signal
            s_lfsr_y <= a * to_integer(unsigned(s_lfsr_reg)) + b * to_integer(unsigned(s_lfsr_reg2)) + c * to_integer(unsigned(s_lfsr_reg3)) + d * to_integer(unsigned(s_lfsr_reg4));

            -- Output signal with noise
            y <=  x;

            -- Increment LFSR count
            if s_lfsr_count = 19 then
                s_lfsr_count <= 0;
            else
                s_lfsr_count <= s_lfsr_count + 1;
            end if;
        end if;
    end process;
end Behavioral;
