module statemach(input CLK, input init,
        output logic[1:0] prog_state = 0);

logic[1:0] next_prog_state;

always_comb next_prog_state = prog_state + 2'b01;

always @(negedge init) 
  prog_state <= next_prog_state;   // prog_state cycles through 1, 2, 3 following the init pulses the test bench provides

//Note: you may not even need this if you concatenate your three programs such that each init merely continues from where the last program left off. Another option is to key the reset-on-init in your program counter to prog_state, as well, viz:
endmodule  

