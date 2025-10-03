library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity display_map is

	generic(
		addr_width : integer := 15;
		word_width : integer :=16);

	port ( 
		vga_clk 			: in std_logic;
		screen_in			: in std_logic_vector(15 downto 0);
		strobe_addr			: out std_logic_vector(12 downto 0) := "0000000000000";
		r_out, g_out, b_out : out std_logic_vector(7 downto 0));
		
end display_map;

architecture behavior of display_map is

signal h_pos, v_pos 		: integer := 0;
signal x, y 				: integer := 0;
signal row_pos 				: integer:= 0;
signal current_address_int 	: integer;
signal base_addr_int 		: integer := 16384;
signal pos_index 			: integer := 0;
signal data_out 			: std_logic;
signal reg_count 			: integer:= 0;
signal reg_out 				: std_logic_vector(15 downto 0);


begin

--keep track of vga hor and vert counts
	vga_sync:
	process(vga_clk)
	begin
	
		if rising_edge(vga_clk) then
			
			if (h_pos < 799) then
				h_pos <= h_pos+1;
			else
				h_pos <= 0;
				if (v_pos < 524) then
					v_pos <= v_pos+1;
				else 
					v_pos <= 0;
				end if;
			end if;
		end if;	
	end process;
	
	
	screen_count:
	process(vga_clk)
	begin
	
		if rising_edge(vga_clk) then
			
			if ((h_pos >= 64) and (h_pos <576)) and ((v_pos >= 112) and (v_pos < 368))  then 
				if x < 511 then
					x <= x+1;
					if pos_index < 15 then
						pos_index <= pos_index +1;
					else
						pos_index <= 0;
					end if;
					
					if (x = 0) or (((x+1) mod 16) = 0) then
						row_pos <= row_pos+1;
					end if;
					
					if pos_index = 15 or x = 510 then
						reg_count <= reg_count +1;
					end if;

				else
					x <= 0;
					row_pos <= 0;
					pos_index <= 0;

					if y < 255 then
						y <= y+1;
					else 
						y <= 0;
						reg_count <= 0;
					end if;
				end if;
			end if;
			
			strobe_addr <= std_logic_vector(to_unsigned(reg_count, 13));
		
		end if;
	end process;
	
	display_data:
	process(vga_clk)
	begin
		
		if rising_edge(vga_clk) then 

			if ((x > 0) and (x < 511)) and ((y > 0) and (y < 255)) then
				if pos_index >= 2 then
					data_out <= screen_in(pos_index-2);
				elsif pos_index = 0 then
					data_out <= screen_in(14);
				elsif pos_index = 1 then
					data_out <= screen_in(15);
				end if;
				
				r_out <= (others => data_out);
				g_out <= (others => data_out);
				b_out <= (others => data_out);
			else
				r_out <= (others => '0');
				g_out <= (others => '0');
				b_out <= (others => '0');
			end if;
		end if;
	end process;
end behavior;


			
			