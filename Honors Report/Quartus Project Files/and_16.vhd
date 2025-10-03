-----------------------------------
--compares each corresponding bit
--performs AND operation
-----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity and_16 is 
	port(
		a, b   : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0));
end and_16;

architecture behavioral of and_16 is
begin
	output(15) <= a(15) and b(15);
	output(14) <= a(14) and b(14);
	output(13) <= a(13) and b(13);
	output(12) <= a(12) and b(12);
	output(11) <= a(11) and b(11);
	output(10) <= a(10) and b(10);
	output(9) <= a(9) and b(9);
	output(8) <= a(8) and b(8);
	output(7) <= a(7) and b(7);
	output(6) <= a(6) and b(6);
	output(5) <= a(5) and b(5);
	output(4) <= a(4) and b(4);
	output(3) <= a(3) and b(3);
	output(2) <= a(2) and b(2);
	output(1) <= a(1) and b(1);
	output(0) <= a(0) and b(0);
end behavioral;