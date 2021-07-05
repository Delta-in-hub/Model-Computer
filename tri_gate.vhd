LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY tri_gate IS
    PORT (
        DIN, EN : IN STD_LOGIC; --avtive low
        DOUT : OUT STD_LOGIC
    );
END tri_gate;

ARCHITECTURE rtl OF tri_gate IS
BEGIN
    PROCESS (DIN, EN)
    BEGIN
        IF (EN = '0') THEN
            DOUT <= DIN;
        ELSE
            DOUT <= 'Z';
        END IF;
    END PROCESS;
END rtl;