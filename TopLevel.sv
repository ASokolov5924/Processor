// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input     start,	   // init/reset, active high
	input     CLK,		   // clock -- posedge used inside design
    output    halt		   // done flag from DUT
    );

wire [ 12:0] PC;            // program count
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] regWriteValue, // data in to reg file
            memWriteValue, // data in to data_memory
	   	    Mem_Out;	   // data out from data_memory
wire [1:0]  prog_state;
wire[7:0]read_inst;
wire [7:0] prev_inst;
 

          
wire        MEM_READ,	   // data_memory read enable
		    MEM_WRITE,	   // data_memory write enable
			reg_wr_en,	   // reg_file write enable
			sc_clr,        // carry reg clear
			sc_en,	       // carry reg enable
		    SC_OUT,	       // to carry register
			BEQ,		   // ALU output = 0 flag
			BGT,		   // ALU input B is greater than
            jump_en;	   // to program counter: jump enable
		

       
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU)



   statemach Machine1 (
       .CLK,
	   .init (start),
	   .prog_state
	  
   );
// Fetch = Program Counter + Instruction ROM
// Program Counter
  PC PC1 (
	.init       (start), 
	.halt              ,  // SystemVerilg shorthand for .halt(halt), 
	.jump_en           ,  // jump enable
	.BEQ,
	.BGT,
	.prog_state        ,
	.CLK        (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.OP      (prev_inst[7:4]),
	.instr1 (prev_inst[3:0]),
	.instr2 (Instruction),
	.PC             	  // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
		.OP      (prev_inst[7:4]),
		.CLK,
		.BEQ,			 // from ALU: result = 0
		.BGT,			 // from ALU: input B is even (LSB=0)
		.PC,
		.jump_en		 // to PC
		
		
	//	.reg_wr_en
  );
// instruction ROM
  InstROM instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	
	);
  
  assign load_inst = prev_inst[7:4]==4'b0101;  // calls out load specially
  

    
	reg_file #(.W(8),.D(4)) reg_file1 (
		.CLK    				  ,
		.write_en  (reg_wr_en)    , 
		 .PC,
		.raddrA    ({Instruction[8:5]}),         //concatenate with 0 to give us 4 bits
		.raddrB    ({Instruction[4:1]}), 
		.waddr     ({prev_inst[3:0]}), 	  // mux above
		.data_in   (regWriteValue) , 
		.inst_in (Instruction),
		.data_outA (ReadA        ) , 
		.data_outB (ReadB		 ),
		.read_inst
	);
	assign prev_inst = read_inst; //connect the instruction read from register file to the rest of the modules


    assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = ReadB; //IMM_EN ? IMM_VAL : ReadB;
	assign MEM_WRITE = (prev_inst[7:4] == 4'b0110);     //store op code   // mem_store command
	assign reg_wr_en = (prev_inst[7:4]>4'b0101) ? 0 : 1;  //load op code      // mem_store command
	
	assign MEM_READ = (prev_inst[7:4]==4'b0101);  //looad op code      
	assign regWriteValue = load_inst ? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB), 
		.INPUTC  (Instruction[4:0]), 
	  .OP      (prev_inst[7:4]),
	  .OUT     (ALU_out),
	  .SC_IN   ,
	  .SC_OUT  ,
	  .BEQ ,
	  .BGT,
	  .PC
	  );
  
	data_mem data_mem1(
		.DataAddress  (ReadA)    ,  // actual value
		.ReadMem      (MEM_READ),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (ReadB), 
		.DataOut      (Mem_Out)  , 
		.CLK 		  		   ,
        .PC		

	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

always @(posedge CLK) begin   // carry/shift in/out register
    SC_IN <= SC_OUT;        // update the carry  
end

endmodule
