library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SecondOrderSystem_tb is
end entity SecondOrderSystem_tb;

architecture testbench of SecondOrderSystem_tb is
    constant clk_period : time := 10 ns; -- Clock period
    constant sim_time : time := 2000 ns; -- Simulation time

    signal clk : std_logic := '0'; -- Clock signal
    signal reset : std_logic := '1'; -- Reset signal
    signal uk : signed(31 downto 0) := (others => '0'); -- Input signal
    signal yk : signed(63 downto 0); -- Output signal

    -- Instantiate the up counter module
    component SecondOrderSystem
        port (
            clk : in std_logic;
            reset : in std_logic;
            uk : in signed(31 downto 0); -- Input signal (16-bit signed integer)
            yk : out signed(63 downto 0) -- Output signal (16-bit signed integer)
        );
    end component;

begin
    -- Instantiate the DUT
    uut : SecondOrderSystem
    port map (
        clk => clk,
        reset => reset,
        uk => uk,
        yk => yk
    );

    -- Clock process
    clk_process : process
    begin
        while now < sim_time loop
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus : process
    begin
        -- Reset
        reset <= '1';
        wait for 100 ns;
        reset <= '0';

        -- Step input from 0 to 1
        uk <= (others => '0');
        wait for 1000 ns; -- Wait for initial transient
        uk <= to_signed(1, uk'length); -- Set input to 1

        -- Continue simulation for stability
        wait for 1000 ns;
        wait;

    end process;

end architecture testbench;
