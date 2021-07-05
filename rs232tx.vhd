LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rx232tx IS
    PORT (
        clk, txen : IN STD_LOGIC;
        i_TX_Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        tx, txdone : OUT STD_LOGIC
    );
END rx232tx;

ARCHITECTURE rtl OF rx232tx IS

    COMPONENT UART_TX
        GENERIC (
            --50M/9600 baud
            g_CLKS_PER_BIT : INTEGER := 5208 -- Needs to be set correctly
        );
        PORT (
            i_Clk : IN STD_LOGIC;
            i_TX_DV : IN STD_LOGIC; --active high
            i_TX_Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_TX_Active : OUT STD_LOGIC;
            o_TX_Serial : OUT STD_LOGIC;
            o_TX_Done : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL active, done : STD_LOGIC;
BEGIN
    U0 : UART_TX PORT MAP(clk, txen, i_TX_Byte, active, tx, done);
    txdone <= active AND done;
END ARCHITECTURE;