LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rs232rx IS
    PORT (
        clk, rx, rxout : IN STD_LOGIC; --active high
        rxdone : OUT STD_LOGIC; --active high
        rxres : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END rs232rx;

ARCHITECTURE rtl OF rs232rx IS
    COMPONENT UART_RX
        PORT (
            i_Clk : IN STD_LOGIC;
            i_RX_Serial : IN STD_LOGIC; --usb rx 端口
            o_RX_DV : OUT STD_LOGIC; --When receive is complete o_rx_dv will be driven high for one clock cycle.
            o_RX_Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT etrigate
        PORT (
            e : IN STD_LOGIC; --avtive high
            DIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    U0 : UART_RX PORT MAP(clk, rx, rxdone, d);
    U1 : etrigate PORT MAP(rxout, d, rxres);
END ARCHITECTURE;