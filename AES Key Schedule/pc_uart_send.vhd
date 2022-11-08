library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_uart_send is
    Port ( clk : in  STD_LOGIC;
			  reset: in STD_LOGIC;
			  data_in : in STD_LOGIC_VECTOR(7 downto 0);
			  rs232_bit : out STD_LOGIC;
			  send_enable: in STD_LOGIC;
			  ready_for_data : out STD_LOGIC);
end pc_uart_send;

architecture Behavioral of pc_uart_send is

	constant fpga_frequency : integer := 100000000;
	constant bit_rate : integer := 9600;
	
	type state_type is (READY, SENDING);
	signal state : state_type := READY;

	signal bit_sending_time : unsigned(19 downto 0);
	signal bit_sending_cnt : unsigned(19 downto 0);
	signal bit_cnt : unsigned(3 downto 0);
	signal data_int : std_logic_vector(7 downto 0);
	
begin

bit_sending_time <= (to_unsigned(fpga_frequency/bit_rate,bit_sending_time'length));

	SEND : process(clk)
	begin
			if rising_edge(clk) then
				if (reset = '1') then
					state <= READY;
					bit_sending_cnt <= (others => '0');
					bit_cnt <= (others => '0');
					rs232_bit <= '1';
					data_int <= data_in;
					ready_for_data <= '1';					
				else
				
				case state is							
					when READY =>
									if (send_enable = '1') then
										state <= SENDING;
										ready_for_data <= '0';
									else
										ready_for_data <= '1';
									end if;
									
									bit_sending_cnt <= (others => '0');
									bit_cnt <= (others => '0');
									data_int <= data_in;
									
					when SENDING =>
								
									if (bit_cnt = 0) then
										rs232_bit <= '0';
									elsif (bit_cnt = 1) then
										rs232_bit <= data_int(0);
									elsif (bit_cnt = 2) then
										rs232_bit <= data_int(1);
									elsif (bit_cnt = 3) then
										rs232_bit <= data_int(2);
									elsif (bit_cnt = 4) then
										rs232_bit <= data_int(3);
									elsif (bit_cnt = 5) then
										rs232_bit <= data_int(4);
									elsif (bit_cnt = 6) then
										rs232_bit <= data_int(5);
									elsif (bit_cnt = 7) then
										rs232_bit <= data_int(6);
									elsif (bit_cnt = 8) then
										rs232_bit <= data_int(7);
									elsif (bit_cnt = 9) then
										rs232_bit <= '1';
									else
										state <= READY;
										ready_for_data <= '1';
									end if;

									if (bit_sending_time <= bit_sending_cnt) then
										bit_sending_cnt <= (others => '0');
										bit_cnt <= bit_cnt + 1;
									else
										bit_sending_cnt <= bit_sending_cnt + 1;
										bit_cnt <= bit_cnt + 0;
									end if;
				end case;
			end if;
		end if;
	end process;

end Behavioral;