library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PlantStateSpace2ndOrder is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        u1  : in integer;
        u2  : in integer;
        y1  : out integer;
        y2  : out integer
    );
end PlantStateSpace2ndOrder;

architecture PlantStateSpace2ndOrderRTL of PlantStateSpace2ndOrder is

    constant SCALE_VALUE : integer := 1;

    constant a11 : integer := 10 * SCALE_VALUE;
    constant a12 : integer := 10 * SCALE_VALUE;
    constant a21 : integer := 10 * SCALE_VALUE;
    constant a22 : integer := 10 * SCALE_VALUE;

    constant b11 : integer := 10 * SCALE_VALUE;
    constant b12 : integer := 10 * SCALE_VALUE;
    constant b21 : integer := 10 * SCALE_VALUE;
    constant b22 : integer := 10 * SCALE_VALUE;

    constant c11 : integer := 10 * SCALE_VALUE;
    constant c12 : integer := 10 * SCALE_VALUE;
    constant c21 : integer := 10 * SCALE_VALUE;
    constant c22 : integer := 10 * SCALE_VALUE;

    constant d11 : integer := 10 * SCALE_VALUE;
    constant d12 : integer := 10 * SCALE_VALUE;
    constant d21 : integer := 10 * SCALE_VALUE;
    constant d22 : integer := 10 * SCALE_VALUE;

    component MatrixVectorProduct_2x2 is
        Port (
            clk  : in  std_logic; -- Clock input
            rst  : in  std_logic; -- Reset input
            M11  : in  integer;   -- Input matrix A element (1,1)
            M12  : in  integer;   -- Input matrix A element (1,2)
            M21  : in  integer;   -- Input matrix A element (2,1)
            M22  : in  integer;   -- Input matrix A element (2,2)
            x1   : in  integer;   -- Input vector x element (1)
            x2   : in  integer;   -- Input vector x element (2)
            y1   : out integer;   -- Output vector y element (1)
            y2   : out integer    -- Output vector y element (2)
        );
    end component;

    component VectorSum_2x1 is
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
    end component;

    component Integrator_2x1 is
        Port (
            clk : in std_logic;    -- Clock input
            rst : in std_logic;    -- Reset input
            x1  : in integer;      -- Input vector x element (1)
            x2  : in integer;      -- Input vector x element (2)
            int_x1 : out integer;  -- Output integral of x element (1)
            int_x2 : out integer   -- Output integral of x element (2)
        );
    end component;

    signal s_x1, s_x2 : integer := 0;
    signal s_Ax1, s_Ax2 : integer;
    signal s_Bu1, s_Bu2 : integer;
    signal s_Cx1, s_Cx2 : integer;
    signal s_Du1, s_Du2 : integer;
    signal s_Ax_add_Bu_1, s_Ax_add_Bu_2 : integer;
    signal s_Cx_add_Du_1, s_Cx_add_Du_2 : integer;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            s_x1 <= 0;
            s_x2 <= 0;
        elsif rising_edge(clk) then
            -- State update logic here if needed
        end if;
    end process;

    Ax : MatrixVectorProduct_2x2
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input
        M11  => a11,
        M12  => a12,
        M21  => a21,
        M22  => a22,
        x1   => s_x1,
        x2   => s_x2,
        y1   => s_Ax1,
        y2   => s_Ax2
    );

    Cx : MatrixVectorProduct_2x2
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input
        M11  => c11,
        M12  => c12,
        M21  => c21,
        M22  => c22,
        x1   => s_x1,
        x2   => s_x2,
        y1   => s_Cx1,
        y2   => s_Cx2
    );

    Bu : MatrixVectorProduct_2x2
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input
        M11  => b11,
        M12  => b12,
        M21  => b21,
        M22  => b22,
        x1   => u1,
        x2   => u2,
        y1   => s_Bu1,
        y2   => s_Bu2
    );

    Du : MatrixVectorProduct_2x2
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input
        M11  => d11,
        M12  => d12,
        M21  => d21,
        M22  => d22,
        x1   => u1,
        x2   => u2,
        y1   => s_Du1,
        y2   => s_Du2
    );

    Ax_add_Bu: VectorSum_2x1
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input
        x1   => s_Ax1,
        x2   => s_Ax2,
        y1   => s_Bu1,
        y2   => s_Bu2,
        z1   => s_Ax_add_Bu_1,
        z2   => s_Ax_add_Bu_2
    );

    Cx_add_Du: VectorSum_2x1
    port map (
        clk  => clk, -- Clock input
        rst  => rst, -- Reset input,
        x1   => s_Cx1,
        x2   => s_Cx2,
        y1   => s_Du1,
        y2   => s_Du2,
        z1   => s_Cx_add_Du_1,
        z2   => s_Cx_add_Du_2
    );

    XIntegrator: Integrator_2x1
    port map (
        clk    => clk, -- Clock input
        rst    => rst, -- Reset input
        x1     => s_Ax_add_Bu_1,
        x2     => s_Ax_add_Bu_2,
        int_x1 => s_x1,
        int_x2 => s_x2
    );

    y1 <= s_Cx_add_Du_1;
    y2 <= s_Cx_add_Du_2;

end PlantStateSpace2ndOrderRTL;
