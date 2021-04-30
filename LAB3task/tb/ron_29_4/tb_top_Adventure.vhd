library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.aux_package.all;

entity top_tb is
	generic ( T : time := 50 ns);--Period time (switching every 25 ns)
    constant n : integer := 8 ;
end top_tb;
architecture ttb of top_tb is

--inputs/outputs:
	signal rst : std_logic;
    signal clk:std_logic:='1';
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); 
	--------------------delete testing-------------------------
    signal Input,One : std_logic;
	signal OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
    signal counter_out,reg_b_out,reg_c_out:STD_LOGIC_VECTOR(n-1 downto 0); -- testing
	signal opc_out : STD_LOGIC_VECTOR(2 downto 0);
    -----------------------------------------------------------
--read/write signals:


    signal TrigR : std_logic;                       --triggers reading from input file
    signal done : boolean := false;                 --turns true when reaching end of input file
    constant read_file_location : string(1 to 56) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3task\inputFile.txt";
    constant write_file_location : string(1 to 57) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3task\outputFile.txt"; 
   
    begin
    L0 : top generic map (n) port map(rst,clk,DATAin,DATAout,counter_out,reg_b_out,reg_c_out,opc_out,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout);
    
    clk <= not(clk) after T/2;   --infinite clock generation (Page 17 'file based sim')
    TrigR <= clk'delayed(T/4);    --TrigR defined as a delayed version of clk

--initialize and switch reset:
    reset : process         
        begin
		  rst <= '1';
		  wait for 5 ns ; 
		  rst <= not rst;
		  wait;
        end process;

-------------------------------------------------------------------------------------------        
-- Read Trigger Explenation: if there is only one line then endfile is true immediatly
-- so we make a loop checking the length of the current line (line is of access string
-- type so it changes dynamically) and it has 0 length when reaching the end of current line.
--(see VHDL Golden ref page 117 Tips)
-------------------------------------------------------------------------------------------

--Read:
    ReadTrigger : process 
        file infile : text open read_mode is read_file_location;
        variable L : line;
        variable datainV : integer;
        variable temp_endfile: boolean;
        begin
        readline(infile,L);                             -- Save line   
--Read through current line:   
        while (L'length /= 0) loop                      -- Check if reached the end of L
            read(L,datainV);                            -- Read element from line to datainV
            wait until (TrigR'event and TrigR='1');       -- Triggered by TrigR
            DATAin<=conv_std_logic_vector(datainV, n);  -- Insert reading
        end loop;
        temp_endfile := endfile(infile);
        if (endfile(infile)) then                       -- Check if reached the end of file
            done <= true;                               -- Used in WriteTrigger
            file_close(infile);                         -- Close input file
            report "end of input file" severity note;   -- "End" message
            wait;                                       -- Don't continue
        end if;
    end process;

-------------------------------------------------------------------------------------------        
-- Write Trigger Explenation: A 'transaction' is made everytime a signal is assigned to 
-- DATAout. When that happens time first we open a new line and then the loop writes elements
-- one at a time to that line. The loop breaks when we are finished with the input file,
-- We right the entire line to the output file and then close the file and give out a message.
-------------------------------------------------------------------------------------------
    
    WriteTrigger : process                              
        file outfile : text open write_mode is write_file_location;
        variable outline : line;
        begin
        while (Done /= true) loop                           -- See if we are still going through infile
            wait until (DATAout'transaction='1');               -- Wait until a signal is assigned to DATAout
            write(outline, conv_integer(signed(DATAout)));  -- Write current DATAout to line
        end loop;
        writeline(outfile,outline);                         -- Write line to file
        file_close(outfile);                                -- Close file
        report "finished writing to output file" severity note;    
    end process;
end ttb;

-------------------------------------------------------------------------------------------
-- Main Differences from "tb_top_ver1try" (and justifications):
-- 1. Definition of clk as concurrent state - makes codes cleaner and easier to change
-- 2. Definition of TrigR as std_logic using "'delayed" attribute - cleaner code and i want to see if it works

-- Chnges to WriteTrigger: the way we do it in "tb_top_ver1try" means everytime we get a change in DATAout
-- we write DATAout to a line and load the line to the file, that means we will get a line for each argument.
-- The second thing is we dont know if when DATAout is changes to the same value we get an event and the
-- 'transaction attribute should solve that. In this version the loop is only loading elements to the same 
-- lines and only when we exit the loop the full line is loaded to the outfile.
-- Notice that with the new definition of ReadTrigger Done won't be changed until we are done loading all the
-- elements of the last line (even if there is only one).

-- The idea of ReadTrigger and WriteTrigger :

-- Only 1 line:
-- Endfile is true from the start but Done isn't, we enter the loop until line is finished (length=0), 
-- during the "read loop", WriteTrigger is  writing the result values in outline in his loop because Done is still FALSE.
-- when we finished reading the elements of that only line we exit the loop and change Done to TRUE, now the writing 
-- loop stops and uploads that line to the file.

-- Multiple lines:
-- Endfile is False so we enter read loop and write first line, in that time the writing loop 
-- writes results to a line and cannot exit because Done is FALSE when reading loop is still working.
-- when reading loop is finished we dont change Done because Endfile is still FALSE (we have another line).
-- When we start last line Endfile turns TRUE but only when we finished reading through the last line and exit 
-- the reading loop we change Done to TRUE so the writing loop can exit and write the line to the file. 
-- NOTE: this way no matter how much input we get the output will be one line, maybe a very long one.

-------------------------------------------------------------------------------------------