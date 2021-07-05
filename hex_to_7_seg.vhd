-- Hex to 7-segment conversion
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hex_to_7_seg IS
	PORT (
		seven_seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hex : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
END hex_to_7_seg;

ARCHITECTURE behavior OF hex_to_7_seg IS

	SIGNAL seg_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	--  7 segs are active low  共阳数码管
	seven_seg <= NOT seg_out;

	seg_proc : PROCESS (hex)
	BEGIN
		CASE hex IS
			WHEN x"0" => seg_out <= "0111111";
			WHEN x"1" => seg_out <= "0000110";
			WHEN x"2" => seg_out <= "1011011";
			WHEN x"3" => seg_out <= "1001111";
			WHEN x"4" => seg_out <= "1100110";
			WHEN x"5" => seg_out <= "1101101";
			WHEN x"6" => seg_out <= "1111101";
			WHEN x"7" => seg_out <= "0000111";
			WHEN x"8" => seg_out <= "1111111";
			WHEN x"9" => seg_out <= "1101111";
			WHEN x"A" => seg_out <= "1110111";
			WHEN x"B" => seg_out <= "1111100";
			WHEN x"C" => seg_out <= "0111001";
			WHEN x"D" => seg_out <= "1011110";
			WHEN x"E" => seg_out <= "1111001";
			WHEN x"F" => seg_out <= "1110001";
			WHEN OTHERS =>
				seg_out <= (OTHERS => 'X');
		END CASE;
	END PROCESS seg_proc;
END behavior;