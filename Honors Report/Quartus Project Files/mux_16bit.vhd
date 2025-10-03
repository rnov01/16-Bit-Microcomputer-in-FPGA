library ieee;
use ieee.std_logic_1164.all;

entity mux_16bit is
	port(
		a, b   : in std_logic_vector(15 downto 0);
		sel    : in std_logic;
		output : out std_logic_vector(15 downto 0));
		
end mux_16bit;

architecture behavior of mux_16bit is
begin 
	
	mux0 : entity work.mux_2bit
		port map(
			a 	=> a(0),
			b 	=> b(0),
			sel => sel,
			x 	=> output(0));
			
	mux1 : entity work.mux_2bit
		port map(
			a 	=> a(1),
			b 	=> b(1),
			sel => sel,
			x 	=> output(1));
			
	mux2 : entity work.mux_2bit
		port map(
			a 	=> a(2),
			b 	=> b(2),
			sel => sel,
			x 	=> output(2));
			
	mux3 : entity work.mux_2bit
		port map(
			a 	=> a(3),
			b 	=> b(3),
			sel => sel,
			x 	=> output(3));
			
	mux4 : entity work.mux_2bit
		port map(
			a 	=> a(4),
			b 	=> b(4),
			sel => sel,
			x 	=> output(4));
			
	mux5 : entity work.mux_2bit
		port map(
			a 	=> a(5),
			b 	=> b(5),
			sel => sel,
			x 	=> output(5));
			
	mux6 : entity work.mux_2bit
		port map(
			a 	=> a(6),
			b 	=> b(6),
			sel => sel,
			x 	=> output(6));
			
	mux7 : entity work.mux_2bit
		port map(
			a 	=> a(7),
			b 	=> b(7),
			sel => sel,
			x 	=> output(7));
			
	mux8 : entity work.mux_2bit
		port map(
			a 	=> a(8),
			b 	=> b(8),
			sel => sel,
			x 	=> output(8));
			
	mux9 : entity work.mux_2bit
		port map(
			a 	=> a(9),
			b 	=> b(9),
			sel => sel,
			x 	=> output(9));
			
	mux10 : entity work.mux_2bit
		port map(
			a 	=> a(10),
			b 	=> b(10),
			sel => sel,
			x 	=> output(10));
			
	mux11 : entity work.mux_2bit
		port map(
			a 	=> a(11),
			b 	=> b(11),
			sel => sel,
			x 	=> output(11));
			
	mux12 : entity work.mux_2bit
		port map(
			a 	=> a(12),
			b 	=> b(12),
			sel => sel,
			x 	=> output(12));
			
	mux13 : entity work.mux_2bit
		port map(
			a 	=> a(13),
			b 	=> b(13),
			sel => sel,
			x 	=> output(13));
			
	mux14 : entity work.mux_2bit
		port map(
			a 	=> a(14),
			b 	=> b(14),
			sel => sel,
			x 	=> output(14));
			
	mux15 : entity work.mux_2bit
		port map(
			a 	=> a(15),
			b 	=> b(15),
			sel => sel,
			x 	=> output(15));		
end behavior;