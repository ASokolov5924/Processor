// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
module ALU(
  input [ 7:0] INPUTA,      	  // data inputs
               INPUTB,
  input [12:0] PC,
  input [ 3:0] OP, // ALU opcode, part of microcode
  input [4:0]         INPUTC,				  
  input        SC_IN,             // shift in/carry in 
  output logic [7:0] OUT,		  // or:  output reg [7:0] OUT,
  output logic SC_OUT,			  // shift out/carry out
  output logic BEQ,              // zero out flag
  output logic BGT              // LSB of input B = 0
    );

  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewin
	
  always_comb begin
            
// single instruction for both LSW & MSW
	  if(PC%2 ==1) begin
		  case(OP)
			kADD :begin
				if(INPUTC[0] == 0)
					{SC_OUT, OUT} = {1'b0,INPUTA} + {1'b0,INPUTB};  // add w/ carry-in & out
				else
				   {SC_OUT, OUT} = {1'b0,INPUTA} + {1'b0,INPUTB} + SC_IN;	
				BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;				
      end
			kLSHC : begin 
			{SC_OUT, OUT} = {INPUTA, SC_IN};  	            // shift left carry
				BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;
			end
			kLSH : begin
			 {SC_OUT, OUT} = {INPUTA, 1'b0};  	            // shift left 
			 	BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;
			end

			 //kRSH : {OUT, SC_OUT} = {SC_IN, INPUTA};			        // shift right
		//  kRSH : {OUT, SC_OUT} = (INPUTA << 1'b1) | SC_IN;
		 //	 kXOR : begin 
		 //	         OUT    = INPUTA^INPUTB;  	     			   // exclusive OR
		//			 SC_OUT = 0;					   		       // clear carry out -- possible convenience
		//		   end
		   
		   kSUB : begin
			   if(INPUTC[0]==0)
				{SC_OUT, OUT}    = {1'b0,INPUTA} + {1'b0,(~INPUTB)} + 1;	       // check me on this!
			   else
				{SC_OUT, OUT}    = {1'b0,INPUTA} + {1'b0,(~INPUTB)} + SC_IN;

				BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;	
		   end
		  
		   kADDi : begin 
			  {SC_OUT, OUT} = {1'b0,INPUTA} + {1'b0,INPUTC} ;  // add w/ carry-in & out
				BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;
			 end
		  
		   
		   kcmp : begin 
				BGT = (INPUTA > INPUTB) ? 1 : 0;  // add w/ carry-in & out
				BEQ = (INPUTA == INPUTB) ? 1 : 0;  // add w/ carry-in & out

				SC_OUT = SC_OUT ? 1 : 0;
				OUT = 8'b0;
		   end

			default: begin 
				SC_OUT = SC_OUT ? 1 : 0;
				OUT = 8'b0;

				BEQ = BEQ ? 1 : 0;
				BGT = BGT ? 1 : 0;
		  end 
		  endcase
	  end
	  
	  else begin

			SC_OUT = SC_OUT ? 1 : 0;
			OUT = 8'b0;

			BEQ = BEQ ? 1 : 0;
			BGT = BGT ? 1 : 0;
		end
	  
  end
  
  
  

endmodule
