library IEEE;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
ENTITY Logical IS
  GENERIC ( n : INTEGER := 8);     
  PORT (    ALUFN: IN STD_LOGIC_VECTOR (1 DOWNTO 0); --Selection := [0,1]= or,[1,0] = and, [1,1] = xor  
			y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            x: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            result: OUT STD_LOGIC_VECTOR(n-1 downto 0)); -- Result
END Logical;
---------------------------------------------------------------
ARCHITECTURE dfl OF Logical IS
begin
-- The boolean Logic is in Documentation
    loop1: for i in 0 to n-1 generate
        result(i)<= ((ALUFN(1) and ALUFN(0)) and (y(i) nor x(i))) or
        ((ALUFN(1) and not(ALUFN(0))) and (y(i) xor x(i))) or
        ((not(ALUFN(1)) and ALUFN(0)) and (y(i) and x(i))) or
        ((ALUFN(1) nor ALUFN(0)) and (y(i) or x(i)));
        end generate;
end dfl;

