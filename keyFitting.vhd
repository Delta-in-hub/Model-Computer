LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY keyFitting IS
    PORT (
        clk : IN STD_LOGIC;
        key : IN STD_LOGIC;
        status : OUT STD_LOGIC
    );
END keyFitting;

ARCHITECTURE arch OF keyFitting IS
    SIGNAL s : STD_LOGIC := '1';
BEGIN
    status <= s;
    PROCESS (clk)
        VARIABLE keycnt : INTEGER := 0;
    BEGIN
        IF rising_edge(clk) THEN
            IF key = '0' THEN
                keycnt := keycnt + 1;
            ELSE
                keycnt := 0;
            END IF;

            IF keycnt > 5e6 THEN
                keycnt := 0;
                s <= '0';
            ELSE
                s <= '1';
            END IF;
        END IF;
    END PROCESS; --

END ARCHITECTURE; -- arch