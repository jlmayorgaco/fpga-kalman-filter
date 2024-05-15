library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Main is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        ref     : in  integer;
        dist    : in  integer;
        y       : out integer;
    );
end Main;

architecture Behavioral of Main is

    signal s_y : integer := 0;
    signal s_dy : integer := 0;
    signal s_ddy : integer := 0;

    constant SCALE_VALUE : integer := 8192;
    constant SCALE_DT : integer := 100;

    constant MAX_VALUE : integer := 65536;
    constant MIN_VALUE : integer := -65536;

    component Plant2ndOrder is
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            u       : in  integer;
            y       : out integer
        );
    end component;


    component PID is
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            e     : in  integer;
            u     : out integer
        );
    end component;

    signal s_pre_y : integer;
    signal s_y : integer;
    signal s_u : integer;
    signal s_e : integer;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_e <= 0;
            s_y <= 0;
        elsif rising_edge(clk) then
            s_e <= ref - s_y ;
            s_y <= s_pre_y + dist;
        end if;
    end process;

    plant2ndOrder_inst : Plant2ndOrder
    port map (
        clk => clk,
        rst => rst,
        u => s_u,
        y => s_pre_y
    );

    pid_inst : PID
    port map (
        clk => clk,
        rst => rst,
        e => s_e,
        u => s_u
    );

    y <= s_y;

end Behavioral;

