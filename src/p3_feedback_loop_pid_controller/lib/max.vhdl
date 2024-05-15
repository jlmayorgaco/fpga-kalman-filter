entity Maximum is
    port (
        a, b : in  integer;
        max_val : out integer
    );
end entity Maximum;

architecture Behavioral of Maximum is
begin
    process(a, b)
    begin
        if a >= b then
            max_val <= a;
        else
            max_val <= b;
        end if;
    end process;
end architecture Behavioral;