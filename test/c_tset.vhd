LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ptest IS
END ptest;

ARCHITECTURE rtl OF ptest IS

    COMPONENT clockPulse
        PORT (
            CLK, CLR : IN STD_LOGIC; --输入的时钟信号和CLR复位信号 active high
            T0, T1, T2, T3, T4, T5, T6, T7 : OUT STD_LOGIC --输出的T0-T7节拍信号
        );
    END COMPONENT;

    COMPONENT programmeCounter
        PORT (
            clk : IN STD_LOGIC;
            clr : IN STD_LOGIC; --active high
            ipc : IN STD_LOGIC; --active high
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL CLK, CLR, T0, T1, T2, T3, T4, T5, T6, T7 : STD_LOGIC := '0';
    SIGNAL ipc : STD_LOGIC;
    SIGNAL Q : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    U0 : clockPulse PORT MAP(CLK, CLR, T0, T1, T2, T3, T4, T5, T6, T7);
    U1 : programmeCounter PORT MAP(clk, '0', ipc, Q);
    PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR 20 ns;
        clk <= '0';
        WAIT FOR 20 ns;
    END PROCESS;
    PROCESS
    BEGIN
        ipc <= '1';
        WAIT FOR 41 ns;
        ipc <= '0';
        WAIT FOR 41 ns;
    END PROCESS;
    PROCESS
    BEGIN
        clr <= '0';
        WAIT FOR 1003 ns;
        clr <= '1';
        WAIT FOR 1003 ns;
    END PROCESS;
END ARCHITECTURE;