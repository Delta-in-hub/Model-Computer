--8 bits tri gate

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY etrigate IS
    PORT (
        e : IN STD_LOGIC; --avtive high
        DIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END etrigate;

ARCHITECTURE rtl OF etrigate IS
    COMPONENT tri_gate
        PORT (
            DIN, EN : IN STD_LOGIC; --avtive low
            DOUT : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL en : STD_LOGIC;
BEGIN
    en <= NOT e;
    U0 : tri_gate PORT MAP(DIN(0), en, DOUT(0));
    U1 : tri_gate PORT MAP(DIN(1), en, DOUT(1));
    U2 : tri_gate PORT MAP(DIN(2), en, DOUT(2));
    U3 : tri_gate PORT MAP(DIN(3), en, DOUT(3));
    U4 : tri_gate PORT MAP(DIN(4), en, DOUT(4));
    U5 : tri_gate PORT MAP(DIN(5), en, DOUT(5));
    U6 : tri_gate PORT MAP(DIN(6), en, DOUT(6));
    U7 : tri_gate PORT MAP(DIN(7), en, DOUT(7));

END ARCHITECTURE;