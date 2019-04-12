// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 3:0] OP,	   // machine code

  input       CLK,
              BEQ,			   // ALU out[7:0] = 0
              BGT,
  input[12:0]  PC,			  // ALU out[0]   = 0
              
  output logic jump_en
              
    //           reg_wr_en
  );

 /* always @(posedge CLK)   // carry/shift in/out register
    if(OP == kjmp || OP == kst)				// tie sc_clr low if this function not needed
      reg_wr_en <= 0;  
    else
      reg_wr_en <= 1;*/

// jump on right shift that generates a zero
always_comb begin
  if(OP == kjmp  && PC %2 ==1)
    jump_en = 1;
  else
    jump_en = 0;
end

// branch every time ALU result LSB = 0 (even)
//assign branch_en = BEVEN;*/

endmodule

   // ARM instructions sequence
   //				cmp r5, r4
   //				beq jump_label