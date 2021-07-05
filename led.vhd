----led
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY led IS
    PORT (
        clk : IN STD_LOGIC;
        num1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        num2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        num3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        num4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1)
    );
END ENTITY led;

ARCHITECTURE rtl OF led IS
    COMPONENT hex_to_7_seg
        PORT (
            seven_seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

    SIGNAL myclk : STD_LOGIC := '0';
    SIGNAL cnt : INTEGER := 0;
    SIGNAL id : INTEGER RANGE 1 TO 4 := 1;

    SIGNAL out1, out2, out3, out4 : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN
    U1 : hex_to_7_seg PORT MAP(out1, num1);
    U2 : hex_to_7_seg PORT MAP(out2, num2);
    U3 : hex_to_7_seg PORT MAP(out3, num3);
    U4 : hex_to_7_seg PORT MAP(out4, num4);

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            cnt <= cnt + 1;
            IF cnt >= 5e4 THEN
                myclk <= NOT myclk; --创造一个1Khz的时钟 = 1ms
                cnt <= 0;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (myclk)
    BEGIN
        IF rising_edge(myclk) THEN --1ms LED刷新一个数,就是只亮一个数字,其余三个数字都不亮.
            dig <= "1111";
            dig(id) <= '0';
            CASE id IS --这四个数循环的亮,因为视觉暂留
                WHEN 1 =>
                    seg <= out1;
                WHEN 2 =>
                    seg <= out2;
                WHEN 3 =>
                    seg <= out3;
                WHEN 4 =>
                    seg <= out4;
            END CASE;
            id <= id + 1;
            IF id > 4 THEN
                id <= 1;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE rtl;