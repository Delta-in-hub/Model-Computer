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
    SIGNAL CLK, T0, T1, T2, T3, T4, T5, T6, T7 : STD_LOGIC := '0';

BEGIN
    U0 : clockPulse PORT MAP(CLK, '0', T0, T1, T2, T3, T4, T5, T6, T7);
    PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR 20 ns;
        clk <= '0';
        WAIT FOR 20 ns;
    END PROCESS;
END ARCHITECTURE;