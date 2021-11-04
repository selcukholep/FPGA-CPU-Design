LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DECODER_4X16 IS
    PORT( X  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          Y  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          EN : IN  STD_LOGIC);
END DECODER_4X16;

ARCHITECTURE BEHAVIORAL OF DECODER_4X16 IS
BEGIN
	PROCESS (X, EN)
	BEGIN
		Y <= X"0000";
		IF (EN = '1') THEN
			CASE X IS
				WHEN "0000" => Y(0) <= '1';
				WHEN "0001" => Y(1) <= '1';
				WHEN "0010" => Y(2) <= '1';
				WHEN "0011" => Y(3) <= '1';
				WHEN "0100" => Y(4) <= '1';
				WHEN "0101" => Y(5) <= '1';
				WHEN "0110" => Y(6) <= '1';
				WHEN "0111" => Y(7) <= '1';
				WHEN "1000" => Y(8) <= '1';
				WHEN "1001" => Y(9) <= '1';
				WHEN "1010" => Y(10) <= '1';
				WHEN "1011" => Y(11) <= '1';
				WHEN "1100" => Y(12) <= '1';
				WHEN "1101" => Y(13) <= '1';
				WHEN "1110" => Y(14) <= '1';
				WHEN "1111" => Y(15) <= '1';
				WHEN OTHERS => Y <= X"0000";
			END CASE;
		END IF;
	END PROCESS;
END BEHAVIORAL;