LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY subtract IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) --   A-B
    );
END subtract;

ARCHITECTURE rtl OF subtract IS
    COMPONENT paralleladder8
        PORT (
            EN : IN STD_LOGIC;
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            C0 : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            C8 : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL c : STD_LOGIC;
    SIGNAL mb : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    U0 : paralleladder8 PORT MAP('0', NOT B, "00000001", '0', mb, c);
    U1 : paralleladder8 PORT MAP('0', A, mb, '0', Dout, c);
END ARCHITECTURE;