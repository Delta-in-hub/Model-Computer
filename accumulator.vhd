--5. Accumulator
-- 8 bits regesiter
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Accumulator IS
    PORT (
        clk : IN STD_LOGIC;
        Ia : IN STD_LOGIC; -- active high
        D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END Accumulator;

ARCHITECTURE rtl OF Accumulator IS
    COMPONENT D_flip_flop
        PORT (
            clk, Din, reset, set, en : IN STD_LOGIC; --active low
            Q : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL notIa : STD_LOGIC;
BEGIN
    notIa <= NOT Ia;
    U0 : D_flip_flop PORT MAP(clk, D(0), '1', '1', notIa, Q(0));
    U1 : D_flip_flop PORT MAP(clk, D(1), '1', '1', notIa, Q(1));
    U2 : D_flip_flop PORT MAP(clk, D(2), '1', '1', notIa, Q(2));
    U3 : D_flip_flop PORT MAP(clk, D(3), '1', '1', notIa, Q(3));
    U4 : D_flip_flop PORT MAP(clk, D(4), '1', '1', notIa, Q(4));
    U5 : D_flip_flop PORT MAP(clk, D(5), '1', '1', notIa, Q(5));
    U6 : D_flip_flop PORT MAP(clk, D(6), '1', '1', notIa, Q(6));
    U7 : D_flip_flop PORT MAP(clk, D(7), '1', '1', notIa, Q(7));
END ARCHITECTURE;