----------------------------------------------------------------------------------
-- COPYRIGHT (c) 2014 ALL RIGHT RESERVED
--
-- KRYPTOGRAPHIE AUF PROGRAMMIERBARER HARDWARE: UEBUNG 9
----------------------------------------------------------------------------------



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY Shift IS
	PORT ( CLK 		: IN  STD_LOGIC;
			 RST 		: IN  STD_LOGIC;
			 W0IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W1IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W2IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W3IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W4IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W5IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W6IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W7IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W8IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W9IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W10IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W11IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W12IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W13IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W14IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W15IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);			 
			 WOUT		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 WOUT1		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)                       
			 );
END Shift;



-- ARCHITECTURE
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF Shift IS



-- TYPE
----------------------------------------------------------------------------------
TYPE Words IS ARRAY(0 TO 15) OF STD_LOGIC_VECTOR(31 DOWNTO 0);


-- SIGNALS
----------------------------------------------------------------------------------
SIGNAL W	: Words;



-- BEHAVIORAL
----------------------------------------------------------------------------------
BEGIN

	WOUT<=W(0);
	WOUT1<=W(1);
        
	
	PShift : PROCESS(CLK, RST)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (RST = '1') THEN
				W(0)	<= W0IN;
				W(1)	<= W1IN;
				W(2)	<= W2IN;
				W(3)	<= W3IN;
				W(4)	<= W4IN;
				W(5)	<= W5IN;
				W(6)	<= W6IN;
				W(7)	<= W7IN;
				W(8)	<= W8IN;
				W(9)	<= W9IN;
				W(10)	<= W10IN;
				W(11)	<= W11IN;
				W(12)	<= W12IN;
				W(13)	<= W13IN;
				W(14)	<= W14IN;
				W(15)	<= W15IN;
			ELSE
				W(0 TO 14)				<= W(1 TO 15);
				W(15)(31 DOWNTO 1)	<= W(0)(30 DOWNTO 0) XOR W(2)(30 DOWNTO 0) XOR W(8)(30 DOWNTO 0) XOR W(13)(30 DOWNTO 0);
				W(15)(0)			<= W(0)(31) XOR W(2)(31) XOR W(8)(31) XOR W(13)(31);
			END IF; -- RST
		END IF; -- CLK
	END PROCESS;

END Behavioral;