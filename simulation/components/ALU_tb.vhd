LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_tst IS
END ALU_vhd_tst;
ARCHITECTURE ALU_arch OF ALU_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL AIN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ALU_ENABLE : STD_LOGIC;
SIGNAL BIN : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL FLAG_OUT : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL OPCODE_IN : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL OUTP : STD_LOGIC_VECTOR(15 DOWNTO 0);
COMPONENT ALU
	PORT (
	AIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	ALU_ENABLE : IN STD_LOGIC;
	BIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	FLAG_OUT : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	OPCODE_IN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	OUTP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	AIN => AIN,
	ALU_ENABLE => ALU_ENABLE,
	BIN => BIN,
	FLAG_OUT => FLAG_OUT,
	OPCODE_IN => OPCODE_IN,
	OUTP => OUTP
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        ALU_ENABLE <= '1';
	OPCODE_IN <= "0000";
	AIN <= X"0000";
	BIN <= X"0000";
	WAIT FOR 10 ns;
	----------------------
	ALU_ENABLE <= '0';
	OPCODE_IN <= "0000";
	AIN <= X"0001";
	BIN <= X"FFFF";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0000";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0001";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0010";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0011";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0100";
	WAIT FOR 10 ns;
	----------------------
	OPCODE_IN <= "0101";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "0110";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "0111";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1000";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1001";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1010";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1011";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1100";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1101";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1110";
	WAIT FOR 10 ns;
		----------------------
	OPCODE_IN <= "1111";
	WAIT FOR 10 ns;

WAIT;                                                        
END PROCESS always;                                          
END ALU_arch;