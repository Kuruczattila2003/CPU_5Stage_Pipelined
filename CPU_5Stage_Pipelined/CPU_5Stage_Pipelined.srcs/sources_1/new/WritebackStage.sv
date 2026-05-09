`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2026 16:05:09
// Design Name: 
// Module Name: WritebackStage
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


module WritebackStage(
        input logic clk,
        input logic reset,
        
        input logic [31:0] PCPlus4M,
        input logic [4:0] RDM,
        input logic [31:0] MemoryDataM,
        input logic [31:0] ALUResultM,
        //CU
        input logic RegisterFileWEM,
        input logic [1:0] ResultSrcM,
        
        //output
        output logic [31:0] ResultW,
        output logic RegisterFileWEW,
        output logic [4:0] RDW
    );
    
    logic [31:0] ALUResultW;
    logic [31:0] MemoryDataW;
    logic [31:0] PCPlus4W;
    logic [1:0] ResultSrcW;
    
    PipelineRegister #(.WIDTH(101+3)) writebackRegister(
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .D({ALUResultM, MemoryDataM, RDM, PCPlus4M,/*CU*/ RegisterFileWEM, ResultSrcM}),
        .Q({ALUResultW, MemoryDataW, RDW, PCPlus4W,/*CU*/ RegisterFileWEW, ResultSrcW})
    );
    
    mux4_1_32bit ResultSrcMux(
        .a(ALUResultW),
        .b(MemoryDataW),
        .c(PCPlus4W),
        .d(32'b0),
        .s(ResultSrcW),
        .q(ResultW)
    );
    
endmodule
