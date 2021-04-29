library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity top_tb is
	generic ( T : time := 50 ns);--Period time (switching every 25 ns)
    constant (n : integer : 8 );
end top_tb;
----------------inputs/outputs---------------------------------------
architecture ttb of top_tb is
	signal clk,rst : std_logic;
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); 
    signal Cout_spy : std_logic :='0'; --signal to follow Cout inside top
----------------read/write signals---------------------------------------
    signal TrigR : boolean := true;--triggers reading from input file
    signal done : boolean := false;--turns true when reaching end of input file
    constant read_file_location : string(1:38) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3 task\inputFile.txt";
    constant write_file_location : string(1:38) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3 task\outputFile";

    begin
    L0 : top generic map (n) port map(clk,rst,DATAin,DATAout);
    Cout_spy <= <<signal .tb.top.Control.Cout : std_logic>>; -- '<< >>' calls for internal signals
    
    gen_clk : process
        begin
		  clk <= '0';
		  wait for T/2 ns; --T/2 = 50 ns
		  clk <= not clk;
		  wait for T/2 ns;
        end process;
    
    gen_TrigR : process(clk'event and clk='1') --TrigR= clk(t-T/4), T=100ns => T/4=25 ns => TrigR=clk(t-25)
        begin
            wait for T/4 ns; --T/4 = 25 ns
            TrigR<=not(TrigR);
        end process;
    
    ReadTrigger : process(clk'event and clk='1')
        file infile : text open read_mode is read_file_location;
        variable L : line;
        variable datainV : integer;

        begin
            --wait for 25 ns;
            if(not endfile) then --check if reached the end of input file
                readline(infile,L); -- save line   
                read(L,datainV); -- read element from line
            else    -- if reached the end of file
                done <= true;
                file_close(infile);
                report "end of input file" severity note;
                wait;
            end if;
            wait until (TrigR'event and TrigR=true);--Triggered by TrigR
            DATAin<=to_stdlogicvector(datainV);
        end process;

   
    
    WriteTrigger : process(Cout_spy'event and Cout_spy='0')--triggered by Cout falling edge, need to figure out how
        file outfile : text open write_mode is write_file_location;
        variable outline : line;
        begin
            write(outline, signed(DATAout));
            writeline(outfile,outline);
        if (done = true) then
            file_close(outfile);
            report "finished writing to output file" severity note;
            wait;
        end if;
        end process;
end ttb;