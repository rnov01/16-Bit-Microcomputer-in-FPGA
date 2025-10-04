library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga_sync is 
	port(
		clk 				: in std_logic;
		h_sync, v_sync  	: out std_logic;
		blank 				: out std_logic;
		r_in, g_in, b_in 	: in std_logic_vector(7 downto 0);
		vga_r, vga_g, vga_b : out std_logic_vector(7 downto 0));
		
end vga_sync;

architecture behavior of vga_sync is 
	
	--horizontal and vertical screen position
	signal h_pos		: integer range 0 to 800:=0;
	signal v_pos		: integer range 0 to 525:=0;
	
	constant h_disp 	: integer := 639;
	constant h_fporch 	: integer := 16;
	constant h_spulse 	: integer := 96;
	constant h_bporch 	: integer := 48;
	
begin

	process(clk)
	begin
		
		if rising_edge(clk) then
		
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
			
			if (h_pos >= 654) and (h_pos < 750) then 
				h_sync <= '0';
			else 
				h_sync <= '1';
			end if;
			
			if (v_pos >= 488) and (v_pos < 490) then
				v_sync <= '0';
			else 
				v_sync <= '1';
			end if;	
		end if;
	end process;
	
	
--send input pixel data to output during visible region of cycle	
	draw: process(clk)
	begin
		if rising_edge(clk) then
			if (h_pos >= 0 and h_pos < 639) and (v_pos >= 0 and v_pos < 479) then
				vga_r <= r_in;
				vga_g <= g_in;
				vga_b <= b_in;
				blank <= '1';
			else
				vga_r <= (others => '0');
				vga_g <= (others => '0');
				vga_b <= (others => '0');
				blank <= '0';
			end if;
		end if;
	end process;
end behavior;