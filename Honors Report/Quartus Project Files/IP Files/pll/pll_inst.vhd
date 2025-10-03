	component pll is
		port (
			clk_25_clk : out std_logic;        -- clk
			clk_in_clk : in  std_logic := 'X'; -- clk
			rst_reset  : in  std_logic := 'X'  -- reset
		);
	end component pll;

	u0 : component pll
		port map (
			clk_25_clk => CONNECTED_TO_clk_25_clk, -- clk_25.clk
			clk_in_clk => CONNECTED_TO_clk_in_clk, -- clk_in.clk
			rst_reset  => CONNECTED_TO_rst_reset   --    rst.reset
		);

