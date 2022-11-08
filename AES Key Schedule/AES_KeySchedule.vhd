LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY AES_KeySchedule is
    PORT ( cipherkey : in STD_LOGIC_VECTOR (127 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           roundkey : out STD_LOGIC_VECTOR (127 downto 0));
END AES_KeySchedule;

ARCHITECTURE Behavioral of AES_KeySchedule is

component AES_Sbox is
    Port ( a : in  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


FUNCTION RCON_VAL(round : STD_LOGIC_VECTOR (3 DOWNTO 0))
	RETURN STD_LOGIC_VECTOR
IS
	VARIABLE rcon				: BIT_VECTOR (7 DOWNTO 0);
	VARIABLE DATA_stdlogic	: STD_LOGIC_VECTOR (7 DOWNTO 0);	
BEGIN	
	CASE ROUND IS
		WHEN "0000" => rcon := "00000001";
		WHEN "0001" => rcon := "00000010";
		WHEN "0010" => rcon := "00000100";
		WHEN "0011" => rcon := "00001000";
		WHEN "0100" => rcon := "00010000";
		WHEN "0101" => rcon := "00100000";
		WHEN "0110" => rcon := "01000000";
		WHEN "0111" => rcon := "10000000";
		WHEN "1000" => rcon := "00011011";
		WHEN "1001" => rcon := "00110110";
		WHEN OTHERS => rcon := "00000000";
	END CASE; 
	
	DATA_STDLOGIC := TO_STDLOGICVECTOR(RCON);

	RETURN DATA_STDLOGIC;
	
END FUNCTION RCON_VAL;

signal mux_out : std_logic_vector(127 downto 0);
signal round_key : std_logic_vector(127 downto 0):= (others => '0');
signal round_key_out: std_logic_vector(127 downto 0);
signal counter : unsigned(3 downto 0) := (others => '0');
signal round_constant : std_logic_vector (7 downto 0); 
signal s_in0,s_out0 : std_logic_vector(7 downto 0);
signal s_in1,s_out1 : std_logic_vector(7 downto 0);
signal s_in2,s_out2 : std_logic_vector(7 downto 0);
signal s_in3,s_out3 : std_logic_vector(7 downto 0);

signal w0 : std_logic_vector(31 downto 0);
signal w1 : std_logic_vector(31 downto 0);
signal w2 : std_logic_vector(31 downto 0);
signal w3 : std_logic_vector(31 downto 0);

signal temp : std_logic_vector(31 downto 0);

begin

sbox1: AES_Sbox port map(s_in0,s_out0);
sbox2: AES_Sbox port map(s_in1,s_out1);
sbox3: AES_Sbox port map(s_in2,s_out2);
sbox4: AES_Sbox port map(s_in3,s_out3);

s_in0 <= round_key(31 downto 24);   
s_in1 <= round_key(23 downto 16); 
s_in2 <= round_key(15 downto 8);  
s_in3 <= round_key(7 downto 0);   

temp <= (s_out1 xor round_constant) & s_out2 & s_out3& s_out0; 

round_key_out(127 downto 96) <=  round_key(127 downto 96) xor temp;

round_key_out(95 downto 64) <= (round_key(127 downto 96) xor temp) xor round_key(95 downto 64);
round_key_out(63 downto 32) <= ((round_key(127 downto 96) xor temp) xor round_key(95 downto 64)) xor round_key(63 downto 32);
round_key_out(31 downto 0) <= (((round_key(127 downto 96) xor temp) xor round_key(95 downto 64)) xor round_key(63 downto 32)) xor round_key(31 downto 0); 



w0 <=round_key_out(127 downto 96);
w1 <=round_key_out(95 downto 64);
w2 <=round_key_out(63 downto 32);
w3 <=round_key_out(31 downto 0);


 
AES_WRAPPER:process(clk,reset)
begin
    if rising_edge(clk) then
        if(enable = '1' ) then
            round_key <= mux_out;
        end if;
    end if;
end process AES_WRAPPER;

counter_proc:process(clk,reset)
begin
    if (enable = '1') then
        if rising_edge(clk) then
            if(reset = '1' ) then
               counter  <= (others => '0');
            elsif(reset = '0') then
                counter <= counter +1;
            end if;
        end if;
    end if;
end process counter_proc;


mux_out <= cipherkey  when reset = '1' else round_key_out; 
roundkey <= round_key_out;
round_constant <= RCON_VAL(std_logic_vector(counter));

END Behavioral;
