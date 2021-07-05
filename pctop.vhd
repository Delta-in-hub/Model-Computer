LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pctop IS
    PORT (
        clk, clr, key : IN STD_LOGIC;
        led1, led2, led3 : OUT STD_LOGIC
    );
END pctop;

ARCHITECTURE rtl OF pctop IS
    COMPONENT programmeCounter
        PORT (
            clk : IN STD_LOGIC;
            clr : IN STD_LOGIC; --active low
            ipc : IN STD_LOGIC; --active high
            Q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL Q : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    U0 : programmeCounter PORT MAP(clk, '1', NOT key, Q);
    led1 <= NOT Q(2);
    led2 <= NOT Q(1);
    led3 <= NOT Q(0);
END ARCHITECTURE;