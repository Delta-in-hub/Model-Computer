LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY top IS
    PORT (
        clk, rx, key, key2 : IN STD_LOGIC; --板子时钟 50mhz
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --led针脚
        dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1); --led针脚
        led1, led2, led3, tx : OUT STD_LOGIC
    );
END top;

ARCHITECTURE arch OF top IS
    COMPONENT numtoled
        PORT (
            clk : IN STD_LOGIC;
            yournum : IN INTEGER RANGE 0 TO 1e4 := 0000;
            seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1)
        );
    END COMPONENT;

    COMPONENT UART_RX
        PORT (
            i_Clk : IN STD_LOGIC;
            i_RX_Serial : IN STD_LOGIC; --usb rx 端口
            o_RX_DV : OUT STD_LOGIC; --When receive is complete o_rx_dv will be driven high for one clock cycle.
            o_RX_Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT UART_TX
        PORT (
            i_Clk : IN STD_LOGIC;
            i_TX_DV : IN STD_LOGIC; --使能 active high
            i_TX_Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_TX_Active : OUT STD_LOGIC;
            o_TX_Serial : OUT STD_LOGIC; --usb tx端口
            o_TX_Done : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT RAM
        GENERIC (
            nadd : NATURAL := 3; --address bus width
            n : NATURAL := 8; --element size
            size : NATURAL := 1024 -- size * n Bytes RAM
        );
        PORT (
            addr : IN STD_LOGIC_VECTOR(nadd - 1 DOWNTO 0);
            dout : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            din : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            en : IN STD_LOGIC; --active high
            clk, rst : IN STD_LOGIC;--active high
            rw : IN STD_LOGIC -- 0 read / 1 write
        );
    END COMPONENT;
    COMPONENT keyFitting
        PORT (
            clk : IN STD_LOGIC;
            key : IN STD_LOGIC;
            status : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL ansi : INTEGER RANGE 0 TO 1e4 := 0;
    SIGNAL reg : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL recdone : STD_LOGIC;
    SIGNAL din, dout : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL rw : STD_LOGIC := '1';
    SIGNAL buttom, buttom2, send : STD_LOGIC := '1';
    SIGNAL sends, sendactive, senddone : STD_LOGIC := '0';
    SIGNAL address, outaddr : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL addr : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL mode, sendonce : STD_LOGIC := '0';
BEGIN
    U0 : keyFitting PORT MAP(clk, key, buttom);
    K0 : keyFitting PORT MAP(clk, key2, buttom2);

    -- When receive is complete o_rx_dv will be driven high for one clock cycle.
    U1 : UART_RX PORT MAP(clk, rx, recdone, reg);
    U2 : numtoled PORT MAP(clk, ansi, seg, dig);
    ansi <= to_integer(unsigned(address));
    U3 : UART_TX PORT MAP(clk, sends, dout, sendactive, tx, senddone);
    U4 : RAM PORT MAP(address, dout, din, '1', clk, '0', rw);
    din <= reg;
    led1 <= mode;
    led2 <= sendonce;

    recp : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF buttom = '0' THEN
                mode <= NOT mode;
            END IF;
            IF buttom2 = '0' THEN
                sendonce <= NOT sendonce;
            END IF;

            IF mode = '0' THEN --receive
                rw <= '1'; --1 for write
                address <= addr;
                IF recdone = '1' THEN
                    addr <= addr + '1';
                END IF;
            ELSE -- sendp
                rw <= '0';
                address <= outaddr;
                IF sendonce = '0' THEN
                    sends <= '0';
                    IF senddone = '1' AND sendactive = '0' THEN
                        outaddr <= outaddr + '1'; --每次自增2
                    END IF;
                ELSE
                    sends <= '1';
                    sendonce <= '0';
                END IF;
            END IF;

        END IF;
    END PROCESS; -- recp

END ARCHITECTURE;