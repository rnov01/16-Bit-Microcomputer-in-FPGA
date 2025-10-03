library ieee;
use ieee.std_logic_1164.all;

entity hack_mem is
	port( 
		data_in  			  : in std_logic_vector(15 downto 0);
		data_out 			  : out std_logic_vector(15 downto 0);
		addr 				  : in std_logic_vector(14 downto 0);
		display_addr 		  : in std_logic_vector(12 downto 0);
		display 			  : out std_logic_vector(15 downto 0);
		ld, clk_8, clk_25 	  : in std_logic;
		screen_flag, ram_flag : out std_logic);
end hack_mem;

architecture behavior of hack_mem is

signal enable 			 : std_logic := '1';
signal ram_out 			 : std_logic_vector(15 downto 0);
signal screen_out 		 : std_logic_vector(15 downto 0);
signal k_in 			 : std_logic_vector(15 downto 0);
signal k_out 			 : std_logic_vector(15 downto 0);
signal ram_ld, screen_ld : std_logic := '0';

component base_ram
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

component screen_ram2port
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		clock_a			: IN STD_LOGIC  := '1';
		clock_b			: IN STD_LOGIC  := '1';
		data_a			: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data_b			: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren_a			: IN STD_LOGIC  := '0';
		wren_b			: IN STD_LOGIC  := '0';
		q_a				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b				: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;



begin

	ram16k: base_ram
		port map(
			clock	    => clk_8,
			wren 		=> ram_ld,
			address(0)  => addr(0),
			address(1)  => addr(1),
			address(2)  => addr(2),
			address(3)  => addr(3),
			address(4)  => addr(4),
			address(5)  => addr(5),
			address(6)  => addr(6),
			address(7)  => addr(7),
			address(8)  => addr(8),
			address(9)  => addr(9),
			address(10) => addr(10),
			address(11) => addr(11),
			address(12) => addr(12),
			address(13) => addr(13),
			data 		=> data_in,
			q 			=> ram_out);
			
	--data_b unused, addr_a interfaces with cpu, addr_b with screen		

	screen: screen_ram2port
		port map(
			clock_a 	  => clk_8,
			clock_b 	  => clk_25,
			wren_a 		  => screen_ld,
			wren_b 		  => '0',
			address_a(0)  => addr(0),
			address_a(1)  => addr(1),
			address_a(2)  => addr(2),
			address_a(3)  => addr(3),
			address_a(4)  => addr(4),
			address_a(5)  => addr(5),
			address_a(6)  => addr(6),
			address_a(7)  => addr(7),
			address_a(8)  => addr(8),
			address_a(9)  => addr(9),
			address_a(10) => addr(10),
			address_a(11) => addr(11),
			address_a(12) => addr(12),
			address_b 	  => display_addr,
			data_a 		  => data_in,
			data_b 		  => (others => '0'),
			q_a 		  => screen_out,
			q_b		      => display);
			
	keyboard: entity work.reg_generic
		generic map(
			bus_width => 16)
		port map(
			clk		 => clk_8,
			ld 		 => '0',
			rst 	 => '0',
			data_in  => k_in,
			data_out => k_out);
			
			
	with addr(14) select ram_ld <=
		ld  when '0',
		'0' when '1',
		'X' when others;
		
	with addr(14) select screen_ld <= 
		'0' when '0',
		ld  when '1', 
		'X' when others;
		

	with addr(14 downto 13) select data_out <=
		ram_out when "00",
		ram_out when "01",
		screen_out when "10",
		k_out when "11",
		(others => 'X') when others;
	
--flags passed to output leds for troubleshooting	
	ram_flag <= ram_ld;
	screen_flag <= screen_ld;
				
end behavior;
	