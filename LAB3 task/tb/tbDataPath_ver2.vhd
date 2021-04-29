library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbDataPath is
	generic (
		n : positive := 8 
	);
end tbDataPath;

architecture dtb of tbDataPath is
	signal clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); -- Note: Consider changin type to int
    signal counter_out,reg_b_out,reg_c_out: STD_LOGIC_VECTOR(n-1 downto 0); -- testing
    signal opc_out : STD_LOGIC_VECTOR(2 downto 0); -- testing
begin
    L0 : Datapath generic map (n) port map(clk,OPCin,OPC2,OPC1,Ld,Bin,Cout,DATAin,Input,One,DATAout,counter_out,reg_b_out,reg_c_out,opc_out);
    
    
--------- start of stimulus section ------------------	
    gen_clk : process
    begin
        clk <= '0';
        wait for 25 ns;
        clk <= not clk;
        wait for 25 ns;
    end process;
---------Control Simulation ------------------	State Path: Idle => SetN => First => ALU(x7) => Done
    OPCinSim : process
    begin  
        OPCin<='1';
        wait for 25 ns;
        wait for 150 ns;--150 ns
        OPCin<='0';
        wait for 450 ns;
        OPCin<='1';--600 ns
        wait;
    end process;
    OPC2Sim: process
    begin
        OPC2<='0';
        wait for 25 ns;
        wait for 250 ns;--250 ns
        OPC2<='1';
        wait for 350 ns;--600 ns
        OPC2<='0';
        wait;
    end process;
    OPC1Sim : process
    begin
        OPC1<='0';
        wait for 25 ns;
        wait for 200 ns;--200 ns
        OPC1<='1';
        wait for 50 ns;--250 ns
        OPC1<='0';
        wait;
    end process;
    LdSim : process
    begin
        Ld <='1';
        wait;
        Ld<='0';
        wait for 25 ns;
        wait for 200 ns;--150 ns
        Ld<='1';
        wait for 50 ns;--200 ns
        Ld<='0';
        wait;
    end process;
    BinSim : process
    begin
        Bin<='0';
        wait for 25 ns;
        wait for 200 ns;--200 ns
        Bin<='1';
        wait for 400 ns;--600 ns
        Bin<='0';
        wait;
    end process;
    CoutSim : process
    begin
        Cout<='0';
        wait for 25 ns;
        wait for 600 ns;--600 ns
        Cout <='1';
        wait;
    end process; 

---------Input Simulation ------------------	
    InputGen : process
    begin
        DATAin<=conv_std_logic_vector(0,n); -- 2 zeros at the start
        wait for 150 ns;
        DATAin<=conv_std_logic_vector(1,n);--Opcode for sum
        wait for 50 ns;
        DATAin<=conv_std_logic_vector(8,n);--m=8        
        wait for 50 ns;--Input new number every clk cycle 
        DATAin<=conv_std_logic_vector(1,n);--First number
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(2,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(4,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(8,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(16,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(32,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(61,n);
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(3,n);--Last number
        wait for 50 ns; 
        DATAin<= (others=>'0');--Opcode 000
        wait for 50 ns; 
        DATAin<=conv_std_logic_vector(0,n); -- zeros at the end
        wait;
    end process;
end dtb;