--6. ALU

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu IS
    PORT (
        --not and or xor shl shr add sub
        opn : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END alu;

ARCHITECTURE rtl OF alu IS

    COMPONENT paralleladder8
        PORT (
            EN : IN STD_LOGIC;
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            C0 : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            C8 : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT subtract
        PORT (
            A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) --   A-B
        );
    END COMPONENT;
    COMPONENT shiftl
        PORT (
            Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT shiftr
        PORT (
            Din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT my74151
        PORT (
            which : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            A0, A1, A2, A3, A4, A5, A6, A7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL c : STD_LOGIC;
    SIGNAL addres, subres, lres, rres, andres, orres, xorres, notres : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    U0 : paralleladder8 PORT MAP('0', A, B, '0', addres, c);
    U1 : subtract PORT MAP(A, B, subres);
    U2 : shiftl PORT MAP(A,lres);
    U3 : shiftr PORT MAP(A,rres);
    U4 : andres <= A AND B;
    U5 : orres <= A OR B;
    U6 : xorres <= A XOR B;
    U7 : notres <= NOT A;
    U8 : my74151 PORT MAP(opn, notres, andres, orres, xorres, lres, rres, addres, subres, S);
END ARCHITECTURE;