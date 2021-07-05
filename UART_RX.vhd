----------------------------------------------------------------------
-- This file contains the UART Receiver.  This receiver is able to
-- receive 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When receive is complete o_rx_dv will be
-- driven high for one clock cycle.
--
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- Example: 10 MHz Clock, 115200 baud UART
-- (10000000)/(115200) = 87

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UART_RX IS
    GENERIC (
        --50M/9600 baud
        g_CLKS_PER_BIT : INTEGER := 5208 -- Needs to be set correctly := Frequency/baud
    );
    PORT (
        i_Clk : IN STD_LOGIC;
        i_RX_Serial : IN STD_LOGIC;
        o_RX_DV : OUT STD_LOGIC;
        o_RX_Byte : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END UART_RX;
ARCHITECTURE rtl OF UART_RX IS

    TYPE t_SM_Main IS (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
        s_RX_Stop_Bit, s_Cleanup);
    SIGNAL r_SM_Main : t_SM_Main := s_Idle;

    SIGNAL r_RX_Data_R : STD_LOGIC := '0';
    SIGNAL r_RX_Data : STD_LOGIC := '0';

    SIGNAL r_Clk_Count : INTEGER RANGE 0 TO g_CLKS_PER_BIT - 1 := 0;
    SIGNAL r_Bit_Index : INTEGER RANGE 0 TO 7 := 0; -- 8 Bits Total
    SIGNAL r_RX_Byte : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL r_RX_DV : STD_LOGIC := '0';

BEGIN

    -- Purpose: Double-register the incoming data.
    -- This allows it to be used in the UART RX Clock Domain.
    -- (It removes problems caused by metastabiliy)
    p_SAMPLE : PROCESS (i_Clk)
    BEGIN
        IF rising_edge(i_Clk) THEN
            r_RX_Data_R <= i_RX_Serial;
            r_RX_Data <= r_RX_Data_R;
        END IF;
    END PROCESS p_SAMPLE;
    -- Purpose: Control RX state machine
    p_UART_RX : PROCESS (i_Clk)
    BEGIN
        IF rising_edge(i_Clk) THEN

            CASE r_SM_Main IS

                WHEN s_Idle =>
                    r_RX_DV <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;

                    IF r_RX_Data = '0' THEN -- Start bit detected
                        r_SM_Main <= s_RX_Start_Bit;
                    ELSE
                        r_SM_Main <= s_Idle;
                    END IF;
                    -- Check middle of start bit to make sure it's still low
                WHEN s_RX_Start_Bit =>
                    IF r_Clk_Count = (g_CLKS_PER_BIT - 1)/2 THEN
                        IF r_RX_Data = '0' THEN
                            r_Clk_Count <= 0; -- reset counter since we found the middle
                            r_SM_Main <= s_RX_Data_Bits;
                        ELSE
                            r_SM_Main <= s_Idle;
                        END IF;
                    ELSE
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Start_Bit;
                    END IF;
                    -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
                WHEN s_RX_Data_Bits =>
                    IF r_Clk_Count < g_CLKS_PER_BIT - 1 THEN
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Data_Bits;
                    ELSE
                        r_Clk_Count <= 0;
                        r_RX_Byte(r_Bit_Index) <= r_RX_Data;

                        -- Check if we have sent out all bits
                        IF r_Bit_Index < 7 THEN
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= s_RX_Data_Bits;
                        ELSE
                            r_Bit_Index <= 0;
                            r_SM_Main <= s_RX_Stop_Bit;
                        END IF;
                    END IF;
                    -- Receive Stop bit.  Stop bit = 1
                WHEN s_RX_Stop_Bit =>
                    -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                    IF r_Clk_Count < g_CLKS_PER_BIT - 1 THEN
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Stop_Bit;
                    ELSE
                        r_RX_DV <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_Cleanup;
                    END IF;
                    -- Stay here 1 clock
                WHEN s_Cleanup =>
                    r_SM_Main <= s_Idle;
                    r_RX_DV <= '0';
                WHEN OTHERS =>
                    r_SM_Main <= s_Idle;

            END CASE;
        END IF;
    END PROCESS p_UART_RX;

    o_RX_DV <= r_RX_DV;
    o_RX_Byte <= r_RX_Byte;

END rtl;