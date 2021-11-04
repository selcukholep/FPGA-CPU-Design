LIBRARY ieee, modelsim_lib;                                               
USE ieee.std_logic_1164.ALL;   
USE modelsim_lib.util.ALL;
           

ENTITY Controller_tb IS
END Controller_tb;
ARCHITECTURE Controller_arch OF Controller_tb IS
-- constants                                                 
-- signals                                                   
SIGNAL Clock : STD_LOGIC := '0';
SIGNAL Reset : STD_LOGIC := '1';
SIGNAL START : STD_LOGIC := '0';
SIGNAL TMP_DATA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL TMP_ADR : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL STOP : STD_LOGIC := '0';

type reg_file_type is array (13 downto 0) of std_logic_vector (15 downto 0);

signal REG : reg_file_type;

type instruction_type is (ADD_0, SUB_0, AND_0, OR_0, NOT_0, XOR_0, CMP_0, SHL_0, SHR_0, INC_0, DEC_0, ROR_0, ROL_0, ADC_0, SBB_0, MDL_0, MOV_0, XCHG_0, JMP_0, JZ_0, JNZ_0, JG_0, JLE_0, NONE_0, PUSH_0, POP_0, PUSHF_0, POPF_0, IN_0, OUT_0, NOP_0, HLT_0);

signal Instruction : instruction_type;
signal Steps	: STD_LOGIC_VECTOR(7 downto 0);

signal clock_count		 		 : integer := 0;
signal instruction_count		 : integer := 0;

COMPONENT CONTROLLER
	PORT (
	Clock : IN STD_LOGIC;
	Reset : IN STD_LOGIC;
	START : IN STD_LOGIC;
	TMP_DATA : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	TMP_ADR	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

constant clk_period 		 : time := 10 ns;
constant fast_clk_period : time := 4 ps;

BEGIN
	i1 : CONTROLLER
	PORT MAP (
	Clock => Clock,
	Reset => Reset,
	START => START,
	TMP_DATA => TMP_DATA,
	TMP_ADR => TMP_ADR
	);

clk_process : PROCESS
BEGIN
	if (STOP = '0') then
	
		if (START = '0') THEN
			wait for fast_clk_period / 2;
		ELSE
			wait for clk_period / 2;
		END IF;
		Clock <= NOT Clock;
		
	else
		wait;
	end if;
	
END PROCESS;

instruction_counter : PROCESS(Steps)
BEGIN
	IF (Steps(1) = '1') THEN
		instruction_count <= instruction_count + 1;
	END IF;
END PROCESS instruction_counter;

spy_process : process
begin
	init_signal_spy("/controller_tb/i1/CPU_0/CU_0/instruction", "/Instruction", 1);
	init_signal_spy("/controller_tb/i1/CPU_0/CU_0/S", "/Steps", 1);
	
	for i in 0 to 14 loop
		init_signal_spy("/controller_tb/i1/CPU_0/GPReg/reg" & integer'image(i) & "/data_temp", "/REG(" & integer'image(i) & ")", 1);
	end loop;
	
wait;
end process spy_process;
	
always : PROCESS                                              
                             
BEGIN   
	
	wait for fast_clk_period / 2;
	
	Reset <= '0';
	
	------------------------------------------------------------------
	TMP_ADR <= x"0000";	WAIT FOR fast_clk_period;	TMP_ADR(0) <= 'Z';	-- CODE SEGMENT
	------------------------------------------------------------------

	TMP_DATA <= x"800E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"0007";	WAIT FOR fast_clk_period;	-- MOV R0, 07h
	TMP_DATA <= x"801E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"0005";	WAIT FOR fast_clk_period;	-- MOV R1, 05h
	TMP_DATA <= x"802E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"000B";	WAIT FOR fast_clk_period;	-- MOV R2, 0Bh
	TMP_DATA <= x"0B10";	WAIT FOR fast_clk_period;	                                              	-- SUB R3, R1, R0
	TMP_DATA <= x"805E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"000D";	WAIT FOR fast_clk_period;	-- MOV R5, 0Dh
	TMP_DATA <= x"374E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"0000";	WAIT FOR fast_clk_period;	-- CMP R4, 0
	TMP_DATA <= x"980E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"000E";	WAIT FOR fast_clk_period;	-- JZ jmp1
	TMP_DATA <= x"F000";	WAIT FOR fast_clk_period;	                                              	-- NOP
	TMP_DATA <= x"3643";	WAIT FOR fast_clk_period;	                                              	-- CMP R6, R4, R3
	TMP_DATA <= x"0462";	WAIT FOR fast_clk_period;	                                              	-- ADD R4, R6, R2
	TMP_DATA <= x"8354";	WAIT FOR fast_clk_period;	                                              	-- STORE R5, R4
	TMP_DATA <= x"900E";	WAIT FOR fast_clk_period;	TMP_DATA <= x"0015";	WAIT FOR fast_clk_period;	-- JMP jmp2
	TMP_DATA <= x"F000";	WAIT FOR fast_clk_period;	                                              	-- NOP
	TMP_DATA <= x"F000";	WAIT FOR fast_clk_period;	                                              	-- NOP
	TMP_DATA <= x"2D36";	WAIT FOR fast_clk_period;	                                              	-- XOR R5, R3, R6
	TMP_DATA <= x"2250";	WAIT FOR fast_clk_period;	                                              	-- NOT R2, R5
	TMP_DATA <= x"8182";	WAIT FOR fast_clk_period;	                                              	-- LOAD R8, R2
	TMP_DATA <= x"F800";	WAIT FOR fast_clk_period;	                                              	-- HLT


	
	TMP_DATA <= "ZZZZZZZZZZZZZZZZ";
	START <= '1';
	
	WHILE instruction /= HLT_0 AND clock_count < 10000 LOOP
		wait for clk_period;
		clock_count <= clock_count + 1;
	END LOOP;
	
	STOP <= '1';

WAIT;                                                        
END PROCESS always;                                          
END Controller_arch;

