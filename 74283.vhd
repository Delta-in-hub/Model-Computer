--带低有效控制端的4位并行进位加法器
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY adder_74283 IS
    GENERIC (del1, del2, del3, del4 : TIME := 0ns );
    PORT (
        EN : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        C0 : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        C4 : OUT STD_LOGIC
    );
END adder_74283;

ARCHITECTURE adder_74283p OF adder_74283 IS
    SIGNAL G, P : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 1);
BEGIN

    P(0) <= (NOT EN) AND (A(0) XOR B(0)) AFTER del1;
    P(1) <= (NOT EN) AND (A(1) XOR B(1)) AFTER del1;
    P(2) <= (NOT EN) AND (A(2) XOR B(2)) AFTER del1;
    P(3) <= (NOT EN) AND (A(3) XOR B(3)) AFTER del1;

    G(0) <= (NOT EN) AND (A(0) AND B(0)) AFTER del2;
    G(1) <= (NOT EN) AND (A(1) AND B(1)) AFTER del2;
    G(2) <= (NOT EN) AND (A(2) AND B(2)) AFTER del2;
    G(3) <= (NOT EN) AND (A(3) AND B(3)) AFTER del2;

    C(1) <= (NOT EN) AND (G(0) OR (P(0) AND C0)) AFTER del3;
    C(2) <= (NOT EN) AND (G(1) OR (P(1) AND G(0)) OR (P(1) AND P(0) AND C0)) AFTER del3;
    C(3) <= (NOT EN) AND (G(2) OR (P(2) AND G(1)) OR (P(2) AND P(1) AND G(0)) OR (P(2) AND P(1) AND P(0) AND C0)) AFTER del3;
    C4 <= (NOT EN) AND (G(3) OR (P(3) AND G(2)) OR (P(3) AND P(2) AND G(1)) OR (P(3) AND P(2) AND P(1) AND G(0)) OR (P(3) AND P(2) AND P(1) AND P(0) AND C0)) AFTER del3;

    S(0) <= (NOT EN) AND (A(0) XOR B(0) XOR C0) AFTER del4;
    S(1) <= (NOT EN) AND (A(1) XOR B(1) XOR C(1)) AFTER del4;
    S(2) <= (NOT EN) AND (A(2) XOR B(2) XOR C(2)) AFTER del4;
    S(3) <= (NOT EN) AND (A(3) XOR B(3) XOR C(3)) AFTER del4;

END ARCHITECTURE adder_74283p;