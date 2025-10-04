library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity hack_memory_tb is
end hack_memory_tb;

architecture test of hack_memory_tb is

component hack_mem2 is
	port( 
		data_in  : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0);
		addr 		: in std_logic_vector(14 downto 0);
		display_addr : in std_logic_vector(12 downto 0);
		display : out std_logic_vector(15 downto 0);
		ld, clk 	: in std_logic);
end component;

signal data_in : std_logic_vector(15 downto 0);
signal data_out: std_logic_vector(15 downto 0);
signal addr		: std_logic_vector(14 downto 0);
signal display_addr: std_logic_vector(12 downto 0);
signal display : std_logic_vector(15 downto 0);
signal ld, clk : std_logic;
shared variable sim_end : boolean := false;

begin

memory: hack_mem2
	port map(
		data_in => data_in,
		data_out => data_out,
		addr => addr,
		display_addr => display_addr,
		display => display,
		ld => ld,
		clk => clk);
		

	process
	begin
		while sim_end = false loop
			clk <= not clk;
			wait for 20 ns;
		end loop;
		wait;
	end process;
	
	
	stimulus: process
	begin
		display_addr <= "0000000000001";
		data_in <= "1111000011110000";
		ld <= '1';
		addr <= "000000000000001";
		
		wait for 120 ns;
		
		addr <= "000000000000010";
		
		wait for 120 ns;
		
		ld <= '0';
		
		wait for 120 ns;
		
		addr <= "000000000000001";
		
		wait for 120 ns;
		
		sim_end := true;
		wait;
		
	end process;
end test;