library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
	port( 
		rst, ld, clk, inc : in std_logic :='0';
		input	  		  : in std_logic_vector(15 downto 0);
		output  		  : out std_logic_vector(15 downto 0));
end program_counter;

architecture behavior of program_counter is

signal count 	  : integer range 0 to 65535 := 0;
signal count_last : integer range 0 to 65535 := 0;

begin
	

	process(rst, clk)
	begin
		count_last <= count;
		if rising_edge(clk) then 
			if (rst = '1') then
				count <= 0;
				output <= (others => '0');
			elsif (ld = '1') then
				count <= to_integer(unsigned(input));
			elsif (inc = '1') then
				if (count = 65535) then
					count <= 0;
				else
					count <= count+1;
				end if;
			else
				count <= count_last;
			end if;
				
		end if;
	output <= std_logic_vector(to_unsigned(count, 16));	
	end process;
	
end behavior;
		