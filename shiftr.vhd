LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY shiftr IS
    PORT (
        Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END shiftr;

ARCHITECTURE rtl OF shiftr IS

BEGIN
    Dout(6 DOWNTO 0) <= Din (7 DOWNTO 1);
    Dout(7) <= '0';
END ARCHITECTURE;