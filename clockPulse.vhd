--9. clock pulse generator
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--节拍发生器模块
--产生T0-T7 八个节拍信号

ENTITY clockPulse IS
    PORT (
        CLK, CLR : IN STD_LOGIC; --输入的时钟信号和CLR复位信号 active high
        T0, T1, T2, T3, T4, T5, T6, T7 : OUT STD_LOGIC --输出的T0-T7节拍信号
    );
END clockPulse;

ARCHITECTURE A OF clockPulse IS
    SIGNAL TEMP : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000001";
BEGIN --T0-T7赋值
    T0 <= TEMP(0);
    T1 <= TEMP(1);
    T2 <= TEMP(2);
    T3 <= TEMP(3);
    T4 <= TEMP(4);
    T5 <= TEMP(5);
    T6 <= TEMP(6);
    T7 <= TEMP(7);

    PROCESS (CLK, CLR)
    BEGIN
        IF (CLR = '1') THEN --CLR=1时复位,T0=1
            TEMP(0) <= '1';
            TEMP(1) <= '0';
            TEMP(2) <= '0';
            TEMP(3) <= '0';
            TEMP(4) <= '0';
            TEMP(5) <= '0';
            TEMP(6) <= '0';
            TEMP(7) <= '0';
        ELSIF (CLK'EVENT AND CLK = '1') THEN --时钟信号上升沿到来时
            TEMP(0) <= TEMP(7); --T0-T7信号循环右移
            TEMP(1) <= TEMP(0);
            TEMP(2) <= TEMP(1);
            TEMP(3) <= TEMP(2);
            TEMP(4) <= TEMP(3);
            TEMP(5) <= TEMP(4);
            TEMP(6) <= TEMP(5);
            TEMP(7) <= TEMP(6);
        END IF;
    END PROCESS;
END A;