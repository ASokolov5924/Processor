//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map

    // his
    // STORE bits     00111
    // Reg write = 1
    const logic [4:0]kADD  = 4'b0000;
    const logic [4:0]kLSHC  = 4'b0001;
    const logic [4:0]kLSH  = 4'b0010;
	const logic [4:0]kSUB  = 4'b0011;
    const logic [4:0]kADDi  = 4'b0100;
    const logic [4:0]kld  = 4'b0101;

    // Start of reg write = 0
    const logic [4:0]kst  = 4'b0110;
    const logic [4:0]kjmp  = 4'b0111;
    const logic [4:0]kcmp  = 4'b1000;
    const logic [4:0]kbeq  = 4'b1001;
    const logic [4:0]kbne  = 4'b1010;
    const logic [4:0]kblt  = 4'b1011;
    const logic [4:0]kble  = 4'b1100;
    const logic [4:0]kbgt  = 4'b1101;
    const logic [4:0]kbge  = 4'b1110;
    const logic [4:0]kLABL  = 4'b1111;

// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        ADD, LSHC, LSH, 
         SUB,  ADDi, 
          ld, st, 
        jmp, cmp, beq, bne, 
        blt, ble, bgt, bge, LABL } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
