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
            ref     : in  integer;     -- Input integer
            y     : out integer;      -- Output scaled integer
            dist     : in integer      -- Output scaled integer
        );
    end component;

    -- Test signals
    signal clk   : std_logic := '0';   -- Test bench clock signal
    signal rst   : std_logic := '0';   -- Test bench reset signal
    signal ref   : integer := 0;       -- Test bench input signal
    signal y     : integer := 0;             -- Test bench output signal
    signal dist  : integer := 0;             -- Test bench output signal

begin
    -- Instantiate the DUT
    dut : Main
        port map (
            clk => clk,
            rst => rst,
            ref   => ref,
            dist   => dist,
            y   => y
        );

    -- Clock process
    clk_process : process
    begin
        while now < 30000 ns loop  -- Run for 1000 ns
            clk <= not clk;  -- Toggle clock every half period
            wait for 5 ns;         -- Wait for half period
        end loop;
        wait;  -- Stop simulation
    end process;

    -- Stimulus process
    stimulus : process
    begin
        ref <= 0;
        dist <= 0;
        rst <= '1';   -- Assert reset

        wait for 10 ns;
        ref <= 0;
        dist <= 0;
        rst <= '0';   -- Deassert reset

        wait for 10 ns;  -- u(t) = 0
        ref <= 0;
        dist <= 0;

        wait for 10 ns;   -- u(t) = 1
        ref <= 512;
        dist <= 0;

        wait for 1024 ns;   -- u(t) = 1
        ref <= 500;
        dist <= 100;

        wait for 1024 ns;   -- u(t) = 1
        ref <= 500;
        dist <= 0;

        wait for 1024 ns;   -- u(t) = 1
        ref <= 500;
        dist <= 0;

        wait for 1024 ns;   -- u(t) = 1
        ref <= 500;
        dist <= 0;

        wait;  -- Stop simulation
    end process;
end testbench;