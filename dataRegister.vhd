--4. data regesiter
-- 8 bits regesiter with output control(trigate)
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY dataRegsiter IS
    PORT (
        clk : IN STD_LOGIC;
        Idr, Odr : IN STD_LOGIC; --active high
        D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END dataRegsiter;

ARCHITECTURE rtl OF dataRegsiter IS
    SIGNAL t : STD_LOGIC_VECTOR(7 DOWNTO 0);
    COMPONENT D_flip_flop
        PORT (
            clk, Din, reset, set, en : IN STD_LOGIC; --active low
            Q : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT tri_gate
        PORT (
            DIN, EN : IN STD_LOGIC; --avtive low
            DOUT : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL Ien, Oen : STD_LOGIC;
BEGIN
    Ien <= NOT Idr;
    Oen <= NOT Odr;
    U0 : D_flip_flop PORT MAP(clk, D(0), '1', '1', Ien, t(0));
    U1 : D_flip_flop PORT MAP(clk, D(1), '1', '1', Ien, t(1));
    U2 : D_flip_flop PORT MAP(clk, D(2), '1', '1', Ien, t(2));
    U3 : D_flip_flop PORT MAP(clk, D(3), '1', '1', Ien, t(3));
    U4 : D_flip_flop PORT MAP(clk, D(4), '1', '1', Ien, t(4));
    U5 : D_flip_flop PORT MAP(clk, D(5), '1', '1', Ien, t(5));
    U6 : D_flip_flop PORT MAP(clk, D(6), '1', '1', Ien, t(6));
    U7 : D_flip_flop PORT MAP(clk, D(7), '1', '1', Ien, t(7));

    O0 : tri_gate PORT MAP(t(0), Oen, Q(0));
    O1 : tri_gate PORT MAP(t(1), Oen, Q(1));
    O2 : tri_gate PORT MAP(t(2), Oen, Q(2));
    O3 : tri_gate PORT MAP(t(3), Oen, Q(3));
    O4 : tri_gate PORT MAP(t(4), Oen, Q(4));
    O5 : tri_gate PORT MAP(t(5), Oen, Q(5));
    O6 : tri_gate PORT MAP(t(6), Oen, Q(6));
    O7 : tri_gate PORT MAP(t(7), Oen, Q(7));
END ARCHITECTURE;