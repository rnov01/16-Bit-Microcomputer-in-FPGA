library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
	port(
		a, b, cin : in std_logic;
		sum, carry : out std_logic);
end full_adder; 

architecture behavior of full_adder is 

signal half_carry : std_logic;
signal half_sum   : std_logic;
signal full_carry : std_logic;

begin

	half_adder_1 : entity work.half_adder
		port map(
			a => a,
			b => b,
			sum => half_sum,
			carry => half_carry);
	half_adder_2 : entity work.half_adder
		port map(
			a => half_sum,
			b => cin,
			sum => sum,
			carry => full_carry);
			
	carry <= full_carry or half_carry;

end behavior;
			
			
			