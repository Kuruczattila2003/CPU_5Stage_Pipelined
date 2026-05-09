`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2026 16:19:06
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
        input logic clk,
        input logic WE,
        input logic [4:0] A1, A2, A3,
        input logic [31:0] WD3,
        
        output logic [31:0] RD1, RD2
    );
    
    logic [31:0] RAM [31:0];
    
    //read
    // Read Port 1
    assign RD1 = (A1 == 5'b0) ? 32'b0 :
                 ((A1 == A3) && WE) ? WD3 :
                 RAM[A1];

    // Read Port 2
    assign RD2 = (A2 == 5'b0) ? 32'b0 :
                 ((A2 == A3) && WE) ? WD3 
                 : RAM[A2];
    
    //write
    always_ff @(posedge clk) begin
        if(WE && (A3 != 5'b0)) begin
            RAM[A3] <= WD3;
        end
    end
    
endmodule
