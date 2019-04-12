// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

module reg_file #(parameter W=8, D=4)(		 // W = data path width; D = pointer width
  input           CLK,
                  write_en,
  input [12:0]	 PC,
  input  [ D-1:0] raddrA,
                  raddrB,
                  waddr,
  input  [ W-1:0] data_in,
  input [8:0] inst_in,
  output [ W-1:0] data_outA,
  output logic [W-1:0] data_outB,
  output logic [7:0] read_inst
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] registers[2**D];	  // or just registers[16] if we know D=4 always

// combinational reads w/ blanking of address 0
assign data_outA = (raddrA && (PC%2==1)) ? registers[raddrA] : '0;	 // can't read from addr 0, just like MIPS
assign data_outB = (raddrB && (PC%2==1)) ? registers[raddrB] : '0;               // can read from addr 0, just like ARM
assign read_inst = registers[14];
// sequential (clocked) writes 
always_ff @ (posedge CLK) begin
  if (write_en && waddr && (PC%2==1))	                             // && waddr requires nonzero pointer address
    registers[waddr] <= data_in;
  if (PC%2==0)
	registers[14]  <= inst_in[7:0];
end
endmodule
