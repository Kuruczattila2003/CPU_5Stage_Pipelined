`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 13:55:26
// Design Name: 
// Module Name: DecodeStage
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


module DecodeStage(
        input logic clk,
        input logic reset,
        
        //From Fetch Stage
        input logic [31:0] InstrF,
        input logic [31:0] PCPlus4F,
        input logic [31:0] PCF,
        
        //From Writeback stage -> because of Register File
        input logic [4:0] RDW,
        input logic [31:0] ResultSrcW,
        
        //Control Unit
        input logic RegisterFileWEW,
        
        //Hazard Unit
        input logic StallD,
        
        //outputs
        output logic [31:0] RD1D,
        output logic [31:0] RD2D,
        
        output logic [4:0] RSrc1D,
        output logic [4:0] RSrc2D,
        output logic [4:0] RDD,
        
        output logic [31:0] ImmExtD,
        output logic [31:0] PCPlus4D,
        output logic [31:0] PCD
    );
   
   logic [31:0] InstrD;
    
    PipelineRegister #(.WIDTH(93)) decodeRegister(
        .clk(clk),
        .reset(reset),
        .en(~StallD),
        .D({PCF, PCPlus4F, InstrF}),
        .Q({PCD, PCPlus4D, InstrD})
    );
    
    assign RSrc1D = InstrD[19:15];
    assign RSrc2D = InstrD[24:20];
    assign RDD = InstrD[11:7];
    RegisterFile registerFile(
        .clk(clk),
        .WE(RegisterFileWEW),
        .A1(RSrc1D), 
        .A2(RSrc2D), 
        .A3(RDW),
        .WD3(ResultSrcW),
        
        .RD1(RD1D), 
        .RD2(RD2D)
    );
    
    
    Extender extender(
        .opcode(InstrD[6:0]),
        .instr(InstrD[31:7]),
        .Q(ImmExtD)
    );
    
endmodule
