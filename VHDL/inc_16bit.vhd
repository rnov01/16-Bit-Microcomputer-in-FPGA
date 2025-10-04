library ieee;
use ieee.std_logic_1164.all;

entity inc_16bit is
	port(
		input  : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0));
end inc_16bit;

architecture behavior of inc_16bit is
begin
	adder : entity work.adder_16
		port map(
			a 				=> input,
			b(0) 			=> '1',
			b(15 downto 1) 	=> (others =>'0'),
			output 			=> output);
end behavior;