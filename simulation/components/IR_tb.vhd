LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY IR_tb IS
END IR_tb;
 
ARCHITECTURE behavior OF IR_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IR
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         di : IN  std_logic_vector(15 downto 0);
         opc : OUT  std_logic_vector(4 downto 0);
         Rd : OUT  std_logic_vector(3 downto 0);
         Rs : OUT  std_logic_vector(3 downto 0);
         we : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal di : std_logic_vector(15 downto 0) := (others => '0');
   signal we : std_logic := '0';

 	--Outputs
   signal opc : std_logic_vector(4 downto 0);
   signal Rd : std_logic_vector(3 downto 0);
   signal Rs : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IR PORT MAP (
          rst => rst,
          clk => clk,
          di => di,
          opc => opc,
          Rd => Rd,
          Rs => Rs,
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
		di <= x"6A54";
      wait for clk_period;
		
		we <= '0';
		wait for clk_period*2;
		
		di <= x"97BC";
		wait for clk_period;

		wait for clk_period;

		
      wait;
   end process;

END;
