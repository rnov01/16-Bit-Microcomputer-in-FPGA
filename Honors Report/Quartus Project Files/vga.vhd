library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is

	port(
		clk_50mhz 				: in std_logic;
		clk_25mhz 				: out std_logic;
		vga_hsync, vga_vsync 	: out std_logic;
		r, g, b 				: in std_logic_vector(7 downto 0);
		vga_r, vga_g, vga_b 	: out std_logic_vector(7 downto 0);
		blank 					: out std_logic;
		sync 					: out std_logic := '0');
		
end vga;


architecture behavior of vga is

signal rst 		: std_logic:='0';
signal clk_vga  : std_logic;

    component pll is
        port (
            clk_25_clk : out std_logic;        -- clk
            clk_in_clk : in  std_logic := 'X'; -- clk
            rst_reset  : in  std_logic := 'X'  -- reset
        );
    end component pll;


component vga_sync is
	port(
		clk 				: in std_logic;
		h_sync, v_sync 		: out std_logic;
		blank 				: out std_logic;
		r_in, g_in, b_in 	: in std_logic_vector(7 downto 0);
		vga_r, vga_g, vga_b : out std_logic_vector(7 downto 0));
		
end component;

begin
	
	 clock : component pll
        port map (
            clk_25_clk => clk_vga, -- clk_25.clk
            clk_in_clk => clk_50mhz, -- clk_in.clk
            rst_reset  => rst   --    rst.reset
        );

	sync : vga_sync
		port map(
			clk 	=> clk_vga,
			h_sync 	=> vga_hsync,
			v_sync 	=> vga_vsync,
			blank 	=> blank,
			r_in 	=> r,
			g_in	=> g,
			b_in 	=> b,
			vga_r 	=> vga_r,
			vga_g 	=> vga_g,
			vga_b 	=> vga_b);
			
	clk_25mhz <= clk_vga;
end behavior;
			


  