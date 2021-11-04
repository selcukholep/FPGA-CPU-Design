LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY PC_tb IS
END PC_tb;
 
ARCHITECTURE behavior OF PC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PC
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         we : IN  std_logic;
         re : IN  std_logic;
         up : IN  std_logic;
         data : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal we : std_logic := '0';
   signal re : std_logic := '0';
   signal up : std_logic := '0';

 	--BiDirs
   signal data : std_logic_vector(15 downto 0) := (others => 'Z');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PC PORT MAP (
          rst => rst,
          clk => clk,
          we => we,
          re => re,
          up => up,
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
		we <= '1';
		data <= x"FEF5";
      wait for clk_period;
		
		we <= '0';
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;
		
		re <= '1';
		wait for clk_period;
		
		re <= '0';
		up <= '1';
		wait for clk_period*12;
		
		up <= '0';
		re <= '1';
		
--		re <= '1';
--		wait for clk_period;
--		
--		up <= '0';
--		wait for clk_period;
--		
--		up <= '1';
--		wait for clk_period*5;
--		
--		up <= '0';
--		re <= '0';
--		wait for clk_period;
--		
--		up <= '1';
--		wait for clk_period*2;
--		
--		up <= '0';
--		re <= '1';

      wait;
   end process;

END;
