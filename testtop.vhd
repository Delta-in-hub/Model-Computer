LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testtop IS
    PORT (
        clk : IN STD_LOGIC; --时钟信号
        p, addr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        aluop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr : OUT STD_LOGIC --输出的指令信号
    );
END testtop;

ARCHITECTURE rtl OF testtop IS

    COMPONENT CTRL
        PORT (
            T0, T1, T2, T3, T4, T5, T6, T7 : IN STD_LOGIC;
            key1, key2, key3, key4, txdone, rxdone : IN STD_LOGIC;
            instruction : STD_LOGIC_VECTOR(7 DOWNTO 0);
            clk : IN STD_LOGIC; --时钟信号
            aluop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr : OUT STD_LOGIC --输出的指令信号
        );
    END COMPONENT;
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

    SIGNAL T0, T1, T2, T3, T4, T5, T6, T7 : STD_LOGIC := '1';
    SIGNAL instruction : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111010";
    SIGNAL key1, key2, key3, key4, cpclr1 : STD_LOGIC := '1';
    SIGNAL txdone, rxdone, pcClear1, pcCount1 : STD_LOGIC := '0';
BEGIN
    key4 <= '0';

    U0 : CTRL PORT MAP(T0, T1, T2, T3, T4, T5, T6, T7, key1, key2, key3, key4, txdone, rxdone, instruction, clk, aluop, memReset, memReadWrite, marin, whichAddr, pcClear1, pcCount1, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr1);
    U1 : clockPulse PORT MAP(clk, cpclr1, T0, T1, T2, T3, T4, T5, T6, T7);
    cpclr <= cpclr1;
    p <= (T0, T1, T2, T3, T4, T5, T6, T7);
    U2 : programmeCounter PORT MAP(clk, pcClear1, pcCount1, addr);
    pcClear <= pcClear1;
    pcCount <= pcCount1;
END ARCHITECTURE;