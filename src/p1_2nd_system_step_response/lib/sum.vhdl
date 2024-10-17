entity sum is
    port (
        a, b : in  integer;
        c    : out integer
    );
end entity sum;

architecture Behavioral of sum is
begin
    c <= a + b;
end architecture Behavioral;