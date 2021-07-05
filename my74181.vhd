LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY my74181 IS PORT (
    A, B, S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Ci, M : IN STD_LOGIC;
    F : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    CP, CG, AeqB, Co : OUT STD_LOGIC);
END my74181;
ARCHITECTURE arch OF my74181 IS
    SIGNAL wa, wb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s3, s2, s1, s0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cgs : STD_LOGIC;
    SIGNAL fo : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    s3 <= (OTHERS => s(3));
    s2 <= (OTHERS => s(2));
    s1 <= (OTHERS => s(1));
    s0 <= (OTHERS => s(0));
    wa <= NOT((B AND s3 AND A) OR (A AND s2 AND NOT B));
    wb <= NOT((NOT B AND s1) OR (s0 AND B) OR A);
    CG <= cgs;
    cgs <= NOT (wb(3) OR (wa (3) AND wb (2)) OR (wa (3) AND wa (2) AND wb (1)) OR (wa (3) AND wa (2) AND wa (1) AND wb (0)));
    co <= NOT cgs OR NOT (NOT (wa (3) AND wa (2) AND wa (1) AND wa (0) AND ci));
    CP <= NOT (wa (3) AND wa (2) AND wa (1) AND wa (0));
    fo(3) <= (wa (3) XOR wb (3)) XOR NOT ((ci AND wa (0) AND wa (1) AND wa (2) AND M) OR (wa (1) AND wa (2) AND wb (0) AND M) OR (wa (2) AND wb (1) AND M) OR (wb (2) AND M));
    F(3) <= fo(3);

    fo(2) <= (wa (2) XOR wb (2)) XOR NOT ((Ci AND wa (0) AND wa (1) AND M) OR (wa (1) AND wa (0) AND M) OR (wb (1) AND M));
    F(2) <= fo(2);

    AeqB <= fo (3) AND fo (2) AND fo (1) AND fo (0);
    fo(1) <= (wa (1) XOR wb (0)) XOR NOT ((Ci AND wa (0) AND M) OR (wb (0) AND M));
    F(1) <= fo(1);
    fo(0) <= (wa (0) XOR wb (0)) XOR NOT (Ci AND M);
    F(0) <= fo(0);
END ARCHITECTURE;