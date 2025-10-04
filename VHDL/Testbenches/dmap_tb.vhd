library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dmap_tb is
end dmap_tb;

architecture test of dmap_tb is

signal vga_clk : std_logic := '1';
signal current_address :  std_logic_vector(14 downto 0);
signal ram_data  : std_logic_vector(15 downto 0);
signal r_out, g_out, b_out :std_logic_vector(7 downto 0);
shared variable sim_end : boolean := false;

begin

process
begin
	while sim_end = false loop
		vga_clk <= not vga_clk;
		wait for 1 ns;
	end loop;
	wait;
end process;

dmap: entity work.display_map 
	generic map(
		addr_width => 15,
		word_width => 16)
	port map( 
		vga_clk => vga_clk,
		current_address => current_address,
		ram_data  => ram_data,
		r_out => r_out, 
		g_out => g_out, 
		b_out => b_out);
		
		
	stimulus: process
	begin
	
		current_address <= "100000000000000";
		ram_data <= "1111111111111111";
		
		wait for 5 ns;
		
		current_address <= "100000000000001";
		ram_data <= "1111111111111111";
		
		wait for 5 ns;
		
		current_address <= "100000000000011";
		ram_data <= "1111111111111111";
		
		wait for 10 us;
		
		sim_end := true;
		wait;
	end process;
		
		
		
		
		
end test;

