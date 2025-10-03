library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb;

architecture test of cpu_tb is

signal clk : std_logic := '1';
signal rst : std_logic := '1';

signal instruction : std_logic_vector(15 downto 0);
signal inM : std_logic_vector(15 downto 0);
signal outM :std_logic_vector(15 downto 0);
signal pc : std_logic_vector(14 downto 0);
signal addressM : std_logic_vector(14 downto 0);
signal writeM : std_logic;
shared variable sim_end : boolean := false;

begin

process
begin
	while sim_end = false loop
		clk <= not clk;
		wait for 1 ns;
	end loop;
	wait;
end process;
	
	
	test : entity work.hack_cpu
		port map(
			inM => inM,
			instruction => instruction,
			rst => rst, 
			clk => clk,			
			outM => outM, 
			addressM => addressM, 
			pc => pc,
			writeM => writeM);
			
			
	stimulus:
	process begin
	--rst <= '1', '0' after 1 ns;
	rst <= '0';
	wait until (rst = '0');
	
	inM <= (others => '0');
	
	instruction <= "0011000000111001";
	wait for 2 ns;
	instruction <= "1110110000010000";
	wait for 2 ns;
	instruction <= "0101101110100000";
	wait for 2 ns;
	instruction <= "1110000111110000";
	wait for 2 ns;
	instruction <= "0000001111101011";
	wait for 2 ns;
	instruction <= "1110001100001000";
	wait for 2 ns;
	instruction <= "0000001111101100";
	wait for 2 ns;
	instruction <= "1111010011110000";
	inM <= std_logic_vector(to_unsigned(11111, 16));
	
	sim_end := true;
	wait;
	
	end process stimulus;
end test;	
	