library ieee;
use ieee.std_logic_1164.all;

entity adder_16 is
	port(
		a, b   : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(15 downto 0));
end adder_16;

architecture behavior of adder_16 is

signal c_0  : std_logic;
signal c_1  : std_logic;
signal c_2  : std_logic;
signal c_3  : std_logic;
signal c_4  : std_logic;
signal c_5  : std_logic;
signal c_6  : std_logic;
signal c_7  : std_logic;
signal c_8  : std_logic;
signal c_9  : std_logic;
signal c_10 : std_logic;
signal c_11 : std_logic;
signal c_12 : std_logic;
signal c_13 : std_logic;
signal c_14 : std_logic;
signal c_15 : std_logic;

begin

	add_0 : entity work.full_adder
		port map(
			a => a(0),
			b => b(0),
			cin => '0',
			sum => output(0),
			carry => c_0);
			
	add_1 : entity work.full_adder
		port map(
			a => a(1),
			b => b(1),
			cin => c_0,
			sum => output(1),
			carry => c_1);
			
	add_2 : entity work.full_adder
		port map(
			a => a(2),
			b => b(2),
			cin => c_1,
			sum => output(2),
			carry => c_2);
	
	add_3 : entity work.full_adder
		port map(
			a => a(3),
			b => b(3),
			cin => c_2,
			sum => output(3),
			carry => c_3);
			
	add_4 : entity work.full_adder
		port map(
			a => a(4),
			b => b(4),
			cin => c_3,
			sum => output(4),
			carry => c_4);
			
	add_5 : entity work.full_adder
		port map(
			a => a(5),
			b => b(5),
			cin => c_4,
			sum => output(5),
			carry => c_5);
			
	add_6 : entity work.full_adder
		port map(
			a => a(6),
			b => b(6),
			cin => c_5,
			sum => output(6),
			carry => c_6);
			
	add_7 : entity work.full_adder
		port map(
			a => a(7),
			b => b(7),
			cin => c_6,
			sum => output(7),
			carry => c_7);
			
	add_8 : entity work.full_adder
		port map(
			a => a(8),
			b => b(8),
			cin => c_7,
			sum => output(8),
			carry => c_8);
			
	add_9 : entity work.full_adder
		port map(
			a => a(9),
			b => b(9),
			cin => c_8,
			sum => output(9),
			carry => c_9);
			
	add_10 : entity work.full_adder
		port map(
			a => a(10),
			b => b(10),
			cin => c_9,
			sum => output(10),
			carry => c_10);
			
	add_11 : entity work.full_adder
		port map(
			a => a(11),
			b => b(11),
			cin => c_10,
			sum => output(11),
			carry => c_11);
			
	add_12 : entity work.full_adder
		port map(
			a => a(12),
			b => b(12),
			cin => c_11,
			sum => output(12),
			carry => c_12);
			
	add_13 : entity work.full_adder
		port map(
			a => a(13),
			b => b(13),
			cin => c_12,
			sum => output(13),
			carry => c_13);
			
	add_14 : entity work.full_adder
		port map(
			a => a(14),
			b => b(14),
			cin => c_13,
			sum => output(14),
			carry => c_14);

	add_15 : entity work.full_adder
		port map(
			a => a(15),
			b => b(15),
			cin => c_14,
			sum => output(15),
			carry => c_15);
			
end behavior;

			