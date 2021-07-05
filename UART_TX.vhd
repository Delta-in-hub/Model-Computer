----------------------------------------------------------------------
-- This file contains the UART Transmitter.  This transmitter is able
-- to transmit 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When transmit is complete o_TX_Done will be
-- driven high for one clock cycle.
--
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- Example: 10 MHz Clock, 115200 baud UART
-- (10000000)/(115200) = 87
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UART_TX IS
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
END UART_TX;
ARCHITECTURE RTL OF UART_TX IS

    TYPE t_SM_Main IS (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
        s_TX_Stop_Bit, s_Cleanup);
    SIGNAL r_SM_Main : t_SM_Main := s_Idle;

    SIGNAL r_Clk_Count : INTEGER RANGE 0 TO g_CLKS_PER_BIT - 1 := 0;
    SIGNAL r_Bit_Index : INTEGER RANGE 0 TO 7 := 0; -- 8 Bits Total
    SIGNAL r_TX_Data : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL r_TX_Done : STD_LOGIC := '0';

BEGIN
    p_UART_TX : PROCESS (i_Clk)
    BEGIN
        IF rising_edge(i_Clk) THEN

            CASE r_SM_Main IS

                WHEN s_Idle =>
                    o_TX_Active <= '0';
                    o_TX_Serial <= '1'; -- Drive Line High for Idle
                    r_TX_Done <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;

                    IF i_TX_DV = '1' THEN
                        r_TX_Data <= i_TX_Byte;
                        r_SM_Main <= s_TX_Start_Bit;
                    ELSE
                        r_SM_Main <= s_Idle;
                    END IF;
                    -- Send out Start Bit. Start bit = 0
                WHEN s_TX_Start_Bit =>
                    o_TX_Active <= '1';
                    o_TX_Serial <= '0';

                    -- Wait g_CLKS_PER_BIT-1 clock cycles for start bit to finish
                    IF r_Clk_Count < g_CLKS_PER_BIT - 1 THEN
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Start_Bit;
                    ELSE
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_TX_Data_Bits;
                    END IF;
                    -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish
                WHEN s_TX_Data_Bits =>
                    o_TX_Serial <= r_TX_Data(r_Bit_Index);

                    IF r_Clk_Count < g_CLKS_PER_BIT - 1 THEN
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Data_Bits;
                    ELSE
                        r_Clk_Count <= 0;

                        -- Check if we have sent out all bits
                        IF r_Bit_Index < 7 THEN
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= s_TX_Data_Bits;
                        ELSE
                            r_Bit_Index <= 0;
                            r_SM_Main <= s_TX_Stop_Bit;
                        END IF;
                    END IF;
                    -- Send out Stop bit.  Stop bit = 1
                WHEN s_TX_Stop_Bit =>
                    o_TX_Serial <= '1';

                    -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                    IF r_Clk_Count < g_CLKS_PER_BIT - 1 THEN
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Stop_Bit;
                    ELSE
                        r_TX_Done <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_Cleanup;
                    END IF;
                    -- Stay here 1 clock
                WHEN s_Cleanup =>
                    o_TX_Active <= '0';
                    r_TX_Done <= '1';
                    r_SM_Main <= s_Idle;
                WHEN OTHERS =>
                    r_SM_Main <= s_Idle;

            END CASE;
        END IF;
    END PROCESS p_UART_TX;

    o_TX_Done <= r_TX_Done;

END RTL;