--1. memory
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY RAM IS
    GENERIC (
        nadd : NATURAL := 8; --address bus width
        n : NATURAL := 8; --element size
        size : NATURAL := 256 -- size * n Bytes RAM
    );
    PORT (
        addr : IN STD_LOGIC_VECTOR(nadd - 1 DOWNTO 0);
        dout : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        en : IN STD_LOGIC; --active high
        clk, rst : IN STD_LOGIC; --active high
        rw : IN STD_LOGIC -- 0 read / 1 write
    );
END RAM;

ARCHITECTURE beh OF RAM IS
    TYPE mem IS ARRAY (0 TO size - 1) OF STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    SIGNAL content : mem;
BEGIN

    writep : PROCESS (clk)
    BEGIN
        IF (clk = '1' AND clk'event) THEN
            IF (rst = '1') THEN -- erase all contents
                content <= (OTHERS => (OTHERS => '0'));
            ELSIF (en = '1' AND rw = '1') THEN --write
                content(conv_integer(addr)) <= din;
            END IF;
        END IF;
    END PROCESS;

    readp : PROCESS (rw, addr, en, clk)
    BEGIN
        IF (en = '1' AND rw = '0') THEN
            dout <= content(conv_integer(addr));
        ELSE
            dout <= (OTHERS => 'Z');
        END IF;
    END PROCESS;
END beh;