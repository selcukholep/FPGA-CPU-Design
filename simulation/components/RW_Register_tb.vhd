LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RW_Register_tb IS
END RW_Register_tb;
 
ARCHITECTURE behavior OF RW_Register_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RW_Register
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         data : INOUT  std_logic_vector(15 downto 0);
         re : IN  std_logic;
         we : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal re : std_logic := '0';
   signal we : std_logic := '0';

 	--BiDirs
   signal data : std_logic_vector(15 downto 0) := (others => 'Z');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RW_Register PORT MAP (
          rst => rst,
          clk => clk,
          data => data,
          re => re,
          we => we
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
		data <= x"6A54";
      wait for clk_period;
		
		we <= '0';
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;
		
		re <= '1';
		wait for clk_period;
		
		re <= '0';
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;
		
		re <= '1';
		
      wait;
   end process;

END;
