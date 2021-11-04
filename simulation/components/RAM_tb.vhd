LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RAM_tb IS
END RAM_tb;
 
ARCHITECTURE behavior OF RAM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAM
    PORT(
         clk : IN  std_logic;
			rst : IN	std_logic;
         we : IN  std_logic;
			re : IN	std_logic;
         a : IN  std_logic_vector(3 downto 0);
         data : INOUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
	signal rst : std_logic := '1';
   signal we : std_logic := '0';
	signal re : std_logic := '0';
   signal a : std_logic_vector(3 downto 0) := (others => '0');

 	--BiDirs
   signal data : std_logic_vector(15 downto 0) := (others => 'Z');

   -- Clock period definitions
   constant clk_period : time := 10 ps;
	
	SIGNAL STOP : STD_LOGIC := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          clk => clk,
			 rst => rst,
          we => we,
			 re => re,
          a => a,
          data => data
        );

   -- Clock process definitions
   clk_process :process
   begin
	
		if (STOP = '0') then
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		else
			wait;
		end if;
		
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ps;	
		
		rst <= '0';
		we <= '1';
		a <= "0000";
		data <= x"0F23";
      wait for clk_period;
		
		a <= "0001";
		data <= x"6C93";
		wait for clk_period;
		
		a <= "0010";
		data <= x"498A";
      wait for clk_period;
		
		a <= "0011";
		data <= x"34A7";
      wait for clk_period;
		
		a <= "0100";
		data <= x"C94E";
      wait for clk_period;
		
		a <= "0101";
		data <= x"CAA2";
      wait for clk_period;
		
		a <= "0110";
		data <= x"4E93";
		wait for clk_period;
		
		a <= "0111";
		data <= x"268A";
      wait for clk_period;
		
		a <= "1000";
		data <= x"36B9";
      wait for clk_period;
		
		a <= "1001";
		data <= x"F916";
      wait for clk_period;
		
		re <= '0';
		data <= "ZZZZZZZZZZZZZZZZ";
		wait for clk_period;

		re <= '1';
		we <= '0';
		a <= "0000";
		wait for clk_period;
		
		a <= "0001";
		wait for clk_period;
		
		a <= "0010";
		wait for clk_period;
		
		a <= "0011";
		wait for clk_period;
		
		a <= "0100";
		wait for clk_period;
		
		a <= "0101";
		wait for clk_period;
		
		a <= "0110";
		wait for clk_period;
		
		a <= "0111";
		wait for clk_period;
		
		a <= "1000";
		wait for clk_period;
		
		a <= "1001";
		wait for clk_period;
		
		re <= '0';
		wait for clk_period*2;
		
		re <= '1';
		a <= "1010";
		wait for clk_period;
		
		re <= '0';
		wait for clk_period;
		
		re <= '1';
		a <= "0010";
		wait for clk_period;
		
		re <= '0';
		data <= "ZZZZZZZZZZZZZZZZ";
		
		STOP <= '1';
		
      wait;
   end process;

END;
