library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Main is
    Port (
        clk  : in std_logic;
        rst  : in std_logic;
        ref  : in integer;
        dist : in integer;
        y    : out integer
    );
end Main;

architecture Behavioral of Main is

    signal s_pre_y1 : integer := 0;
    signal s_pre_y2 : integer := 0;
    signal s_y : integer := 0;
    signal s_u1 : integer := 0;
    signal s_u2 : integer := 0;
    signal s_e : integer := 0;

    constant SCALE_VALUE : integer := 8192;
    constant SCALE_DT : integer := 100;

    constant MAX_VALUE : integer := 65536;
    constant MIN_VALUE : integer := -65536;

    component PlantStateSpace2ndOrder is
        Port (
            clk : in std_logic;
            rst : in std_logic;
            u1  : in integer;
            u2  : in integer;
            y1  : out integer;
            y2  : out integer
        );
    end component;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_u1 <= 0;
            s_u2 <= 0;
            s_e <= 0;
            s_y <= 0;
        elsif rising_edge(clk) then
            s_e <= ref - s_y;
            s_u1 <= ref;
            s_u2 <= 0;
            s_y <= s_pre_y1 + dist;
        end if;
    end process;

    plant2ndOrderSS_inst : PlantStateSpace2ndOrder
    port map (
        clk => clk,
        rst => rst,
        u1  => s_u1,
        u2  => s_u2,
        y1  => s_pre_y1,
        y2  => s_pre_y2
    );

    y <= s_y;

end Behavioral;
