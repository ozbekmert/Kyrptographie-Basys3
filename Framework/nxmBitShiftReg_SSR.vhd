library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nxmBitShiftReg is
	generic (
		N		: integer range 2 to 256 := 4;					
		M 		: integer range 1 to 256 := 2					
	port (
		CLK		: in std_logic;									
		SR		: in std_logic;									
		SRINIT	: in std_logic_vector(n*m-1 downto 0);			
		CE		: in std_logic;									
		OPMODE	: in std_logic_vector(1 downto 0);				
		DIN		: in std_logic_vector(m-1 downto 0);			
		DOUT	: out std_logic_vector(m-1 downto 0);			
		DOUT_F	: out std_logic_vector(n*m-1 downto 0)			
	);
end nxmBitShiftReg;

architecture Behavioral of nxmBitShiftReg is
	-- --------------------------------------------- 
	--                Components
	-- --------------------------------------------- 

	-- synchronously reset n bit register
	component nBitReg_SSR is
		generic (
			BIT_WIDTH	: integer range 1 to 256 := 16				
		);
		port (
			CLK		: in std_logic;									
			SR		: in std_logic;									
			SRINIT	: in std_logic_vector(BIT_WIDTH-1 downto 0);	
			CE		: in std_logic;									
			DIN		: in std_logic_vector(BIT_WIDTH-1 downto 0);	
			DOUT	: out std_logic_vector(BIT_WIDTH-1 downto 0)	
		);
	end component nBitReg_SSR;

	signal opmode_intern	: std_logic_vector(1 downto 0);
		alias rotate		: std_logic is opmode_intern(1);
		alias toleft		: std_logic is opmode_intern(0);
	
	signal din_intern : std_logic_vector(n*m-1 downto 0);
	signal dout_intern : std_logic_vector(n*m-1 downto 0);
begin

	opmode_intern <= OPMODE;

	shiftReg : for i in 1 to n generate
	
		reg : nBitReg_SSR generic map ( BIT_WIDTH => M ) 
				port map (
					CLK 	=> CLK,
					SR		=> SR,
					SRINIT	=> SRINIT(i*m-1 downto (i-1)*m),
					CE		=> CE,
					DIN		=> din_intern(i*m-1 downto (i-1)*m),
					DOUT	=> dout_intern(i*m-1 downto (i-1)*m)
				);

		in_lmr: if i = n generate
			din_intern(i*m-1 downto (i-1)*m) <= DIN when toleft = '0' and rotate = '0' else
												dout_intern(m-1 downto 0) when toleft = '0' and rotate = '1' else
												dout_intern((i-1)*m-1 downto (i-2)*m);
		end generate;
		
		
		in_mr: if i > 1 and i < n generate
			din_intern(i*m-1 downto (i-1)*m) <= dout_intern((i+1)*m-1 downto i*m) when toleft = '0' else
												dout_intern((i-1)*m-1 downto (i-2)*m);
		end generate;
		
		in_rmr: if i = 1 generate
			din_intern(i*m-1 downto (i-1)*m) <= DIN when toleft = '1' and rotate = '0' else
												dout_intern(n*m-1 downto (n-1)*m) when toleft = '1' and rotate = '1' else
												dout_intern((i+1)*m-1 downto i*m);
		end generate;
		
	end generate;
	
	DOUT_F <= dout_intern;
	DOUT <= dout_intern(m-1 downto 0) when toleft = '0' else
			dout_intern(n*m-1 downto (n-1)*m);

end Behavioral;

