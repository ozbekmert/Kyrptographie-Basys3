
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY Katan32 IS
    PORT ( 
           CLK          : IN    STD_LOGIC; 
           -- CONTROL SIGNAL PORTS ---------------------------
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           DONE         : OUT   STD_LOGIC;
           -- DATA SIGNAL PORTS ------------------------------
           KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0);
           PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
           CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
END Katan32;

ARCHITECTURE defaultArchitecture OF Katan32 IS

component KatanKeySchedule is  port 
(
           CLK  : IN  STD_LOGIC;
           EN   : IN  STD_LOGIC;
           RES  : IN STD_LOGIC;
           KEY  : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
           Q    : OUT STD_LOGIC_VECTOR(79 DOWNTO 0) 

 );
end component;

component KatanRoundFunction IS
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC; 
           EN   : IN  STD_LOGIC;
           IR   : IN  STD_LOGIC;
           K1   : IN  STD_LOGIC; -- K_(2i)
           K2   : IN  STD_LOGIC; -- K_(2i+1)
           ROUND_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           PT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END component;


type STATES is (S_INIT,S_ROUND,S_FINAL);
signal current_s, next_s : STATES;  

signal counter_s: unsigned (7 downto 0);
signal next_counter: unsigned (7 downto 0);

signal reg_KatanKeySchedule : STD_LOGIC_VECTOR(79 DOWNTO 0);
signal reg_KatanRoundFunction : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal ENABLE_KEY_SCHED,ENABLE_ROUND_FUNC,IR : std_logic;
signal K1,K2 : std_logic;
 
 
BEGIN
KEY_SCHEDULE: KatanKeySchedule port map(CLK,ENABLE_KEY_SCHED,RESET,KEY,reg_KatanKeySchedule);


ROUND_FUNCTION: KatanRoundFunction port map(
                                            CLK,
                                            RESET,
                                            ENABLE_ROUND_FUNC,
                                            IR,
                                            K1,
                                            K2,
                                            reg_KatanRoundFunction,
                                            PLAINTEXT
                                            );
 
-- STATE REGISTER PROCESS --------------------------------------
STATE_REGISTER_PROCESS:process (CLK,ENABLE)  
begin
if (rising_edge(CLK)) then
    if (RESET='1') then 
          current_s <= S_INIT; 
                    
    elsif(RESET = '0') then
        if (ENABLE = '1') then
             current_s <= next_s;   --state change. 
             counter_s <= next_counter;  
        end if;
    end if;
end if;    
end process;

-- STATE TRANSITION PROCESS ------------------------------------
STATE_TRANSITION_PROCESS: process(current_s,counter_s)
begin 
     next_s <=  current_s ;
 case current_s is
     when S_INIT => 
            CIPHERTEXT <= (others => '0');
            ENABLE_KEY_SCHED <= '0';
            ENABLE_ROUND_FUNC <= '0';
            DONE <= '0';
            IR <= '0'; 
            next_counter <= x"FF"; 
            next_s <= S_ROUND;
     when S_ROUND =>  
         ENABLE_KEY_SCHED <= '1';
         ENABLE_ROUND_FUNC <= '1';            
         if((counter_s(6 downto 0) & (((counter_s(7) xor counter_s(6)) xor counter_s(4))  xor counter_s(2))) /= x"FF") then  
                K1 <= reg_KatanKeySchedule(78);
                K2 <= reg_KatanKeySchedule(79);
                next_counter <=counter_s(6 downto 0) & (((counter_s(7) xor counter_s(6)) xor counter_s(4))  xor counter_s(2));
                IR <= counter_s(7);
                next_s <= S_ROUND;
         elsif((counter_s(6 downto 0) &(((counter_s(7) xor counter_s(6)) xor counter_s(4))  xor counter_s(2))) = x"FF") then
				      CIPHERTEXT <= reg_KatanRoundFunction;
--                    K1 <= reg_KatanKeySchedule(78);
--                    K2 <= reg_KatanKeySchedule(79);
--                    IR <= counter_s(7);
                next_s <= S_FINAL;
         end if;
     when S_FINAL =>
           ENABLE_KEY_SCHED <= '0';
           ENABLE_ROUND_FUNC <= '0';
           DONE <= '1';
          next_s <= S_FINAL;
     when others =>
          next_s <=S_INIT;                                                  
end case;
end process;





END defaultArchitecture;