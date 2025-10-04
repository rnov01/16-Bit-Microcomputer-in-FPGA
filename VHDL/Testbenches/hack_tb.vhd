library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity hack_tb is
end hack_tb;

architecture test of hack_tb is

signal clk 						: std_logic 					:= '1';
signal rst : std_logic 			:= '1';
signal vga_hsync, vga_vsync 	: std_logic;
signal vga_r, vga_g, vga_b 		: std_logic_vector(7 downto 0);
signal blank 					: std_logic;
signal sync 					: std_logic := '0';
signal sel_7seg					: std_logic_vector(2 downto 0);
signal manual_clk				: std_logic;
signal clk_sel					: std_logic;
shared variable sim_end 		: boolean := false;



begin 

process
begin
	while sim_end = false loop
		clk <= not clk;
		wait for 10 ns;
	end loop;
	wait;
end process;

computer: entity work.hack
port map(
		clk => clk,
		clk_rst => '0',
		rst => rst,
		clk_sel => clk_sel,
		vga_hsync => vga_hsync, 
		vga_vsync => vga_vsync, 
		vga_r => vga_r, 
		vga_g => vga_g,
		vga_b => vga_b,
		blank => blank,					
		sync 	=> sync,
		sel_7seg => sel_7seg,
		manual_clk => manual_clk);					
stimulus: 
	process begin
	  rst <= '1';
	  wait for 10 us;
	  rst <= '0';
	  
	   
	
		wait for 10000 ms;
		
		sim_end := true;
		wait;
	end process;
end test;