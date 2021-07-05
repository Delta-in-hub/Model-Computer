--10. clock source
--en is 1 , clkout <= 0 ; else clkout <= clk50M
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY clockSource IS
    PORT (
        clk_50M : IN STD_LOGIC;
        en : IN STD_LOGIC; --Active high
        clkout : OUT STD_LOGIC
    );
END clockSource;

ARCHITECTURE rtl OF clockSource IS
    SIGNAL clko : STD_LOGIC;
BEGIN
    PROCESS (clk_50M)
        VARIABLE cnt : INTEGER := 0;
        VARIABLE max : INTEGER := 0; -- 5e7 / (1 + max)  hz
    BEGIN
        IF cnt >= max THEN
            clko <= NOT clko;
            cnt <= 0;
        ELSE
            cnt <= cnt + 1;
        END IF;
    END PROCESS;
    clkout <= (en) AND clko;
END ARCHITECTURE;