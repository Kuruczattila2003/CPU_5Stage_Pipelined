`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 18:47:49
// Design Name: 
// Module Name: MemoryStage
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


module MemoryStage(
        input logic clk,
        input logic reset,
        
        //From Execute Stage
        input logic [31:0] ALUResE,
        input logic [31:0] WriteDataE,
        input logic [31:0] PCPlus4E,
        input logic [4:0] RDE,
        //CU 
        input logic RegisterFileWEE,
        input logic [1:0] ResultSrcE,
        input logic MemoryWEE,
        
        //output
        output logic [31:0] ALUResM,
        output logic [31:0] MemoryDataM,
        output logic [4:0] RDM,
        output logic [31:0] PCPlus4M,
        //CU
        output logic RegisterFileWEM,
        output logic [1:0] ResultSrcM
        
    );
    
    
    logic MemoryWEM;
    logic [31:0] WriteDataM;
    
    PipelineRegister #(.WIDTH(101+4)) memoryRegister(
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .D({ALUResE, WriteDataE, PCPlus4E, RDE,/*CU*/ RegisterFileWEE, ResultSrcE, MemoryWEE}),
        .Q({ALUResM, WriteDataM, PCPlus4M, RDM,/*CU*/ RegisterFileWEM, ResultSrcM, MemoryWEM})
    );
    
    DataMemory dataMemory(
        .clk(clk),
        .WE(MemoryWEM),

        .A(ALUResM),
        .WD(WriteDataM),
        .RD(MemoryDataM)
    );
    
endmodule
