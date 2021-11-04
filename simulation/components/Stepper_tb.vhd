LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Stepper_tb IS
END Stepper_tb;
ARCHITECTURE Stepper_arch OF Stepper_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC;
SIGNAL reset : STD_LOGIC  := '1';
SIGNAL S : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL W : STD_LOGIC := '0';
SIGNAL X : STD_LOGIC := '0';
SIGNAL Y : STD_LOGIC := '0';
SIGNAL Z : STD_LOGIC := '0';
SIGNAL Q : STD_LOGIC := '1';
COMPONENT Stepper
	PORT (
	clock : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	S : OUT STD_LOGIC_VECTOR(7 downto 0);
	W : IN STD_LOGIC;
	X : IN STD_LOGIC;
	Y : IN STD_LOGIC;
	Z : IN STD_LOGIC;
	Q : IN STD_LOGIC
	);
END COMPONENT;

constant clk_period : time := 10 ps;

BEGIN
	i1 : Stepper
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	reset => reset,
	S => S,
	W => W,
	X => X,
	Y => Y,
	Z => Z,
	Q => Q
	);

clk_process :PROCESS
BEGIN
	clock <= '0';
	wait for clk_period/2;
	clock <= '1';
	wait for clk_period/2;
END PROCESS;

x_process :PROCESS
BEGIN
	x <= '0';
	wait for clk_period * 20;
	x <= '1';
	wait for clk_period * 20;
END PROCESS;
	
always : PROCESS 
     
BEGIN 

	wait for clk_period * 1.5;

	reset <= '0';
	
	wait for clk_period*20;
	 
	WAIT;                                                        
END PROCESS always;
                                          
END Stepper_arch;
