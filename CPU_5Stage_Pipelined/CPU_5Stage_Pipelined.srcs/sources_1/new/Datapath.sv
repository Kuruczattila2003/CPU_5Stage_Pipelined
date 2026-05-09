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
    //CU
    input logic RegisterFileWED,
    input logic [1:0] ResultSrcD,
    input logic MemoryWED,
    input logic JumpD,
    input logic BranchD,
    input logic [2:0] ALUControlD,
    input logic ALUSrcBED,
    
    //Execute Stage
    input logic [2:0] ALUControl, //Control Unit
    input logic ALUSrcBE, //Control Unit
    input logic [1:0] FordwardAE, //Hazard Unit
    input logic [1:0] FordwardBE, //Hazard Unit
    input logic StallE //Hazard Unit
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
    logic [31:0] RD1D;
    logic [31:0] RD2D;
    logic [4:0] RSrc1D, RSrc2D, RDD;
    logic [31:0] ImmExtD;
    logic [31:0] PCPlus4D;
    logic [31:0] PCD;

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
        .RegisterFileWEW(RegisterFileWEW),
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
    logic [31:0] ALUResE;
    logic [31:0] WriteDataE;
    logic [31:0] RDE;
    logic [31:0] PCPlus4E;
    //CU
    logic RegisterFileWEE;
    logic [1:0] ResultSrcE;
    logic MemoryWEE;
    
    ExecuteStage executeStage(
        //From Decode Stage
        .clk(clk),
        .reset(reset),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .RSrc1D(RSrc1D),
        .RSrc2D(RSrc2D),
        .RDD(RDD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .PCD(PCD),
        
        //From Memory Stage
        .ALUResM(ALUResM),
        
        //From Writeback Stage
        .ResultSrcW(ResultSrcW),
        
        //From Hazard Unit
        .FordwardAE(FordwardAE),
        .FordwardBE(FordwardBE),
        .StallE(StallE),
                
        //output
        //For Fetch Stage
        .PCPlusImmE(PCPlusImmE),
        //For Memory Stage
        .ALUResE(ALUResE),
        .WriteDataE(WriteDataE),
        .RDE(RDE),
        .PCPlus4E(PCPlus4E),
        
        //Control Unit pipelining
        .RegisterFileWED(RegisterFileWED),
        .ResultSrcD(ResultSrcD),
        .MemoryWED(MemoryWED),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcBED(ALUSrcBED),
        
        .RegisterFileWEE(RegisterFileWEE),
        .ResultSrcE(ResultSrcE),
        .MemoryWEE(MemoryWEE)
    );
    
    //--- Memory Stage ---
    logic [31:0] ALUResM;
    
    //--- Writeback Stage ---
    logic [4:0] RDW;
    logic [31:0] ResultSrcW;

endmodule