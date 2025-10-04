library ieee;
use ieee.std_logic_1164.all;

entity program_counter_tb is
end program_counter_tb;

architecture test of program_counter_tb is

signal clk : std_logic := '0';
signal rst : std_logic := '1';
signal ld : std_logic := '0';
signal inc : std_logic := '0';

signal input : std_logic_vector(15 downto 0) := (others => '0');
signal output :std_logic_vector(15 downto 0);

begin

	clk <= not clk after 1 ns;
	--rst <= '1', '0' after 3 ns;
	
	test : entity work.program_counter
		port map(
			input => input,
			rst => rst, 
			clk => clk,	
			ld => ld,
			inc => inc,
			output => output);
			
			
	stimulus:
	process begin
	rst <= '1', '0' after 3 ns;
	wait until (rst = '0');
	
	wait for 1 ns;
	inc <= '1';
	wait for 4 ns;
	input <= "1111111111111111";
	wait for 4 ns;
	ld <= '1';
	wait for 2 ns;
	ld <= '0';
	wait for 4 ns;
	ld <= '1';
	inc <= '0';
	wait for 2 ns;
	rst <= '1';
	wait;
	
	
	end process stimulus;
end test;	
	