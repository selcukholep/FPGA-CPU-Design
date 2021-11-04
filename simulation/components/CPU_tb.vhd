LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY CPU_tb IS
END CPU_tb;
ARCHITECTURE CPU_arch OF CPU_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL ADR : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL Clock : STD_LOGIC;
SIGNAL IO : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RAM : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RAM_R : STD_LOGIC;
SIGNAL RAM_W : STD_LOGIC;
SIGNAL Reset : STD_LOGIC := '1';

SIGNAL STOP : STD_LOGIC := '0';

COMPONENT CPU
	PORT (
	ADR : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	Clock : IN STD_LOGIC;
	IO : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	RAM : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	RAM_R : OUT STD_LOGIC;
	RAM_W : OUT STD_LOGIC;
	Reset : IN STD_LOGIC
	);
END COMPONENT;

constant clk_period : time := 10 ps;

BEGIN
	i1 : CPU
	PORT MAP (
	ADR => ADR,
	Clock => Clock,
	IO => IO,
	RAM => RAM,
	RAM_R => RAM_R,
	RAM_W => RAM_W,
	Reset => Reset
	);

clk_process : PROCESS
BEGIN
	if (STOP = '0') then
		Clock <= '0';
		wait for clk_period/2;
		Clock <= '1';
		wait for clk_period/2;
	else
		wait;
	end if;
	
END PROCESS;
	
always : PROCESS                                              											
BEGIN                                                         
	wait for clk_period * 1.5;
	Reset <= '0';
	RAM <= x"F000";
	wait for clk_period*100;
	
STOP <= '1';
WAIT;                                                        
END PROCESS always;                                          
END CPU_arch;
