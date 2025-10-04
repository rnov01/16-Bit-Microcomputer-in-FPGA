library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture test of alu_tb is

signal zx, nx, zy, ny, f, no : std_logic := '0';
signal x, y : std_logic_vector(15 downto 0) := (others => '0');

signal alu_output : std_logic_vector(15 downto 0);
signal zr_out : std_logic;
signal ng_out : std_logic;
shared variable sim_end : boolean := false;

begin


	
	test : entity work.hack_alu
		port map(
			x => x,
			y => y,
			zx => zx, 
			zy => zy,			
			nx => nx, 
			ny => ny, 
			f => f,
			no => no,
			output => alu_output,
			zr => zr_out,
			ng => ng_out);
			
			
	stimulus:
	process begin
	sim_end := false;
	
	x <= (others => '0');
	y <= (others => '0');
	zx <= '0';
	zy <='0';
	nx <= '0';
	ny <= '0';
	f <= '0';
	no <= '0';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='0';
	zy <= '1';
	ny <= '0';
	f <= '1';
	no <= '0';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='1';
	zy <= '1';
	ny <= '1';
	f <= '1';
	no <= '1';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='1';
	zy <= '1';
	ny <= '0';
	f <= '1';
	no <= '0';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '0';
	nx <='0';
	zy <= '1';
	ny <= '1';
	f <= '0';
	no <= '0';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='1';
	zy <= '0';
	ny <= '0';
	f <= '0';
	no <= '0';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '0';
	nx <='0';
	zy <= '1';
	ny <= '1';
	f <= '0';
	no <= '1';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='1';
	zy <= '0';
	ny <= '0';
	f <= '0';
	no <= '1';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '0';
	nx <='1';
	zy <= '1';
	ny <= '1';
	f <= '1';
	no <= '1';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '1';
	nx <='1';
	zy <= '0';
	ny <= '1';
	f <= '1';
	no <= '1';
	
	wait for 2 ns;
	
	x <= (others => '0');
	y <= (others => '1');
	zx <= '0';
	nx <='0';
	zy <= '1';
	ny <= '1';
	f <= '1';
	no <= '0';
	
	
	
	sim_end := true;
	wait;
	
	end process stimulus;
end test;	
	