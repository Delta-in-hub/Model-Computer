----numtoled
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


--为了在LED上直接显示十进制数字 0-9999
ENTITY numtoled IS
    PORT (
        clk : IN STD_LOGIC;
        yournum : IN INTEGER RANGE 0 TO 1e4 := 0000;
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1)
    );
END ENTITY numtoled;

ARCHITECTURE rtl OF numtoled IS
    COMPONENT led
        PORT (
            clk : IN STD_LOGIC;
            num1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";  --个位上的数,也就是最右边的数,以二进制形式输入
            num2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
            num3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
            num4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";  --千位上的数,也就是最左边的数
            seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1)
        );
    END COMPONENT;

    SIGNAL num1, num2, num3, num4 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
    U1 : led PORT MAP(clk, num1, num2, num3, num4, seg, dig);
    num1 <= STD_LOGIC_VECTOR(to_unsigned(yournum MOD 10, num1'length));
    num2 <= STD_LOGIC_VECTOR(to_unsigned((yournum / 10) MOD 10, num2'length));
    num3 <= STD_LOGIC_VECTOR(to_unsigned((yournum / 100) MOD 10, num3'length));
    num4 <= STD_LOGIC_VECTOR(to_unsigned((yournum / 1000) MOD 10, num4'length));

END ARCHITECTURE rtl;