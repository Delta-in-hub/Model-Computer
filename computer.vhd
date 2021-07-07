LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY computer IS
    PORT (
        clk50m, rx, key1, key2, key3, key4,resetkey : IN STD_LOGIC; --板子时钟 50mhz
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); --led针脚
        dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1); --led针脚
        led1, led2, led3, led4, tx : OUT STD_LOGIC
    );
END computer;

ARCHITECTURE arch OF computer IS
    COMPONENT numtoled
        PORT (
            clk : IN STD_LOGIC;
            yournum : IN INTEGER RANGE 0 TO 1e4 := 0000;
            seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            dig : OUT STD_LOGIC_VECTOR(4 DOWNTO 1)
        );
    END COMPONENT;
    COMPONENT rs232rx
        PORT (
            clk, rx, rxout : IN STD_LOGIC; --active high
            rxdone : OUT STD_LOGIC; --active high
            rxres : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT rs232tx
        PORT (
            clk, txen : IN STD_LOGIC;
            i_TX_Byte : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            tx, txdone : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT RAM
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
    END COMPONENT;

    COMPONENT keyFitting
        PORT (
            clk : IN STD_LOGIC;
            key : IN STD_LOGIC;
            status : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Register 0
    COMPONENT MAR
        PORT (
            clk, ia : STD_LOGIC; --active high
            which : IN STD_LOGIC; --0 for D0 , 1 for D1
            D0, D1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT etrigate
        PORT (
            e : IN STD_LOGIC; --avtive high
            DIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT programmeCounter
        PORT (
            clk : IN STD_LOGIC;
            clr : IN STD_LOGIC; --active low
            ipc : IN STD_LOGIC; --active high
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    -- just a register : A
    COMPONENT Accumulator
        PORT (
            clk : IN STD_LOGIC;
            Ia : IN STD_LOGIC; -- active high
            D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT alu
        PORT (
            --not and or xor shl shr add sub
            opn : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            A, B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT dataRegsiter
        PORT (
            clk : IN STD_LOGIC;
            Idr, Odr : IN STD_LOGIC; --active high
            D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clockSource
        PORT (
            clk_50M : IN STD_LOGIC;
            en : IN STD_LOGIC; --Active low
            clkout : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT CTRL
        PORT (
            key1, key2, key3, key4, txdone, rxdone : IN STD_LOGIC;
            instruction : STD_LOGIC_VECTOR(7 DOWNTO 0);
            clk : IN STD_LOGIC; --时钟信号
            aluop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4 : OUT STD_LOGIC --输出的指令信号
        );
    END COMPONENT;

    SIGNAL clk, clken : STD_LOGIC := '1';
    SIGNAL Alout, memAddress, dout, dbus, pcAddr, alures, irout : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL memReset, memReadWrite, whichAddr, pcCount, Alin, Ahin, Ahout, irin, marin : STD_LOGIC := '0';
    SIGNAL pcClear, memOut : STD_LOGIC := '0';
    SIGNAL aluop : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL rxout, rxdone, txen, txdone : STD_LOGIC;
    SIGNAL yournum : INTEGER RANGE 0 TO 1e4 := 0000;
	 signal rk,memReset2 : std_logic;
BEGIN
		memReset2 <= memReset or (not rk);
    U0 : RAM PORT MAP(memAddress, dout, dbus, '1', clk, memReset2, memReadWrite);
    U1 : MAR PORT MAP(clk, marin, whichAddr, pcAddr, dbus, memAddress);
    U2 : programmeCounter PORT MAP(clk, pcClear, pcCount, pcAddr);
    U3 : etrigate PORT MAP(memOut, dout, dbus);
    U4 : Accumulator PORT MAP(clk, Alin, dbus, Alout);
    U5 : alu PORT MAP(aluop, Alout, dbus, alures);
    U6 : dataRegsiter PORT MAP(clk, Ahin, Ahout, alures, dbus);
    U7 : clockSource PORT MAP(clk50m, clken, clk);
    U8 : Accumulator PORT MAP(clk, irin, dbus, irout); -- ir
    U9 : CTRL PORT MAP(key1, key2, key3, key4, txdone, rxdone, irout, clk50m, aluop, memReset, memReadWrite, marin, whichAddr, pcClear, pcCount, memOut, Alin, Ahin, Ahout, clken, irin, txen, rxout, led1, led2, led3, led4);
    U10 : rs232rx PORT MAP(clk, rx, rxout, rxdone, dbus);
    U11 : rs232tx PORT MAP(clk, txen, dbus, tx, txdone);
    U12 : numtoled PORT MAP(clk50m, yournum, seg, dig);
    U13 : yournum <= to_integer(unsigned(pcAddr));
    U14 : keyFitting PORT MAP(clk, resetkey, rk);
END ARCHITECTURE;