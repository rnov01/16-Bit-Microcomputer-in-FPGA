library ieee;
use ieee.std_logic_1164.all;

entity mux_2bit is
	port(
		a, b, sel 	 : in std_logic;
		x 			 : out std_logic);
end mux_2bit;

architecture behavior of mux_2bit is
begin
		process(sel)
		begin
			case sel is
				when '0' 	=> x <= a;
				when '1' 	=> x <= b;
				when others => null;
			end case;
		end process;
end behavior;