LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY shiftl IS
    PORT (
        Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END shiftl;

ARCHITECTURE rtl OF shiftl IS

BEGIN
    Dout(7 DOWNTO 1) <= Din (6 DOWNTO 0);
    Dout(0) <= '0';
END ARCHITECTURE;