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
            u     : in  integer;     -- Input integer
            y     : out integer      -- Output scaled integer
        );
    end component;

    -- Test signals
    signal clk   : std_logic := '0';   -- Test bench clock signal
    signal rst   : std_logic := '0';   -- Test bench reset signal
    signal u     : integer := 0;       -- Test bench input signal
    signal y     : integer;            -- Test bench output signal

begin
    -- Instantiate the DUT
    dut : Main
        port map (
            clk => clk,
            rst => rst,
            u   => u,
            y   => y
        );

    -- Clock process
    clk_process : process
    begin
        while now < 620 ns loop  -- Run for 1000 ns
            clk <= not clk;  -- Toggle clock every half period
            wait for 5 ns;         -- Wait for half period
        end loop;
        wait;  -- Stop simulation
    end process;

    -- Stimulus process
    stimulus : process
    begin
        u <= 0;
        rst <= '1';   -- Assert reset

        wait for 10 ns;
        u <= 0;
        rst <= '0';   -- Deassert reset

        wait for 10 ns;   -- u(t) = 1
        u <= 8192;

        wait;  -- Stop simulation
    end process;
end testbench;