library IEEE;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
ENTITY ALU IS
  GENERIC ( n : INTEGER := 8);
  PORT (    ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0); --[0,0,0]=A ,[0,0,1]=A+B, [0,1,0]=A-B, [0,1,1]=AorB, [1,0,0]= AandB, [1,0,1]=AxorB 
            A : IN STD_LOGIC;
			logical,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
END ALU;
------------------------------------------------------------------------
ARCHITECTURE dfl OF ALU IS
signal reg_out:STD_LOGIC_VECTOR(n-1 downto 0); -- Result
signal fun_type: STD_LOGIC;-- 1=Logical, 0= AdderSub.
begin
fun_type  <=  ALUFN(1)
select_result : for i in 0 to n-1 generate 
--Selection : 1=Logical, 0= AdderSub.
    reg_out(i) <= (ALUFN(1)and logical(i)) or (not(ALUFN(1)) and((ALUFN(0) and shifter(i))or (not(ALUFN(0)) and addersub(i))));
end generate;

ALUout <= reg_out;

end dfl;