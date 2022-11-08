----------------------------------------------------------------------------------
-- COPYRIGHT (c) 2014 ALL RIGHT RESERVED
--
-- KRYPTOGRAPHIE AUF PROGRAMMIERBARER HARDWARE: UEBUNG 9
----------------------------------------------------------------------------------



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- ENTITY
----------------------------------------------------------------------------------
ENTITY Functions IS
	PORT ( CLK	: IN  STD_LOGIC;
			 RST	: IN  STD_LOGIC;
			 A  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			 B 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 C 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 D 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 B_SHIFT : OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 F 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 F1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 K 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 K1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 SEL	: IN  STD_LOGIC_VECTOR ( 1 DOWNTO 0);
			 SEL1	: IN  STD_LOGIC_VECTOR ( 1 DOWNTO 0));
END Functions;



-- ARCHITECTURE
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF Functions IS

signal shift : STD_LOGIC_VECTOR (31 DOWNTO 0);

-- BEHAVIORAL
----------------------------------------------------------------------------------
BEGIN

    shift <= (STD_LOGIC_VECTOR( unsigned(B) srl 30 ));

    B_SHIFT <= shift;
	WITH SEL SELECT
		F	<= (B AND C) OR ((NOT B) AND D)				WHEN "00",
				(B XOR C XOR D) 								WHEN "01",
				(B AND C) OR (B AND D) OR (C AND D)		WHEN "10",
				(B XOR C XOR D)								WHEN OTHERS;
	WITH SEL SELECT
          F1    <= (A AND (STD_LOGIC_VECTOR( unsigned(B) srl 30 ))) OR ((NOT A) AND C)                WHEN "00",
                   (A XOR (STD_LOGIC_VECTOR( unsigned(B) srl 30 )) XOR C)                                 WHEN "01",
                   (A AND (STD_LOGIC_VECTOR( unsigned(B) srl 30 ))) OR (A AND C) OR ((STD_LOGIC_VECTOR( unsigned(B) srl 30 )) AND C)        WHEN "10",
                   (A XOR shift XOR C)                                WHEN OTHERS;			
				
				

	WITH SEL SELECT
		K	<=	X"5A827999" WHEN "00",
				X"6ED9EBA1"	WHEN "01",
				X"8F1BBCDC" WHEN "10",
				X"CA62C1D6" WHEN OTHERS;

    WITH SEL1 SELECT
		K1	<=	X"5A827999" WHEN "00",
				X"6ED9EBA1"	WHEN "01",
				X"8F1BBCDC" WHEN "10",
				X"CA62C1D6" WHEN OTHERS;

END Behavioral;