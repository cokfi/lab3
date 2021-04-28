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

architecture rtb of tb is
	signal clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); -- Note: Consider changin type to int
begin
    L0 : top generic map (n) port map(clk,OPCin,OPC2,OPC1,Ld,Bin,Cout,DATAin,Input,One,DATAout);

--------- start of stimulus section ------------------	
    gen_clk : process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= not clk;
        wait for 50 ns;
    end process;
---------Control Simulation ------------------	State Path: Idle => SetN => First => ALU(x7) => Done
    OPCinSim : process
    begin  
        OPCin<='1';
        wait for 50 ns;--50 ns
        OPCin<='0';
        wait for 450 ns;
        OPCin<='1';--500 ns
    end process;
    OPC2Sim: process
    begin
        OPC2<='0';
        wait for 150 ns;--150 ns
        OPC2<='1';
        wait for 350 ns;--500 ns
        OPC2<='0';
    end process;
    OPC1Sim : process
    begin
        OPC1<='0';
        wait for 50 ns;--50 ns
        OPC1<='1';
        wait for 100 ns;--150 ns
        OPC1<='0';
    end process;
    LdSim : process
    begin
        Ld<='0';
        wait for 50 ns;--50 ns
        Ld<='1';
        wait for 50 ns;--100 ns
        Ld<='0';
    end process;
    BinSim : process
    begin
        Bin<='0';
        wait for 50 ns;--50 ns
        Bin<='1';
        wait for 450 ns;--500 ns
        Bin<='0';
    end process;
    CoutSim : process
    begin
        Cout<='0';
        wait for 500 ns;--500 ns
        Cout <='1';
    end process; 

---------Input Simulation ------------------	
    InputGen : process
    begin
        DATAin<= (0=>'1',others=>'0');--Opcode for sum
        wait for 50 ns;
        DATAin<=8;--m=8        
        wait for 50 ns;--Input new number every clk cycle 
        DATAin<=1;--First number
        wait for 50 ns; 
        DATAin<=2;
        wait for 50 ns; 
        DATAin<=4;
        wait for 50 ns; 
        DATAin<=8;
        wait for 50 ns; 
        DATAin<=16;
        wait for 50 ns; 
        DATAin<=32;
        wait for 50 ns; 
        DATAin<=64;
        wait for 50 ns; 
        DATAin<=128;--Last number
        wait for 50 ns; 
        DATAin<= (others=>'0');--Opcode 000
    end process;
end rtb;