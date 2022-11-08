library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pc_uart_receive is
    Port ( 	clk : in  STD_LOGIC;
				reset: in STD_LOGIC;
				rs232_bit : in STD_LOGIC;
				data_out : out std_logic_vector(7 downto 0);
				data_valid : out STD_LOGIC
			);
end pc_uart_receive;

architecture Behavioral of pc_uart_receive is

	constant fpga_frequency : integer := 100000000;
	constant bit_rate : integer := 9600;
	
	component nxmBitShiftReg is
		generic (
			N		: integer range 2 to 256 := 4;							
			M 		: integer range 1 to 256 := 2							
		);
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
	end component nxmBitShiftReg;

signal bit_cnt : unsigned(3 downto 0);
signal bit_sampled : std_logic;
signal bit_sampled_enable : std_logic;
signal clk_cnt : integer range 0 to 1048575;
signal data_out_sr : std_logic_vector(8 downto 0);
signal rs232_bit_syn, rs232_bit_last : std_logic;
signal bit_receiving_time : unsigned(19 downto 0);

	type state_type is (WAIT_DATA, SAMPLING, READY);
	signal state : state_type;

begin

	Inst_shiftregister: nxmBitShiftReg 
		generic map (
			N => 9,
			M => 1
		)
		port map (
			clk => clk,
			sr => reset,
			srinit => (others => '0'),
			ce => bit_sampled_enable,
			opmode => "00",
			din => (0 => bit_sampled),
			dout => open,
			dout_f => data_out_sr
		);

-- set duration of 1 bit in fpga-clks
bit_receiving_time <= (to_unsigned(fpga_frequency/bit_rate,bit_receiving_time'length));

-- route the shift register output to top level modul
data_out <=  data_out_sr(8 downto 1);


RECEIVE : process(clk)
	begin
		if rising_edge(clk) then
			if (reset = '1') then
				state <= WAIT_DATA;
				clk_cnt  <= 0;
				bit_cnt <= (others => '0');
				data_valid <= '0';
				bit_sampled <= '0';
				bit_sampled_enable <= '0';
			else
	
				case state is							
					
					when WAIT_DATA =>
											data_valid <= '0';
										
											if ((rs232_bit_syn = '0') and (rs232_bit_last = '1')) then
												state <= SAMPLING;
											end if;

					when SAMPLING =>
										
											if ((clk_cnt = to_integer(unsigned(bit_receiving_time))/2)) then
												bit_sampled <= rs232_bit;
												bit_sampled_enable <= '1';
											else
												bit_sampled_enable <= '0';
											end if;

										
											if (clk_cnt < to_integer(bit_receiving_time)) then 
												clk_cnt <= clk_cnt + 1;
											else
												clk_cnt <= 0;
												bit_cnt <= bit_cnt + 1;
											end if;
										
										
											if (bit_cnt > 8) then
												state <= READY;
											end if;
					
					when READY =>
										
											data_valid <= '1';
											bit_cnt <= (others => '0');
											clk_cnt <= 0;
											state <= WAIT_DATA;
											
				end case;
			end if;
		end if;
	end process;

BUFFERING : process(CLK)
	begin
		if rising_edge(CLK) then
			if RESET = '1' then
				rs232_bit_syn <= '0';
				rs232_bit_last <= '0';
			else
				rs232_bit_syn <= rs232_bit;
				rs232_bit_last <= rs232_bit_syn;
			end if;
		end if;
end process;
 
end Behavioral;	