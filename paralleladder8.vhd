--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY paralleladder8 IS
    PORT (
        EN : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        C0 : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        C8 : OUT STD_LOGIC
    );
END paralleladder8;

ARCHITECTURE main OF paralleladder8 IS

    COMPONENT adder_74283
        PORT (
            EN : IN STD_LOGIC;
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            C0 : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            C4 : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL C4 : STD_LOGIC;
BEGIN
    U1 : adder_74283 PORT MAP(EN, A(3 DOWNTO 0), B(3 DOWNTO 0), C0, S(3 DOWNTO 0), C4);
    U2 : adder_74283 PORT MAP(EN, A(7 DOWNTO 4), B(7 DOWNTO 4), C4, S(7 DOWNTO 4), C8);
END ARCHITECTURE main;