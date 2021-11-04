LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY decoder_4x16_tb IS
END decoder_4x16_tb;
 
ARCHITECTURE behavior OF decoder_4x16_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder_4x16
    PORT(
         X : IN  std_logic_vector(3 downto 0);
         Y : OUT  std_logic_vector(15 downto 0);
         en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal X : std_logic_vector(3 downto 0) := (others => '0');
   signal en : std_logic := '0';

 	--Outputs
   signal Y : std_logic_vector(15 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder_4x16 PORT MAP (
          X => X,
          Y => Y,
          en => en
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      
      wait for 10 ns;

      en <= '1';
		X <= x"0";
		wait for 10 ns;
		X <= x"1";
		wait for 10 ns;
		X <= x"2";
		wait for 10 ns;
		X <= x"3";
		wait for 10 ns;
		X <= x"4";
		wait for 10 ns;
		X <= x"5";
		wait for 10 ns;
		X <= x"6";
		wait for 10 ns;
		X <= x"7";
		wait for 10 ns;
		X <= x"8";
		wait for 10 ns;
		X <= x"9";
		wait for 10 ns;
		X <= x"A";
		wait for 10 ns;
		X <= x"B";
		wait for 10 ns;
		X <= x"C";
		wait for 10 ns;
		X <= x"D";
		wait for 10 ns;
		X <= x"E";
		wait for 10 ns;
		X <= x"F";
		
      wait;
   end process;

END;
