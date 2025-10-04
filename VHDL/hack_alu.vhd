library ieee;
use ieee.std_logic_1164.all;

entity hack_alu is
	port(
		x, y 				  : in std_logic_vector(15 downto 0) := "0000000000000000";
		zx, nx, zy, ny, f, no : in std_logic;
		output 				  : out std_logic_vector(15 downto 0);
		zr, ng 				  : out std_logic);
end hack_alu;

architecture behavior of hack_alu is

signal x_zero_out 	: std_logic_vector(15 downto 0);
signal not_x		: std_logic_vector(15 downto 0);
signal x_out 		: std_logic_vector(15 downto 0);
signal y_zero_out 	: std_logic_vector(15 downto 0);
signal not_y		: std_logic_vector(15 downto 0);
signal y_out 		: std_logic_vector(15 downto 0);
signal sum_xy 		: std_logic_vector(15 downto 0);
signal and_xy 		: std_logic_vector(15 downto 0);
signal f_out 		: std_logic_vector(15 downto 0);
signal not_f_out 	: std_logic_vector(15 downto 0);
signal final_out 	: std_logic_vector(15 downto 0);
signal not_zr_out 	: std_logic;

begin 

	not16_not_x : entity work.not_16
		port map(
			input  => x_zero_out,
			output => not_x);

	x_zero : process(zx)
	begin 
	
	case zx is
		when '0' =>
			x_zero_out <= x;
		when '1' =>
			x_zero_out <= (others => '0');
		when others =>
			null;
	end case;
	end process;
	
	x_not: process(nx, x_zero_out, not_x)
	begin
	case nx is
		when '0' =>
			x_out <= x_zero_out;
		when '1' =>
			x_out <= not_x;
		when others =>
			null;
	end case;
	end process;

	
	not16_not_y : entity work.not_16
		port map(
			input => y_zero_out,
			output => not_y);
	
	y_zero : process(zy)
	begin 
	case zy is
		when '0' =>
			y_zero_out <= y;
		when '1' =>
			y_zero_out <= (others => '0');
		when others =>
			null;
	end case;
	end process;
	
	y_not: process(ny, y_zero_out, not_y)
	begin
	
	case ny is
		when '0' =>
			y_out <= y_zero_out;
		when '1' =>
			y_out <= not_y;
		when others =>
			null;
	end case;
	end process;

------------------------------------------------
--implements add/and function for x and y
--mux_f determines which operation is performed
--base on f control bit
------------------------------------------------		
	add16_xy : entity work.adder_16
		port map(
			a => x_out,
			b => y_out,
			output => sum_xy);
			
	and16_xy : entity work.and_16
		port map(
			a => x_out,
			b => y_out,
			output => and_xy);
			
	op_sel: process(f, and_xy, sum_xy)
	begin
	
	case f is 
		when '0' =>
			f_out <= and_xy;
		when '1' =>
			f_out <= sum_xy;
		when others =>
			f_out <= (others => 'X');
	end case;
	end process; 
			

------------------------------------------------
--bitwise not performed on f_out
--mux selects if f_out or negated f_out is seen 
--	at output based on 'no' control bit
------------------------------------------------	
	not16_out : entity work.not_16
		port map(
			input => f_out,
			output => not_f_out);
			
	inv_out: process(no, f_out, not_f_out)
	begin 
	
	case no is 
		when '0' =>
			final_out <= f_out;
		when '1' => 
			final_out <= not_f_out;
		when others => 
			final_out <= (others => 'X');
	end case;
	end process; 
		
			
output <= final_out;

------------------------------------------------
--output signal is used to trigger zr and ng 
--	output flags
------------------------------------------------

	or_zr : entity work.or_16way
		port map(
			a => final_out,
			output => not_zr_out);
		
	zr <= not not_zr_out;
	
	ng <= final_out(15);
			
			
end behavior;