LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SP_tb IS
END SP_tb;
 
ARCHITECTURE behavior OF SP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SP
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         do : OUT  std_logic_vector(15 downto 0);
         re : IN  std_logic;
         up : IN  std_logic;
         down : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal re : std_logic := '0';
   signal up : std_logic := '0';
   signal down : std_logic := '0';

 	--Outputs
   signal do : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ps;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SP PORT MAP (
          rst => rst,
          clk => clk,
          do => do,
          re => re,
          up => up,
          down => down
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
      wait for 10 ps;	
		
		rst <= '0';
		down <= '1';
		wait for clk_period*256;
		
		re <= '1';
		down <= '0';
		
      wait;
   end process;

END;
