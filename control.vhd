--control
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--操作控制器模块
--控制模型机正常运行

ENTITY CTRL IS
    PORT (
        T0, T1, T2, T3, T4, T5, T6, T7 : IN STD_LOGIC;
        key1, key2, key3, key4, txdone, rxdone : IN STD_LOGIC;
        instruction : STD_LOGIC_VECTOR(7 DOWNTO 0);
        clk : IN STD_LOGIC; --时钟信号
        aluop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4, cpclr : OUT STD_LOGIC --输出的指令信号
    );
END ENTITY;

ARCHITECTURE A OF CTRL IS

    SIGNAL state : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN
    PROCESS (clk, instruction)
        VARIABLE sendcnt : INTEGER := 0;
        VARIABLE pccleardone, pcstart : STD_LOGIC := '0';
    BEGIN
        -- SIGNAL clk, clkclear : STD_LOGIC := '0';
        -- SIGNAL Alout, memAddress, dout, dbus, pcAddr, alures, irout : STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- SIGNAL memReset, memReadWrite, whichAddr, pcCount, Alin, Ahin, Ahout, irin : STD_LOGIC := '0';
        -- SIGNAL pcClear, memOut : STD_LOGIC := '1';
        IF rising_edge(clk) THEN
            IF (key1 = '0') THEN
                state <= "00";
            END IF;
            IF (key2 = '0') THEN
                state <= "01";
            END IF;
            IF (key3 = '0') THEN
                state <= "10";
            END IF;
            IF (key4 = '0') THEN
                state <= "11";
            END IF;

            IF (state = "00") THEN --receive code
                --led
                led1 <= '0';
                led2 <= '1';
                led3 <= '1';
                led4 <= '1';
                --
                pcstart := '0';
                pccleardone := '0';
                sendcnt := 0;
                -- PC
                pcClear <= '0';
                -- pcCount <= '0';
                -- Mar
                marin <= '1';
                whichAddr <= '0';
                -- RAM
                memReset <= '0';
                memOut <= '0';
                --AL register
                Alin <= '0';
                --AH register
                Ahin <= '0';
                Ahout <= '0';
                -- ClkSource
                clken <= '1';
                --IR register
                irin <= '1';
                --Control
                cpclr <= '1';
                --RX receiver
                rxout <= '1';
                --rxdone
                --TX sender
                --txen <= '0';
                --txdone
                --
                memReadWrite <= '1';
                txen <= '0';
                IF (rxdone = '1') THEN
                    pcCount <= '1';
                ELSE
                    -- memReadWrite <= '0';
                    pcCount <= '0';
                END IF;

            ELSIF state = "01" THEN --send memory
                --led
                led1 <= '1';
                led2 <= '0';
                led3 <= '1';
                led4 <= '1';
                --
                pcstart := '0';
                pccleardone := '0';
                -- PC
                pcClear <= '0';
                -- pcCount
                -- Mar
                marin <= '1';
                whichAddr <= '0';
                -- RAM
                memReset <= '0';
                memReadWrite <= '0';
                memOut <= '1';
                --AL register
                Alin <= '0';
                --AH register
                Ahin <= '0';
                Ahout <= '0';
                -- ClkSource
                clken <= '1';
                --IR register
                irin <= '1';
                --Control
                cpclr <= '1';
                --RX receiver
                rxout <= '0';
                --rxdone
                --TX sender
                -- txen <= '1';
                --txdone
                -- 256-2=254    23-2 = 21
                IF sendcnt <= 21 THEN
                    txen <= '1';
                    IF (txdone = '1') THEN
                        pcCount <= '1';
                        sendcnt := sendcnt + 1;
                    ELSE
                        pcCount <= '0';
                    END IF;
                ELSE
                    pcCount <= '0';
                    txen <= '0';
                END IF;

            ELSIF state = "10" THEN --pc clear
                --led
                led1 <= '1';
                led2 <= '1';
                led3 <= '0';
                led4 <= '1';
                --
                pcstart := '0';
                sendcnt := 0;
                -- PC
                IF (pccleardone = '0') THEN
                    pcClear <= '1';
                    pccleardone := '1';
                ELSE
                    pcClear <= '0';
                END IF;
                pcCount <= '0';
                -- Mar
                marin <= '1';
                whichAddr <= '0';
                -- RAM
                memReset <= '0';
                memReadWrite <= '0';
                memOut <= '1';
                --AL register
                Alin <= '0';
                --AH register
                Ahin <= '0';
                Ahout <= '0';
                -- ClkSource
                clken <= '1';
                --IR register
                irin <= '1';
                --Control
                cpclr <= '1';
                --RX receiver
                rxout <= '0';
                --rxdone
                --TX sender
                txen <= '0';
                --txdone
                --
            ELSE --run computer
                --led
                led1 <= '1';
                led2 <= '1';
                led3 <= '1';
                led4 <= '0';
                IF pcstart = '0' THEN
                    pcstart := '1';
                    pccleardone := '0';
                    sendcnt := 0;
                    -- PC
                    pcClear <= '0';
                    pcCount <= '0';
                    -- Mar
                    marin <= '1';
                    whichAddr <= '0';
                    -- RAM
                    memReset <= '0';
                    memReadWrite <= '0';
                    memOut <= '1';
                    --AL register
                    Alin <= '0';
                    --AH register
                    Ahin <= '0';
                    Ahout <= '0';
                    -- ClkSource
                    clken <= '1';
                    --IR register
                    irin <= '1';
                    --Control
                    cpclr <= '1';
                    --RX receiver
                    rxout <= '0';
                    --rxdone
                    --TX sender
                    txen <= '0';
                    --txdone
                    --
                ELSE
                    cpclr <= '0';
                    pcClear <= '0';
                    memReset <= '0';

                    CASE instruction IS

                        WHEN "11110000" => -- not
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "000";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                Alin <= '0';
                                aluop <= "000";
                                ahin <= '1';
                                pcCount <= '0';
                            ELSIF t3 = '1' THEN
                                Alin <= '0';
                                ahin <= '0';
                                memOut <= '0';
                                ahout <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                alin <= '1'; --bug
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                ahin <= '0';
                                alin <= '0';
                                memOut <= '1';
                                ahout <= '0';
                                pcCount <= '1';
                            ELSIF t6 = '1' THEN
                                pcCount <= '0';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110001" => --and
                            IF t0 = '1' THEN
                                Alin <= '0';
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "001";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '1';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                aluop <= "001";
                                ahin <= '1';
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                                aluop <= "001";
                                ahin <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t6 = '1' THEN
                                alin <= '0';
                                ahout <= '0';
                                memout <= '1';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110010" => -- or
                            IF t0 = '1' THEN
                                Alin <= '0';
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "010";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '1';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                aluop <= "010";
                                ahin <= '1';
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                                aluop <= "010";
                                ahin <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t6 = '1' THEN
                                alin <= '0';
                                ahout <= '0';
                                memout <= '1';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110011" => -- xor
                            IF t0 = '1' THEN
                                Alin <= '0';
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "011";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '1';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                aluop <= "011";
                                ahin <= '1';
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                                aluop <= "011";
                                ahin <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t6 = '1' THEN
                                alin <= '0';
                                ahout <= '0';
                                memout <= '1';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110100" => --shl
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "100";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                Alin <= '0';
                                aluop <= "100";
                                ahin <= '1';
                                pcCount <= '0';
                            ELSIF t3 = '1' THEN
                                Alin <= '0';
                                ahin <= '0';
                                memOut <= '0';
                                ahout <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                alin <= '1'; --bug
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                ahin <= '0';
                                alin <= '0';
                                memOut <= '1';
                                ahout <= '0';
                                pcCount <= '1';
                            ELSIF t6 = '1' THEN
                                pcCount <= '0';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110101" => --shr
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "101";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                Alin <= '0';
                                aluop <= "101";
                                ahin <= '1';
                                pcCount <= '0';
                            ELSIF t3 = '1' THEN
                                Alin <= '0';
                                ahin <= '0';
                                memOut <= '0';
                                ahout <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                alin <= '1'; --bug
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                ahin <= '0';
                                alin <= '0';
                                memOut <= '1';
                                ahout <= '0';
                                pcCount <= '1';
                            ELSIF t6 = '1' THEN
                                pcCount <= '0';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110110" => --add
                            IF t0 = '1' THEN
                                Alin <= '0';
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "110";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '1';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                aluop <= "110";
                                ahin <= '1';
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                                aluop <= "110";
                                ahin <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t6 = '1' THEN
                                alin <= '0';
                                ahout <= '0';
                                memout <= '1';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11110111" => --sub
                            IF t0 = '1' THEN
                                Alin <= '0';
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                aluop <= "111";
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '1';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                aluop <= "111";
                                ahin <= '1';
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                                aluop <= "111";
                                ahin <= '1';
                            ELSIF t4 = '1' THEN
                                ahin <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t6 = '1' THEN
                                alin <= '0';
                                ahout <= '0';
                                memout <= '1';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11111000" => --load A
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                            ELSIF t4 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '0';
                                pcCount <= '1';
                            ELSIF t6 = '1' THEN
                                pcCount <= '0';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11111001" => --store
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                            ELSIF t4 = '1' THEN
                                pcCount <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                memReadWrite <= '1';
                            ELSIF t5 = '1' THEN
                                pcCount <= '0';
                                ahout <= '1';
                                memOut <= '0';
                                memReadWrite <= '1';
                            ELSIF t6 = '1' THEN
                                ahout <= '0';
                                memOut <= '1';
                                memReadWrite <= '0';
                                pcCount <= '1';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11111010" => --load al  7  Same to F8
                            IF t0 = '1' THEN
                                irin <= '1';
                                pcCount <= '0';
                            ELSIF t1 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                                --rebuild
                            ELSIF t2 = '1' THEN
                                pcCount <= '1';
                            ELSIF t3 = '1' THEN
                                pcCount <= '0';
                            ELSIF t4 = '1' THEN
                                alin <= '1';
                                pcCount <= '0';
                            ELSIF t5 = '1' THEN
                                alin <= '0';
                                pcCount <= '1';
                            ELSIF t6 = '1' THEN
                                pcCount <= '0';
                            ELSIF t7 = '1' THEN
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            ELSE
                                --IR register
                                irin <= '0';
                                -- PC
                                pcClear <= '0';
                                pcCount <= '0';
                                --Control
                                -- Mar
                                marin <= '1';
                                whichAddr <= '0';
                                -- RAM
                                memReadWrite <= '0';
                                memOut <= '1';
                                -- ALU
                                --AL register
                                Alin <= '0';
                                --AH register
                                Ahin <= '0';
                                Ahout <= '0';
                                -- ClkSource
                                clken <= '1';
                            END IF;
                        WHEN "11111011" => --halt
                            pcCount <= '0';
                            -- Mar
                            marin <= '1';
                            whichAddr <= '0';
                            -- RAM
                            memReset <= '0';
                            memReadWrite <= '0';
                            memOut <= '1';
                            --AL register
                            Alin <= '0';
                            --AH register
                            Ahin <= '0';
                            Ahout <= '0';
                            -- ClkSource
                            clken <= '0';
                            --IR register
                            irin <= '0';
                            --Control
                            cpclr <= '1';
                            --RX receiver
                            rxout <= '0';
                            --rxdone
                            --TX sender
                            txen <= '0';
                        WHEN OTHERS =>
                            pcCount <= '0';
                            -- Mar
                            marin <= '1';
                            whichAddr <= '0';
                            -- RAM
                            memReset <= '0';
                            memReadWrite <= '0';
                            memOut <= '1';
                            --AL register
                            Alin <= '0';
                            --AH register
                            Ahin <= '0';
                            Ahout <= '0';
                            -- ClkSource
                            clken <= '0';
                            --IR register
                            irin <= '0';
                            --Control
                            cpclr <= '1';
                            --RX receiver
                            rxout <= '0';
                            --rxdone
                            --TX sender
                            txen <= '0';
                    END CASE;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END A;