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
ARCHITECTURE behave OF clockPulse IS
    SIGNAL tout : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000001";
BEGIN
    T0 <= tout(0);
    T1 <= tout(1);
    T2 <= tout(2);
    T3 <= tout(3);
    T4 <= tout(4);
    T5 <= tout(5);
    T6 <= tout(6);
    T7 <= tout(7);

    PROCESS (clk, clr)
    BEGIN
        IF (clr = '1') THEN
            tout <= "00000001";
        END IF;

        IF rising_edge(clk) AND clr = '0' THEN
            CASE tout IS
                WHEN "00000001" => tout <= "00000010";
                WHEN "00000010" => tout <= "00000100";
                WHEN "00000100" => tout <= "00001000";
                WHEN "00001000" => tout <= "00010000";
                WHEN "00010000" => tout <= "00100000";
                WHEN "00100000" => tout <= "01000000";
                WHEN "01000000" => tout <= "10000000";
                WHEN "10000000" => tout <= "00000001";
                WHEN OTHERS => tout <= "00000001";
            END CASE;
        END IF;

    END IF;
END PROCESS;
END behave;