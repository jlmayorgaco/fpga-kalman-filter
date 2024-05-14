library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity p1_2nd_system_step_response_tb is
end p1_2nd_system_step_response_tb;

architecture testbench of p1_2nd_system_step_response_tb is
    -- Component declaration for the DUT (Design Under Test)
    component p1_2nd_system_step_response
        Port (
            clk   : in  std_logic;   -- Clock input
            rst   : in  std_logic;   -- Reset input
            u     : in  integer;     -- Input integer
            y     : out integer      -- Output scaled integer
        );
    end component;

    -- Test signals
    signal clk_tb   : std_logic := '0';   -- Test bench clock signal
    signal rst_tb   : std_logic := '0';   -- Test bench reset signal
    signal u_tb     : integer := 0;       -- Test bench input signal
    signal y_tb     : integer;            -- Test bench output signal

begin
    -- Instantiate the DUT
    dut : p1_2nd_system_step_response
        port map (
            clk => clk_tb,
            rst => rst_tb,
            u   => u_tb,
            y   => y_tb
        );

    -- Clock process
    clk_process : process
    begin
        while now < 1200 ns loop  -- Run for 1000 ns
            clk_tb <= not clk_tb;  -- Toggle clock every half period
            wait for 5 ns;         -- Wait for half period
        end loop;
        wait;  -- Stop simulation
    end process;

    -- Stimulus process
    stimulus : process
    begin
        rst_tb <= '1';   -- Assert reset
        wait for 10 ns;
        rst_tb <= '0';   -- Deassert reset
        wait for 10 ns;

        -- Test with different input values
        for i in 0 to 10 loop
            u_tb <= i;   -- Apply input value
            wait for 10 ns;
        end loop;

        wait;  -- Stop simulation
    end process;
end testbench;