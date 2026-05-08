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

module Datapath(
    input logic clk,
    input logic reset,
    
    //Fetch Stage
    input logic StallF, //Hazard Unit
    
    //Decode Stage
    input logic StallD,  //Hazard Unit
    input logic RegisterFileWE //Control Unit
);
    
    //--- Fetch Stage ---
    logic [31:0] InstrF;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF;
    
    FetchStage fetchStage(
        .clk(clk),
        .reset(reset),
        .StallF(StallF),
        
        //select signals
        .PCSrcE(PCSrcE), //from EXECUTE stage based on (Zero flag + branch, or jump)
        
        //input from EXECUTE stage
        .PCPlusImmE(PCPlusImmE), //PC + Immediate value from Execute stage
        
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCF(PCF)
    );


    //--- Decode Stage ---
    input logic [31:0] RD1D;
    input logic [31:0] RD2D;
    input logic [4:0] RSrc1D, RSrc2D, RDD;
    input logic [31:0] ImmExtD;
    input logic [31:0] PCPlus4D;
    input logic [31:0] PCD;

    DecodeStage decodeStage(
        .clk(clk),
        .reset(reset),
        
        //From Fetch Stage
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCF(PCF),
        
        //From Writeback stage -> because of Register File
        .RDW(RDW),
        .ResultW(ResultW),
        
        //Control Unit
        .RegisterFileWE(RegisterFileWE),
        
        //Hazard Unit
        .StallD(StallD),
        
        //outputs
        .RD1D(RD1D),
        .RD2D(RD2D),
        
        .RSrc1D(RSrc1D),
        .RSrc2D(RSrc2D),
        .RDD(RDD),
        
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .PCD(PCD)
    );
    
    //--- Execute Stage ---
    logic PCSrcE;
    logic [31:0] PCPlusImmE;
    
    //--- Memory Stage ---
    
    
    //--- Writeback Stage ---
    logic [4:0] RDW;
    logic [31:0] ResultSrcW;

endmodule