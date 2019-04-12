Readme

To run the project, just import every system verilog file in this folder into a model sim project.  We only changed the original testbench in areas where the name of one of our modules or wires was different from something in the test bench such as CLK instead of clk etc.  Nothing else was added.

Also make sure to change the directory name in inst_rom2.sv to the directory where the machine code is located.  The machine code is provided as Machine3.txt in this folder. The assembly code is also provided along with the assembler written in python as Assymbly.txt and Lab.3 py respectively. The diagram pdf from quartus of our design is also given.  There is also a text file stating which registers were used for what in each program.  The ones that weren't mentioned were used as temp registers.  Register 14 was used to hold the rightmost 8 bits of every even line of machine code because we used 2 lines of machine code per instruction. 

All three programs work with no errors.
