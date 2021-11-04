LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY GPReg_File_tb IS
END GPReg_File_tb;
 
ARCHITECTURE behavior OF GPReg_File_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GPReg_File
    PORT(
         Rx_r : IN  std_logic_vector(13 downto 0);
         Rx_w : IN  std_logic_vector(13 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         data : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Rx_r : std_logic_vector(13 downto 0) := (others => '0');
   signal Rx_w : std_logic_vector(13 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';

 	--BiDirs
   signal data : std_logic_vector(15 downto 0) := (others => 'Z');


   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GPReg_File PORT MAP (
          Rx_r => Rx_r,
          Rx_w => Rx_w,
          clk => clk,
          rst => rst,
          data => data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;	
		
		rst <= '0';
		Rx_w <= "00000000000001";
		data <= x"F56A";
      wait for clk_period;
		
		Rx_w <= "00000000000010";
		data <= x"54ED";
      wait for clk_period;
		
		Rx_w <= "00000000000100";
		data <= x"64AA";
      wait for clk_period;
		
		Rx_w <= "00000000001000";
		data <= x"9845";
      wait for clk_period;
		
		Rx_w <= "00000000010000";
		data <= x"ABCD";
      wait for clk_period;
		
		Rx_w <= "00000000100000";
		data <= x"D896";
      wait for clk_period;
		
		Rx_w <= "00000001000000";
		data <= x"FE74";
      wait for clk_period;
		
		Rx_w <= "00000010000000";
		data <= x"A00E";
      wait for clk_period;
		
		Rx_w <= "00000100000000";
		data <= x"BC32";
      wait for clk_period;
		
		Rx_w <= "00001000000000";
		data <= x"54FF";
      wait for clk_period;
		
		Rx_w <= "00010000000000";
		data <= x"FD78";
      wait for clk_period;
		
		Rx_w <= "00100000000000";
		data <= x"556A";
      wait for clk_period;
		
		Rx_w <= "01000000000000";
		data <= x"AC69";
      wait for clk_period;
		
		Rx_w <= "10000000000000";
		data <= x"3169";
      wait for clk_period;
		
		Rx_r <= "00000000000000";
		Rx_w <= "00000000000000";
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;
		
		Rx_r <= "00000000000001";
		wait for clk_period;
		Rx_r <= "00000000000010";
		wait for clk_period;
		Rx_r <= "00000000000100";
		wait for clk_period;
		Rx_r <= "00000000001000";
		wait for clk_period;
		Rx_r <= "00000000010000";
		wait for clk_period;
		Rx_r <= "00000000100000";
		wait for clk_period;
		Rx_r <= "00000001000000";
		wait for clk_period;
		Rx_r <= "00000010000000";
		wait for clk_period;
		Rx_r <= "00000100000000";
		wait for clk_period;
		Rx_r <= "00001000000000";
		wait for clk_period;
		Rx_r <= "00010000000000";
		wait for clk_period;
		Rx_r <= "00100000000000";
		wait for clk_period;
		Rx_r <= "01000000000000";
		wait for clk_period;
		Rx_r <= "10000000000000";
		wait for clk_period;
		
		Rx_r <= "00000000000000";
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;
		
		Rx_r <= "00001000000000";
		wait for clk_period;
		
		Rx_r <= "00000000001000";
		wait for clk_period;
		
		Rx_r <= "00000000000000";
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period*5;
		
      wait;
   end process;

END;