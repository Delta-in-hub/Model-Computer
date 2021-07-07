LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY my74151 IS
    PORT (
        which : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        A0, A1, A2, A3, A4, A5, A6, A7 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END my74151;

ARCHITECTURE rtl OF my74151 IS

BEGIN

    PROCESS (which, A0, A1, A2, A3, A4, A5, A6, A7)
    BEGIN
        CASE(which) IS
            WHEN "000" =>
            Dout <= A0;
            WHEN "001" =>
            Dout <= A1;
            WHEN "010" =>
            Dout <= A2;
            WHEN "011" =>
            Dout <= A3;
            WHEN "100" =>
            Dout <= A4;
            WHEN "101" =>
            Dout <= A5;
            WHEN "110" =>
            Dout <= A6;
            WHEN "111" =>
            Dout <= A7;
        END CASE;
    END PROCESS;

END ARCHITECTURE;