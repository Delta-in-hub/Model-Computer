--2. programme Counter
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY programmeCounter IS
    PORT (
        clk : IN STD_LOGIC;
        clr : IN STD_LOGIC; --active high
        ipc : IN STD_LOGIC; --active high
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END programmeCounter;

ARCHITECTURE rtl OF programmeCounter IS

    -- COMPONENT ic74161
    --     PORT (
    --         CLR : IN STD_LOGIC; --Active Low
    --         CLK : IN STD_LOGIC;
    --         A, B, C, D : IN STD_LOGIC;
    --         QA, QB, QC, QD : OUT STD_LOGIC;
    --         ENP : IN STD_LOGIC;
    --         ENT : IN STD_LOGIC;
    --         LOAD : IN STD_LOGIC; --Active Low
    --         RCO : OUT STD_LOGIC
    --     );
    -- END COMPONENT;

    SIGNAL t, t2 : STD_LOGIC;
    SIGNAL v : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
BEGIN
    -- U1 : ic74161 PORT MAP('1', clk, '0', '0', '0', '0', Q(3), Q(2), Q(1), Q(0), ipc, ipc, NOT clr, t);
    -- U2 : ic74161 PORT MAP('1', t, '0', '0', '0', '0', Q(7), Q(6), Q(5), Q(4), '1', '1', NOT clr, t2);
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (clr = '1') THEN
                v <= "00000000";
            ELSIF ipc = '1' THEN
                v <= v + '1';
            END IF;
        END IF;
    END PROCESS;
    Q <= v;
END ARCHITECTURE;