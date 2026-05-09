`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 18:52:12
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
        input logic clk,
        input logic WE,

        input logic [31:0] A,
        input logic [31:0] WD,
        output logic [31:0] RD
    );
    
    logic [31:0] RAM [1023:0];
    
    //initialize memory
    initial begin
        $readmemh("memory_data.mem", RAM);
    end
    
    always_ff @(posedge clk) begin
        if(WE) begin
            RAM[A[11:2]] <= WD;
        end
    end
    
    assign RD = RAM[A[11:2]];
    
    
endmodule
