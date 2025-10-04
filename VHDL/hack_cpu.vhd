library ieee;
use ieee.std_logic_1164.all;

entity hack_cpu2 is 
	port(
		inM, instruction 	 					: in std_logic_vector(15 downto 0);
		rst, clk				 				: in std_logic;
		outM		 				 			: out std_logic_vector(15 downto 0);
		addressM, pc 		 					: out std_logic_vector(14 downto 0);
		writeM				 					: out std_logic;
		d_reg_ext, a_reg_ext 		 			: out std_logic_vector(15 downto 0);
		d_ld_flag, a_ld_flag, z_flag, n_flag	: out std_logic);
end hack_cpu2;

architecture behavior of hack_cpu2 is


signal a_reg_in 	: std_logic_vector(15 downto 0);
signal a_reg_out	: std_logic_vector(15 downto 0);
signal a_ld     	: std_logic;
signal d_reg_in 	: std_logic_vector(15 downto 0);
signal d_reg_out	: std_logic_vector(15 downto 0);
signal d_ld     	: std_logic;

signal alu_y_in 	: std_logic_vector(15 downto 0);
signal zr_out   	: std_logic;
signal ng_out   	: std_logic;
signal alu_out  	: std_logic_vector(15 downto 0);

signal ld_count 	: std_logic;
signal count_out	: std_logic_vector(14 downto 0);
signal dummy 		: std_logic;



begin
	----------------------------------------------
	--address msb determines a or c instruction
	--and subsequent actions
	----------------------------------------------
	process(instruction, alu_out)
	begin
		case instruction(15) is
			when '0' => a_reg_in <= instruction;
			when '1' => a_reg_in <= alu_out;
			when others => null;
		end case;
	end process;
		
	process(instruction)
	begin	
		case instruction(15) is
			when '0' => a_ld <= '1';
			when '1' => a_ld <= instruction(5);
			 when others => null;
		end case;
	end process;
	
	a_reg : entity work.reg_generic 
		generic map(
			bus_width => 16)
		port map(
			data_in 	=> a_reg_in,
			clk 		=> clk,
			ld 			=> a_ld,
			rst 		=> '0',
			data_out 	=> a_reg_out);
			
	addressM <= a_reg_out(14 downto 0);
			
	process(a_reg_out, inM, instruction(12))
	begin
		case instruction(12) is
			when '0' => alu_y_in <= a_reg_out;
			when '1' => alu_y_in <= inM;
			when others => null;
		end case;
	end process;
	
	
	d_ld <= instruction(15) and instruction(4);
	
	d_reg : entity work.reg_generic 
		generic map(
			bus_width => 16)
		port map(
			data_in  => d_reg_in,
			clk 	 => clk,
			ld 		 => d_ld,
			rst		 => '0',
			data_out => d_reg_out);
			
	ALU : entity work.hack_alu
		port map(
			x 		=> d_reg_out,
			y 		=> alu_y_in,
			zx		=> instruction(11),
			nx 		=> instruction(10),
			zy 		=> instruction(9),
			ny		=> instruction(8),
			f 		=> instruction(7),
			no 		=> instruction(6),
			output 	=> alu_out,
			zr 		=> zr_out,
			ng 		=> ng_out);
			
	d_reg_in <= alu_out;
			
	
----------------------------------------------------				
----jump logic
----------------------------------------------------	
	ld_count <= (instruction(15) and (instruction(1) and zr_out)) or (instruction(15) and (instruction(0) and (not zr_out) and (not ng_out))) or 
		(instruction(15) and (instruction(2) and (not zr_out) and ng_out));
		
	prog_counter : entity work.program_counter
		port map(
			input => a_reg_out,
			ld => ld_count,
			inc => '1',
			rst => rst,
			clk => clk,
			output(15) => dummy,
			output(14) => pc(14),
			output(13) => pc(13),
			output(12) => pc(12),
			output(11) => pc(11),
			output(10) => pc(10),
			output(9) => pc(9),
			output(8) => pc(8),
			output(7) => pc(7),
			output(6) => pc(6),
			output(5) => pc(5),
			output(4) => pc(4),
			output(3) => pc(3),
			output(2) => pc(2),
			output(1) => pc(1),
			output(0) => pc(0));
			
			
	writeM <= (instruction(15) and instruction(3));
	outM <= alu_out;
	
----------------------------------------------------				
----internal signals passed out of module for use 
----with debug module
----------------------------------------------------	
	d_reg_ext <= d_reg_out;
	a_reg_ext <= a_reg_out;
	d_ld_flag <= d_ld;
	a_ld_flag <= a_ld;
	z_flag <= zr_out;
	n_flag <= ng_out;
			
end behavior;
	
		