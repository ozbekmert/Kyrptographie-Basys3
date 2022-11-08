LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_round IS
END tb_round;
 
ARCHITECTURE behavior OF tb_round IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT round
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         valid : OUT  std_logic;
         h0in : IN  std_logic_vector(31 downto 0);
         h1in : IN  std_logic_vector(31 downto 0);
         h2in : IN  std_logic_vector(31 downto 0);
         h3in : IN  std_logic_vector(31 downto 0);
         h4in : IN  std_logic_vector(31 downto 0);
         h0out : OUT  std_logic_vector(31 downto 0);
         h1out : OUT  std_logic_vector(31 downto 0);
         h2out : OUT  std_logic_vector(31 downto 0);
         h3out : OUT  std_logic_vector(31 downto 0);
         h4out : OUT  std_logic_vector(31 downto 0);
         w0in : IN  std_logic_vector(31 downto 0);
         w1in : IN  std_logic_vector(31 downto 0);
         w2in : IN  std_logic_vector(31 downto 0);
         w3in : IN  std_logic_vector(31 downto 0);
         w4in : IN  std_logic_vector(31 downto 0);
         w5in : IN  std_logic_vector(31 downto 0);
         w6in : IN  std_logic_vector(31 downto 0);
         w7in : IN  std_logic_vector(31 downto 0);
         w8in : IN  std_logic_vector(31 downto 0);
         w9in : IN  std_logic_vector(31 downto 0);
         w10in : IN  std_logic_vector(31 downto 0);
         w11in : IN  std_logic_vector(31 downto 0);
         w12in : IN  std_logic_vector(31 downto 0);
         w13in : IN  std_logic_vector(31 downto 0);
         w14in : IN  std_logic_vector(31 downto 0);
         w15in : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal h0in : std_logic_vector(31 downto 0) := (others => '0');
   signal h1in : std_logic_vector(31 downto 0) := (others => '0');
   signal h2in : std_logic_vector(31 downto 0) := (others => '0');
   signal h3in : std_logic_vector(31 downto 0) := (others => '0');
   signal h4in : std_logic_vector(31 downto 0) := (others => '0');
   signal w0in : std_logic_vector(31 downto 0) := (others => '0');
   signal w1in : std_logic_vector(31 downto 0) := (others => '0');
   signal w2in : std_logic_vector(31 downto 0) := (others => '0');
   signal w3in : std_logic_vector(31 downto 0) := (others => '0');
   signal w4in : std_logic_vector(31 downto 0) := (others => '0');
   signal w5in : std_logic_vector(31 downto 0) := (others => '0');
   signal w6in : std_logic_vector(31 downto 0) := (others => '0');
   signal w7in : std_logic_vector(31 downto 0) := (others => '0');
   signal w8in : std_logic_vector(31 downto 0) := (others => '0');
   signal w9in : std_logic_vector(31 downto 0) := (others => '0');
   signal w10in : std_logic_vector(31 downto 0) := (others => '0');
   signal w11in : std_logic_vector(31 downto 0) := (others => '0');
   signal w12in : std_logic_vector(31 downto 0) := (others => '0');
   signal w13in : std_logic_vector(31 downto 0) := (others => '0');
   signal w14in : std_logic_vector(31 downto 0) := (others => '0');
   signal w15in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal valid : std_logic;
   signal h0out : std_logic_vector(31 downto 0);
   signal h1out : std_logic_vector(31 downto 0);
   signal h2out : std_logic_vector(31 downto 0);
   signal h3out : std_logic_vector(31 downto 0);
   signal h4out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: round PORT MAP (
          clk => clk,
          rst => rst,
          valid => valid,
          h0in => h0in,
          h1in => h1in,
          h2in => h2in,
          h3in => h3in,
          h4in => h4in,
          h0out => h0out,
          h1out => h1out,
          h2out => h2out,
          h3out => h3out,
          h4out => h4out,
          w0in => w0in,
          w1in => w1in,
          w2in => w2in,
          w3in => w3in,
          w4in => w4in,
          w5in => w5in,
          w6in => w6in,
          w7in => w7in,
          w8in => w8in,
          w9in => w9in,
          w10in => w10in,
          w11in => w11in,
          w12in => w12in,
          w13in => w13in,
          w14in => w14in,
          w15in => w15in
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		-- set testvector to message "abc"
		-- conversion from ASCII gives 61 62 63
		-- padding is already appended (100...00[message length in bit])_2
		-- 24 bit = 0x18
		w0in<=X"61626380";
		w1in<=(others=>'0');
		w2in<=(others=>'0');
		w3in<=(others=>'0');
		w4in<=(others=>'0');
		w5in<=(others=>'0');
		w6in<=(others=>'0');
		w7in<=(others=>'0');
		w8in<=(others=>'0');
		w9in<=(others=>'0');
		w10in<=(others=>'0');
		w11in<=(others=>'0');
		w12in<=(others=>'0');
		w13in<=(others=>'0');
		w14in<=(others=>'0');		
		w15in<=X"00000018";
		
		wait for clk_period*10;
		rst<='0';
      wait until valid='1';
		if(h0out=X"A9993E36" and h1out=X"4706816A" and h2out=X"BA3E2571" and h3out=X"7850C26C" and h4out=X"9CD0D89D") then
			report "Test Succeeded";
		else
			report "Test Failed";
		end if;
		
		wait for clk_period;
		assert false
				report "Simulation Completed"
				severity failure;
	   wait;
   end process;

END;
