library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VectorSum_2x1 is
    Port (
        clk : in std_logic;   -- Clock input
        rst : in std_logic;   -- Reset input
        x1  : in integer;     -- Input vector x element (1)
        x2  : in integer;     -- Input vector x element (2)
        y1  : in integer;     -- Input vector y element (1)
        y2  : in integer;     -- Input vector y element (2)
        z1  : out integer;    -- Output vector z element (1)
        z2  : out integer     -- Output vector z element (2)
    );
end entity VectorSum_2x1;

architecture Behavioral_VectorSum_2x1 of VectorSum_2x1 is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            z1 <= 0;
            z2 <= 0;
        elsif rising_edge(clk) then
            -- Perform vector addition
            z1 <= x1 + y1;
            z2 <= x2 + y2;
        end if;
    end process;
end Behavioral_VectorSum_2x1;
