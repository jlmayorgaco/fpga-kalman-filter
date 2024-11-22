library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_counter_16bit_tb is
end entity up_counter_16bit_tb;

architecture testbench of up_counter_16bit_tb is
    constant CLK_PERIOD : time := 10 ns;  -- Clock period
    signal clk : std_logic := '0';        -- Clock signal
    signal reset : std_logic := '0';      -- Reset signal
    signal count : std_logic_vector(15 downto 0);  -- Counter output

    -- Instantiate the up counter module
    component up_counter_16bit
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            count  : out std_logic_vector(15 downto 0)
        );
    end component;

begin
    -- Instantiate the up counter
    uut : up_counter_16bit
    port map (
        clk => clk,
        reset => reset,
        count => count
    );

    -- Clock process
    clk_process : process
    begin
        while now < 250 ns loop  -- Run for 100 ns
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus : process
    begin
        reset <= '1';  -- Assert reset
        wait for 20 ns;
        reset <= '0';  -- Deassert reset
        wait for 250 ns;
        wait;
    end process;

end architecture testbench;
