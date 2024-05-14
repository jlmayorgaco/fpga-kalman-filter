entity Multiply is
    port (
        x : in  integer;
        y : in  integer; -- constant integer to scale by
        z : out integer
    );
end entity scale;

architecture Behavioral of Multiply is
begin
    z <= x * y; -- Multiply x by the constant y
end architecture Behavioral;
