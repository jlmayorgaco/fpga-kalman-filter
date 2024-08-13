library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Main_tb is
end Main_tb;

architecture testbench of Main_tb is
    -- Component declaration for the DUT (Design Under Test)
    component Main
        Port (
            clk   : in  std_logic;   -- Clock input
            rst   : in  std_logic;   -- Reset input
            ref   : in  integer;     -- Reference input
            dist  : in  integer;     -- Disturbance input
            y     : out integer      -- Output signal
        );
    end component;

    -- Test signals
    signal clk_tb   : std_logic := '0';   -- Test bench clock signal
    signal rst_tb   : std_logic := '0';   -- Test bench reset signal
    signal ref_tb   : integer := 0;       -- Test bench reference input signal
    signal dist_tb  : integer := 0;       -- Test bench disturbance input signal
    signal y_tb     : integer := 0;       -- Test bench output signal

begin
    -- Instantiate the DUT
    dut : Main
        port map (
            clk  => clk_tb,
            rst  => rst_tb,
            ref  => ref_tb,
            dist => dist_tb,
            y    => y_tb
        );

    -- Clock process
    clk_process : process
    begin
        while now < 30000 ns loop  -- Run for 30000 ns
            clk_tb <= not clk_tb;  -- Toggle clock every half period
            wait for 5 ns;         -- Wait for half period (10 ns period)
        end loop;
        wait;  -- Stop simulation
    end process;

    -- Stimulus process
    stimulus : process
    begin
        -- Initial conditions
        ref_tb <= 0;
        dist_tb <= 0;
        rst_tb <= '1';   -- Assert reset

        wait for 20 ns;
        rst_tb <= '0';   -- Deassert reset

        -- Test different reference values with zero disturbance
        wait for 20 ns;
        ref_tb <= 0;
        dist_tb <= 0;

        wait for 4000 ns;
        ref_tb <= 8192;
        dist_tb <= 0;

        wait for 8000 ns;
        ref_tb <= 8192;
        dist_tb <= 0;

        wait for 8000 ns;
        ref_tb <= 8192;
        dist_tb <= 0;

        wait;  -- Stop simulation
    end process;
end testbench;
