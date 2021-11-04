LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SP IS
    GENERIC( ADR_HI : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FFFF";
	      ADR_LO : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FF00");
    PORT( RST  : IN  STD_LOGIC;
          CLK  : IN  STD_LOGIC;
          DO   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          RE   : IN  STD_LOGIC;
          UP   : IN  STD_LOGIC;
          DOWN : IN  STD_LOGIC);
END SP;

ARCHITECTURE BEHAVIORAL OF SP IS

SIGNAL DATA : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
    PROCESS(CLK, RST, UP, DOWN, RE, DATA)
    BEGIN
        IF (RST = '1') THEN
        	DO <= ADR_HI;
        	DATA <= ADR_HI;
        ELSIF (UP = '1' OR DOWN = '1') THEN
        	IF (CLK'EVENT AND CLK = '1') THEN
        	    IF (UP = '1' AND DATA(7 DOWNTO 0) < ADR_HI(7 DOWNTO 0)) THEN
    	        DATA <= STD_LOGIC_VECTOR(UNSIGNED(DATA) + 1);
    	    ELSIF (DOWN = '1' AND DATA(7 DOWNTO 0) > ADR_LO(7 DOWNTO 0)) THEN
    	        DATA <= STD_LOGIC_VECTOR(UNSIGNED(DATA) - 1);
    	    END IF;
    	END IF;
    	DO <= "ZZZZZZZZZZZZZZZZ";
        ELSIF (RE = '1') THEN
        	DO <= DATA;
        ELSE
        	DO <= "ZZZZZZZZZZZZZZZZ";
        END IF;
    END PROCESS;

END BEHAVIORAL;