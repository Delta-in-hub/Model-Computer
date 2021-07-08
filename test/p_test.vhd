LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ptest IS
END ptest;

ARCHITECTURE rtl OF ptest IS

    COMPONENT testtop
        PORT (
            clk : IN STD_LOGIC; --时钟信号
            p, addr : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            aluop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr : OUT STD_LOGIC --输出的指令信号
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL aluop : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
    SIGNAL memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4 : STD_LOGIC := '0';
    SIGNAL p, addr : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL cpclr : STD_LOGIC := '0';
BEGIN
    U0 : testtop PORT MAP(clk, p, addr, aluop, memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr);

    PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR 20 ns;
        clk <= '0';
        WAIT FOR 20 ns;
    END PROCESS;
END ARCHITECTURE;