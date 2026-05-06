`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 20:26:01
// Design Name: 
// Module Name: FlipFlop_32bit
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


module FlipFlop_32bit(
        input logic clk,
        input logic reset,
        input logic en,
        input logic [31:0] D,
        output logic [31:0] Q 
    );
    
    always_ff @(posedge clk) begin
        if(reset) begin
            //reset
            Q <= 32'b0;
        end
        else if(en) begin
            //enabled
            Q <= D;    
        end
        else begin
            //not enabled
            Q <= Q;
        end
    end
    
endmodule
