library IEEE;
use ieee.std_logic_1164.all;
USE work.aux_package.all;
-- ALU entity decide which result to provide, the options are :A/AdderSub/Logical
ENTITY ALU IS
  GENERIC ( n : INTEGER := 8);
  PORT (    ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
            --ALUFN := [0,0,0]=A ,[0,0,1]=A+B, [0,1,0]=A-B, [0,1,1]=AorB, [1,0,0]= AandB, [1,0,1]=AxorB 
            A : IN STD_LOGIC; -- set ALUout as vector_A
			vector_A,logical,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
            ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0)); -- Result
END ALU;
-----------------------------------------------------------------------
ARCHITECTURE dfl OF ALU IS
signal reg_out:STD_LOGIC_VECTOR(n-1 downto 0); -- Result

begin

    out_select : process (ALUFN,A, vector_A, logical,addersub) is
    begin
    case ALUFN is
        when "001"|"010" =>
            ALUout <= addersub;
        when "011"|"100"|"101" =>
            ALUout <= logical;
        when others =>
            ALUout <= vector_A;
    end case;
    end process out_select;


end dfl;