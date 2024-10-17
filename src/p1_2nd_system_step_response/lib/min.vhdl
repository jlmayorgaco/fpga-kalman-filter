entity Minimum is
    port (
        a, b : in  integer;
        min_val : out integer
    );
end entity Minimum;

architecture Behavioral of Minimum is
begin
    process(a, b)
    begin
        if a <= b then
            min_val <= a;
        else
            min_val <= b;
        end if;
    end process;
end architecture Behavioral;