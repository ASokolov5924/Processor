// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63

import definitions::*;			  // includes package "definitions"

module PC(
  input init,
        jump_en,		// relative
		BEQ,
		BGT,
		CLK,
    input [1:0] prog_state,
	input [3:0] OP,
	input [3:0] instr1,
	input [8:0] instr2,
  output logic halt,
  output logic[ 12:0] PC);

always @(posedge CLK) begin
  if(init) begin
  
		halt <= 0;
		if(prog_state==0)
		   PC<=0;
		else if(prog_state ==1)
		   PC<= 174;
		else if(prog_state ==2)
		   PC<= 336;
		
    //$display("Progpog %d \n",prog_state);
  end
   
	else if(PC == 173 || PC  == 335 || PC ==461) 
		halt <= 1;
	else if(PC % 2 == 0)
		PC <=PC+1;
	else if(jump_en) begin
			PC <= {instr1,instr2}+2;
	end
	else if(OP == kbeq) begin
			PC <= BEQ ? {instr1,instr2}+2 : PC+1;
	end
	else if(OP == kbne) begin
			PC <= BEQ ? PC+1 : {instr1,instr2}+2;
	end
	else if(OP == kbgt) begin
			PC <= BGT ? {instr1,instr2}+2 : PC+1;
	end
	else if(OP == kbge) begin
			PC <= (BGT || BEQ) ? {instr1,instr2}+2 : PC+1;
	end
	else if(OP == kblt) begin
			PC <= (BGT || BEQ) ? PC+1 : {instr1,instr2}+2;
	end
	else if(OP == kble) begin
			PC <= BGT ? PC+1 : {instr1,instr2}+2;
	end
	else
		PC <= PC+1;
end 
		



endmodule