--==================================================
-- Top Module maps all subcomponents together
--==================================================
library ieee;
use ieee.std_logic_1164.all;

entity hack is
port(
		clk, rst, clk_rst		: in std_logic;
		clk_25 					: out std_logic;
		manual_clk				: in std_logic;
		vga_hsync, vga_vsync 	: out std_logic;
		vga_r, vga_g, vga_b 	: out std_logic_vector(7 downto 0);
		blank 					: out std_logic;
		sync 					: out std_logic := '0';
		clk_8_out				: out std_LOGIC;
		clk_25_out				: out std_LOGIC;
		gnd 					: out std_LOGIC;
		sel_7seg 				: in std_logic_vector(2 downto 0);
		clk_sel					: in std_logic := '0';
		ld_ram, ld_screen 		: out std_logic;
		disp_out	 			: out std_logic_vector(27 downto 0);
		d_ld_flag, a_ld_flag, 
		z_flag, n_flag  		: out std_logic);
end hack;

architecture behavior of hack is

component hack_cpu is 
	port(
		inM, instruction 	 : in std_logic_vector(15 downto 0);
		rst, clk			 : in std_logic;
		outM  				 : out std_logic_vector(15 downto 0);
		addressM, pc 		 : out std_logic_vector(14 downto 0);
		writeM				 : out std_logic);
end component;

component vga is

	port(
		clk_50mhz 			: in std_logic;
		clk_25mhz 			: out std_logic;
		vga_hsync, vga_vsync: out std_logic;
		r, g, b 			: in std_logic_vector(7 downto 0);
		vga_r, vga_g, vga_b : out std_logic_vector(7 downto 0);
		blank 				: out std_logic;
		sync 				: out std_logic := '0');
		
end component;

component display_map is

	generic(
		addr_width : integer := 15;
		word_width : integer :=16);

	port ( 
		vga_clk 			  : in std_logic;
		current_address 	  : in std_logic_vector(addr_width-1 downto 0);
		ram_data  		 	  : std_logic_vector(word_width-1 downto 0);
		r_out, g_out, b_out   : out std_logic_vector(7 downto 0));
		
end component;

component instruction_ram
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

component clk_8Mhz_0002 is
	port (
		refclk   : in  std_logic := 'X'; -- clk
		rst      : in  std_logic := 'X'; -- reset
		outclk_0 : out std_logic;        -- clk
		locked   : out std_logic         -- export
	);
end component clk_8Mhz_0002;
	
component debug is
	port(
		sel 			  : in std_logic_vector(2 downto 0);
		ld_ram, ld_screen : out std_logic;
		ld_rin, ld_sin 	  : in std_logic;
		addr_in, pc_in 	  : in std_logic_vector(14 downto 0);
		mem_in 			  : in std_logic_vector(15 downto 0);
		d_in, a_in 		  : in std_logic_vector(15 downto 0);
		instr_in       	  : in std_logic_vector(15 downto 0);
		disp_out	 	  : out std_logic_vector(27 downto 0));
end component;

signal clk_8mhz				: std_logic;
signal vga_clk 				: std_logic;
signal r, g, b 				: std_logic_vector(7 downto 0);
signal next_instruction 	: std_logic_vector(14 downto 0);
signal current_instruction  : std_logic_vector(15 downto 0);

signal inM 					: std_logic_vector(15 downto 0);
signal outM 				: std_logic_vector(15 downto 0);
signal addressM 			: std_logic_vector(14 downto 0);
signal writeM 				: std_logic;


signal alu_out 				: std_logic_vector(15 downto 0);

signal display_addr 		: std_logic_vector(12 downto 0);
signal display_data 		: std_logic_vector(15 downto 0);
signal vga_b_sig    		: std_LOGIC_VECTOR(7 downto 0);
signal screen_flag, 
		 ram_flag 			: std_logic;
signal d_reg_sig, 
		 a_reg_sig 			: std_logic_vector(15 downto 0);
signal cpu_clk 				: std_logic;

begin 
	
	clk_25 <= vga_clk;
	gnd <= '0';
	clk_8_out <= clk_8mhz;
	clk_25_out <= vga_clk;
	vga_b <= vga_b_sig;
	
	with clk_sel select cpu_clk <=
		clk_8mhz when '0',
		manual_clk when '1',
		'X' when others;
	
	clk_8mhz_inst : component clk_8Mhz_0002
		port map (
			refclk   => clk,   --  refclk.clk
			rst      => '0',      --   reset.reset
			outclk_0 => clk_8mhz, -- outclk0.clk
			locked   => open      -- (terminated)
		);
			
	cpu : hack_cpu
		port map(
			inM 		=> inM,
			instruction => current_instruction,
			rst 		=> rst, 
			clk 		=> cpu_clk,			
			outM 		=> outM, 
			addressM 	=> addressM, 
			pc 			=> next_instruction,
			writeM 		=> writeM,
			d_reg_ext 	=> d_reg_sig,
			a_reg_ext 	=> a_reg_sig,
			d_ld_flag	=> d_ld_flag,
			a_ld_flag 	=> a_ld_flag,
			z_flag 		=> z_flag,
			n_flag 		=> n_flag);
			
	vga_decode: display_map
		generic map(
			addr_width => 15,
			word_width => 16)
		port map(
			vga_clk 	=> vga_clk,
			screen_in 	=> display_data,
			strobe_addr => display_addr,
			r_out 		=> r, 
			g_out 		=> g, 
			b_out 		=> b);
	vga_output: vga
		port map( 
			clk_50mhz => clk,
			clk_25mhz => vga_clk,
			vga_hsync => vga_hsync, 
			vga_vsync => vga_vsync,
			r 		  => r, 
			g 		  => g,
			b 		  => b,
			vga_r 	  => vga_r, 
			vga_g 	  => vga_g, 
			vga_b 	  => vga_b_sig, 
			blank 	  => blank,
			sync 	  => sync);
			
	memory: entity work.hack_mem2
		port map( 
			data_in 	 => outM,  
			data_out 	 => inM,
			addr 		 => addressM,
			display_addr => display_addr,
			display 	 => display_data,
			ld 			 => writeM,
			clk_8 		 => clk_8mhz,
			clk_25 		 => vga_clk,
			screen_flag  => screen_flag,
			ram_flag 	 => ram_flag);
			
	instruction_ram_inst : instruction_ram PORT MAP (
		address	 => next_instruction,
		clock	 => clk_8mhz,
		data	 => (others => '0'),
		wren	 => '0',
		q	 	 => current_instruction
	);
	
	debug_display: debug
		port map(
			sel 	  => sel_7seg,
			ld_ram 	  => ld_ram,
			ld_screen => ld_screen,
			ld_rin 	  => ram_flag,
			ld_sin 	  => screen_flag,
			addr_in   => addressM,
			pc_in 	  => next_instruction,
			mem_in    => inM,
			instr_in  => current_instruction,
			d_in      => d_reg_sig,
			a_in 	  => d_reg_sig,
			disp_out  => disp_out);
			
end behavior; 