LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity Datapath is
	generic (n : positive := 8 );
	port(
		clk : in std_logic;
		OPCin,OPC2,OPC1,Ld,Bin,Cout : in std_logic;
		DATAin  : in std_logic_vector(n-1 downto 0);
		---------------------------------------------
		Input,One : out std_logic;
		DATAout : out std_logic_vector(n-1 downto 0)
	);
end Datapath;
------------- complete the Datapath Unit Architecture code --------------
architecture arc_sys of Datapath is
signal reg_c,reg_b,ALUout,counter,one_before_nor,zeros:STD_LOGIC_VECTOR(n-1 downto 0);
signal addersub_result,logical_result:STD_LOGIC_VECTOR(n-1 downto 0);
signal reg_opc,ALUFN:STD_LOGIC_VECTOR(2 downto 0); 
signal A : std_logic; -- enable moving DATAin into ALUout
alias Opcode :std_logic_vector(2 downto 0) is DATAin(2 downto 0);

begin
	zeros <= (others=>'0');
	Input<= '0' when DATAin =zeros else '1';
	ALUFN<= reg_opc when(OPC2='1') else "ZZZ";--tristate std_logic_vector
	A<='1' when (OPC1='1') else 'Z'; --tristate
	one_before_nor(0) <= not counter(0);
	create_one:	for i in 1 to n-1 generate
		one_before_nor(i) <= counter(i);
end generate;
	One <= nor one_before_nor;

------------------------counter process--------------------------
d_counter : process(clk)
begin
	if (clk'event and clk='1') then -- rising edge
		if (Ld ='1') then
			counter <=DATAin;
		elsif (Ld ='0') then
			counter <= counter -1;
		end if;	
	end if;
end process;
------------------------Registers process--------------------------
reg_opc_re : process(clk)
begin
	if (clk'event and clk='1') then -- rising edge
		if (OPCin='1') then --register OPC
			reg_opc <= Opcode;
		end if;
		reg_c<= reg_b; --Cin every operation cycle unlike Cout
	end if;
end process;

reg_opc_fe : process(clk)
begin
	if (clk'event and clk='0') then -- falling edge
		if (Bin='1') then --register B
			reg_b <= ALUout;
		elsif (Cout='1') then --register C
			DATAout <= reg_c; -- provide output
		end if;
	end if;
end process;
-----------------------AdderSub---------------------------
AdderSubaba : AdderSub generic map (n)port map(
			sctr => ALUFN(1), --'1' SUB , '0' ADD
			x => DATAin,
			y => reg_b,
			s => addersub_result);	
-----------------------Logical----------------------------			
Logiloko : Logical generic map (n) port map( -- x and y are crossed twice duo to a loko programmer
			ALUFN => ALUFN(2)&ALUFN(0),
			x => DATAin,
			y => reg_b,
			result => logical_result);
-----------------------ALU--------------------------------					
ALUFORU  : ALU generic map (n) port map(
			ALUFN => ALUFN(2 downto 0), 
			--ALUFN := [0,0,0]=A ,[0,0,1]=A+B, [0,1,0]=A-B, [0,1,1]=AorB, [1,0,0]= AandB, [1,0,1]=AxorB 
			A => A, -- std_logic ,after the tristate
			vector_A => DATAin,
			logical => logical_result,
			addersub => addersub_result,
			ALUout=>ALUout);
end arc_sys;
