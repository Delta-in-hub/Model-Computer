--3. memory address regesiter

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MAR IS
    PORT (
        clk, ia : STD_LOGIC; --active high
        which : IN STD_LOGIC; --0 for D0 , 1 for D1
        D0, D1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END MAR;

ARCHITECTURE rtl OF MAR IS
    COMPONENT Accumulator
        PORT (
            clk : IN STD_LOGIC;
            Ia : IN STD_LOGIC; -- active high
            D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL d, w : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    w <= (OTHERS => (which));
    d <= (D0 AND (NOT w)) OR (D1 AND w);
    U0 : Accumulator PORT MAP(clk, ia, d, Q);
END ARCHITECTURE;