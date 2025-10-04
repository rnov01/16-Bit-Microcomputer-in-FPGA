library ieee;
use ieee.std_logic_1164.all;

entity not_16 is 
	port(
		input  : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0));
end not_16;

architecture behavioral of not_16 is
begin
	output(15 downto 0) <= not input(15 downto 0);
end behavioral;