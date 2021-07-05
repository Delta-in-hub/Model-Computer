------------------------------------------------
--IC 74161 Implementation
-----------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ic74161 IS
    PORT (
        CLR : IN STD_LOGIC; --Active Low
        CLK : IN STD_LOGIC;
        A, B, C, D : IN STD_LOGIC;
        QA, QB, QC, QD : OUT STD_LOGIC;
        ENP : IN STD_LOGIC;
        ENT : IN STD_LOGIC;
        LOAD : IN STD_LOGIC; --Active Low
        RCO : OUT STD_LOGIC
    );
END ic74161;

ARCHITECTURE Behavioral OF ic74161 IS

    SIGNAL output : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    logic : PROCESS (CLK, CLR, ENP, ENT, LOAD)
    BEGIN
        IF (CLR = '0') THEN
            output <= "0000";

        ELSIF (rising_edge(CLK)) THEN
            IF (LOAD = '0') THEN --**start from here
                output(3) <= A;
                output(2) <= B;
                output(1) <= C;
                output(0) <= D;
            ELSE
                IF (ENP = '1' AND ENT = '1') THEN
                    output <= output + 1;
                ELSE
                    output <= output;
                END IF;
            END IF;
        END IF;
    END PROCESS logic;
    QA <= output(3);
    QB <= output(2);
    QC <= output(1);
    QD <= output(0);

    RippleCarryOut : PROCESS (output, ENT)
    BEGIN
        IF (output = B"1111" AND ENT = '1') THEN
            RCO <= '1';
        ELSE
            RCO <= '0';
        END IF;
    END PROCESS RippleCarryOut;
END Behavioral;