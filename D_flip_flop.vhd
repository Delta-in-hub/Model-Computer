LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY D_flip_flop IS
    PORT (
        clk, Din, reset, set, en : IN STD_LOGIC; --active low
        Q : OUT STD_LOGIC
    );
END D_flip_flop;

ARCHITECTURE DFF_arch OF D_flip_flop IS
BEGIN
    PROCESS (clk, en, Din, reset, set)
    BEGIN
        IF (en = '0') THEN
            IF (reset = '0') THEN
                Q <= '0';
            ELSIF (set = '0') THEN
                Q <= '1';
            ELSIF (clk'event AND clk = '1') THEN
                Q <= Din;
            END IF;
        END IF;
    END PROCESS;
END DFF_arch;