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
		DATAout : out std_logic_vector(n-1 downto 0)
	);
  end component;
----------------------------Control------------------------------
  component Control is
	port(
		rst,clk : in std_logic;
		Input,One : in std_logic;
		---------------------------------------------
		OPCin,OPC2,OPC1,Ld,Bin,Cout : out std_logic
	);
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
		DATAout : out std_logic_vector(n-1 downto 0)
	);
  end component;
---------------------------ALU---------------------------------
	component ALU is
	GENERIC (n : INTEGER := 8);     
	PORT (	 ALUFN: IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- [1,dc]=Logical, [0,1]= shift, [0,0]= AdderSub.
			 logical,shifter,addersub: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input
             Cin: in STD_LOGIC_VECTOR(1 downto 0); --carry in 
             ALUout: OUT STD_LOGIC_VECTOR(n-1 downto 0); -- Result
			 Zero,Neg,Carry: OUT STD_LOGIC -- Flags
        );
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
            cout: OUT STD_LOGIC;
            s: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;	
----------------------------------------------------------------

  
  
  
  
end aux_package;

