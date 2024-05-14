library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Main is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        u     : in  integer;
        y     : out integer
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

    constant K : integer := 1 * SCALE_VALUE;

    constant b2 : integer := 1 * SCALE_VALUE;
    constant b1 : integer := 2 * SCALE_VALUE;
    constant b0 : integer := 10 * SCALE_VALUE;

    constant a0 : integer := 10 * SCALE_VALUE;

    component Saturation is
        Port (
            x       : in  integer;
            max_val : in  integer;
            min_val : in  integer;
            y       : out integer
        );
    end component;


    component Noise is
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            x     : in  integer;
            y     : out integer
        );
    end component;

    signal s_sat_in : integer;
    signal s_sat_out : integer;
    signal s_sat_noise_out : integer;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_y <= 0;
            s_dy <= 0;
            s_ddy <= 0;
            s_sat_in <= 0;
        elsif rising_edge(clk) then
            s_ddy <= (u) * (a0 / b2) - s_dy * (b1 / b2) - s_y * (b0 / b2);
            s_dy  <= s_dy + s_ddy / SCALE_DT;
            s_y   <= s_y + s_dy / SCALE_DT;

            s_sat_in <= s_y;
        end if;
    end process;

    saturation_inst : Saturation
    port map (
        max_val => MAX_VALUE,
        min_val => MIN_VALUE,
        x       => s_sat_in,
        y       => s_sat_out
    );

    noise_inst : Noise
    port map (
        clk => clk,
        rst => rst,
        x => s_sat_out,
        y => s_sat_noise_out
    );

    y <= s_sat_noise_out;

end Behavioral;

