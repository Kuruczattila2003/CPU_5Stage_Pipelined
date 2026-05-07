`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2026 15:40:50
// Design Name: 
// Module Name: PipelineRegister
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



module PipelineRegister #(parameter WIDTH = 32) (
    input  logic clk,
    input  logic reset,
    input  logic en,
    input  logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q
);

    always_ff @(posedge clk) begin
        if (reset) begin
            Q <= '0;
        end
        else if (en) begin
            Q <= D;
        end
    end
endmodule
