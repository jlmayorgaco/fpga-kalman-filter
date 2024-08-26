library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PID is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        e     : in  integer;
        u     : out integer
    );
end entity PID;

architecture PIDRTL of PID is

    constant MAX_VALUE : integer := 65536;
    constant MIN_VALUE : integer := -65536;

    -- Internal signals for storing the previous output value
    signal s_sat_in : integer := 0;
    signal s_e : integer := 0;
    signal s_de : integer := 0;
    signal s_p, s_i, s_d : integer := 0;
    signal s_int_saturated : std_logic := '0';

    -- Filter coefficients (adjust these based on your desired cutoff frequency)
    constant K_p : integer := 8;
    constant K_p_Div : integer := 1;

    constant K_i : integer := 1;
    constant K_i_Div : integer := 8;

    constant K_d : integer := 128;
    constant K_d_Div : integer := 1;

    component Saturation is
        Port (
            x       : in  integer;
            max_val : in  integer;
            min_val : in  integer;
            y       : out integer
        );
    end component;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset the internal state and output when the reset signal is asserted
            s_e <= 0;
            s_de <= 0;
            s_p <= 0;
            s_i <= 0;
            s_d <= 0;
            s_sat_in <= 0;
            s_int_saturated <= '0';
        elsif rising_edge(clk) then

             -- PID terms
             s_p <= (K_p / K_p_Div) * s_e ;
             s_i <= s_i + (K_i) * (s_e / K_i_Div);
             s_d <= (K_d / K_d_Div) * (s_e - s_de);  -- calculate derivative

             s_de <= s_e;
             s_e <= e;

             -- Update output with saturation (adjust limits as needed)
             s_sat_in <= (s_p + s_i + s_d);

        end if;
    end process;

    saturation_inst : Saturation
    port map (
        max_val => MAX_VALUE,
        min_val => MIN_VALUE,
        x       => s_sat_in,
        y       => u
    );
end PIDRTL;
