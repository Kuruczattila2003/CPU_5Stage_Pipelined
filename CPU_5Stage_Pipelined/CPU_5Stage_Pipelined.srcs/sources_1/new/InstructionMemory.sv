`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 21:25:03
// Design Name: 
// Module Name: InstructionMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory(
        input logic [31:0] A,
        output logic [31:0] RD    
    );
    
    logic [31:0] RAM [1023:0];
    
    always_comb begin
        RD = RAM[A[11:2]];
    end 
    
    initial begin
        $readmemh("program.mem", RAM);
    end
    
endmodule
