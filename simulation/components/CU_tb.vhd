LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;         
use IEEE.NUMERIC_STD.ALL;
                       

ENTITY CU_tb IS
END CU_tb;
ARCHITECTURE CU_arch OF CU_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL ACC_R : STD_LOGIC;
SIGNAL ALU_E : STD_LOGIC;
SIGNAL ATR_W : STD_LOGIC;
SIGNAL Clock : STD_LOGIC;
SIGNAL FR : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL FR_CLK : STD_LOGIC;
SIGNAL IR : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IR_W : STD_LOGIC;
SIGNAL MAR_W : STD_LOGIC;
SIGNAL PC_R : STD_LOGIC;
SIGNAL PC_U : STD_LOGIC;
SIGNAL PC_W : STD_LOGIC;
SIGNAL RAM_R : STD_LOGIC;
SIGNAL RAM_W : STD_LOGIC;
SIGNAL Reset : STD_LOGIC := '1';
SIGNAL RIO_R : STD_LOGIC;
SIGNAL RIO_W : STD_LOGIC;
SIGNAL RX_R : STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL RX_W : STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL SP_D : STD_LOGIC;
SIGNAL SP_R : STD_LOGIC;
SIGNAL SP_U : STD_LOGIC;
SIGNAL TR_R : STD_LOGIC;
SIGNAL TR_W : STD_LOGIC;
SIGNAL FR_R	: STD_LOGIC;
SIGNAL FR_W	: STD_LOGIC;

SIGNAL STOP : STD_LOGIC := '0';

type instruction_type is (ADD_0, SUB_0, AND_0, OR_0, NOT_0, XOR_0, CMP_0, SHL_0, SHR_0, INC_0, DEC_0, ROR_0, ROL_0, ADC_0, SBB_0, MDL_0, MOV_0, XCHG_0, JMP_0, JZ_0, JNZ_0, JG_0, JLE_0, NONE_0, PUSH_0, POP_0, IN_0, OUT_0, NONE_1, NONE_2, NOP_0, HLT_0);
signal instruction : instruction_type;

COMPONENT CU
	PORT (
	ACC_R : OUT STD_LOGIC;
	ALU_E : OUT STD_LOGIC;
	ATR_W : OUT STD_LOGIC;
	Clock : IN STD_LOGIC;
	FR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	FR_CLK : OUT STD_LOGIC;
	IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	IR_W : OUT STD_LOGIC;
	MAR_W : OUT STD_LOGIC;
	PC_R : OUT STD_LOGIC;
	PC_U : OUT STD_LOGIC;
	PC_W : OUT STD_LOGIC;
	RAM_R : OUT STD_LOGIC;
	RAM_W : OUT STD_LOGIC;
	Reset : IN STD_LOGIC;
	RIO_R : OUT STD_LOGIC;
	RIO_W : OUT STD_LOGIC;
	RX_R : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
	RX_W : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
	SP_D : OUT STD_LOGIC;
	SP_R : OUT STD_LOGIC;
	SP_U : OUT STD_LOGIC;
	TR_R : OUT STD_LOGIC;
	TR_W : OUT STD_LOGIC;
	FR_R : OUT STD_LOGIC;
   FR_W : OUT STD_LOGIC
	);
END COMPONENT;

constant clk_period : time := 10 ps;

BEGIN
	i1 : CU
	PORT MAP (
	ACC_R => ACC_R,
	ALU_E => ALU_E,
	ATR_W => ATR_W,
	Clock => Clock,
	FR => FR,
	FR_CLK => FR_CLK,
	IR => IR,
	IR_W => IR_W,
	MAR_W => MAR_W,
	PC_R => PC_R,
	PC_U => PC_U,
	PC_W => PC_W,
	RAM_R => RAM_R,
	RAM_W => RAM_W,
	Reset => Reset,
	RIO_R => RIO_R,
	RIO_W => RIO_W,
	RX_R => RX_R,
	RX_W => RX_W,
	SP_D => SP_D,
	SP_R => SP_R,
	SP_U => SP_U,
	TR_R => TR_R,
	TR_W => TR_W,
	FR_R => FR_R,
	FR_W => FR_W
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
	
	for i in 0 to 31 loop
		FR <= "0000";
		IR <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 5)) & "00000011110";
		instruction <= instruction_type'VAL(i);
		wait for clk_period * 8;
		Reset <= '1';
		wait for clk_period * 2;
		Reset <= '0';
	end loop;
	
	wait for clk_period* 20;
	STOP <= '1';
wait;                                                       
END PROCESS always;                                          
END CU_arch;
