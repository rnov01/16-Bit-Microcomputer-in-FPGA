library ieee;
use ieee.std_logic_1164.all;

entity reg_generic is
	generic(
		bus_width : integer := 16);
		
	port(
		data_in 		  : in std_logic_vector(bus_width-1 downto 0);
		clk, ld, rst  : in std_logic;
		data_out		  : out std_logic_vector(bus_width-1 downto 0));
end reg_generic;

architecture behavior of reg_generic is


begin
	process(clk, rst)
	
	--variable d_out : std_logic_vector(bus_width-1 downto 0);
	
	begin
		if (rst = '1') then
			data_out <= (others => '0');
		elsif falling_edge(clk) then
			if (ld = '1') then
				--d_out := data_in;
				data_out <= data_in;
			end if;
		end if;
	--data_out <= d_out;
	end process;
end behavior;
