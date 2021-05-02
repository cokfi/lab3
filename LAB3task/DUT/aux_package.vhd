LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is
----------------------------TOP----------------------------------
  component top is
	generic (n : positive := 8 );
	port(
		rst,clk : in std_logic;
		DATAin  : in std_logic_vector(n-1 downto 0);
		---------------------------------------------
		DATAout : out std_logic_vector(n-1 downto 0));
  end component;
----------------------------Control------------------------------
  component Control is
	port(
		rst,clk : in std_logic;
		Input,One : in std_logic;
		----------------------------------------------
		OPCin,OPC2,OPC1,Ld,Bin,Cout : out std_logic);
  end component;
----------------------------Datapath---------------------------	
  component Datapath is
	generic (n : positive := 8 );
	port(
		clk : in std_logic;
		OPCin,OPC2,OPC1,Ld,Bin,Cout : in std_logic;
		DATAin  : in std_logic_vector(n-1 downto 0);
		---------------------------------------------
		Input,One : out std_logic;
		DATAout : out std_logic_vector(n-1 downto 0));
  end component;
---------------------------ALU---------------------------------
	component ALU is
	GENERIC (n : INTEGER := 8);     
	PORT (    ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0); 
			  --ALUFN := [0,0,0]=A ,[0,0,1]=A+B, [0,1,0]=A-B, [0,1,1]=AorB, [1,0,0]= AandB, [1,0,1]=AxorB 
			  A : IN STD_LOGIC; -- set ALUout as vector_A (OPC1)
			  vector_A,logical,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
			  ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0)); -- Result
	end component;	
--------------------------Logical------------------------------
	component Logical is
	GENERIC (n : INTEGER := 8);     
	PORT (   ALUFN: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- decide which module is used. Logical ALUFN= TOP ALUFN[2:1]
			 y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             x: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             result: OUT STD_LOGIC_VECTOR(n-1 downto 0)); -- Result
	end component;
-------------------------FullAdder-----------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
-----------------------AdderSubtractor--------------------------
	component AdderSub is
	GENERIC (n : INTEGER := 8);
	PORT (    sctr: IN STD_LOGIC; -- subtractor control , ADD = 0 , Sub=1
			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            s: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;	
----------------------------------------------------------------

end aux_package;

