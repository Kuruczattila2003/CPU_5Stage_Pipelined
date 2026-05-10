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
    
    //Control Unit
    input logic RegisterFileWED,
    input logic [1:0] ResultSrcD,
    input logic MemoryWED,
    input logic JumpD,
    input logic BranchD,
    input logic [2:0] ALUControlD,
    input logic ALUSrcBED,
    
    //Hazard Unit
    //Fetch Stage
    input logic StallF, //Hazard Unit
    //Decode Stage
    input logic StallD,  //Hazard Unit
    input logic FlushD,
    //Execute Stage
    input logic [1:0] FordwardAE, //Hazard Unit
    input logic [1:0] FordwardBE, //Hazard Unit
    input logic StallE, //Hazard Unit
    input logic FlushE,
    
    //output
    output logic [31:0] InstrD,
    output logic [4:0] RSrc1D, RSrc2D,
    output logic [4:0] RSrc1E, RSrc2E,
    output logic [4:0] RDE, RDM, RDW,
    output logic RegisterFileWEM, RegisterFileWEW,
    output logic [1:0] ResultSrcE,
    output logic PCSrcE
);
    
    //--- Fetch Stage Outputs ---
    logic [31:0] InstrF;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF;
    
    //--- Decode Stage Outputs ---
    logic [31:0] RD1D;
    logic [31:0] RD2D;
    logic [4:0]  RSrc1D, RSrc2D, RDD;
    logic [31:0] ImmExtD;
    logic [31:0] PCPlus4D;
    logic [31:0] PCD;
    logic [31:0] InstrD;

    //--- Execute Stage Outputs ---
    logic        PCSrcE;
    logic [31:0] PCPlusImmE;
    logic [31:0] ALUResE;
    logic [31:0] WriteDataE;
    logic [4:0]  RDE;         // FIXED: Was incorrectly declared as [31:0]
    logic [31:0] PCPlus4E;
    //CU
    logic        RegisterFileWEE;
    logic [1:0]  ResultSrcE;
    logic        MemoryWEE;

    //--- Memory Stage Outputs ---
    logic [31:0] ALUResM;
    logic [31:0] MemoryDataM;
    logic [4:0]  RDM;
    logic [31:0] PCPlus4M;
    //CU
    logic        RegisterFileWEM;
    logic [1:0]  ResultSrcM;

    //--- Writeback Stage Outputs ---
    logic [31:0] ResultW;
    logic        RegisterFileWEW;
    logic [4:0]  RDW;
    
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
    DecodeStage decodeStage(
        .clk(clk),
        .reset(reset),
        
        //From Fetch Stage
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCF(PCF),
        
        //From Writeback stage -> because of Register File
        .RDW(RDW),
        .ResultSrcW(ResultW),
        
        //Control Unit
        .RegisterFileWEW(RegisterFileWEW),
        //Hazard Unit
        .StallD(StallD),
        .FlushD(FlushD),
        
        //outputs
        .RD1D(RD1D),
        .RD2D(RD2D),
        
        .RSrc1D(RSrc1D),
        .RSrc2D(RSrc2D),
        .RDD(RDD),
        
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .PCD(PCD),
        .InstrD(InstrD)
    );
    
    //--- Execute Stage ---
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
        .ResultSrcW(ResultW),
        
        //From Hazard Unit
        .ForwardAE(FordwardAE),
        .ForwardBE(FordwardBE),
        .StallE(StallE),
        .FlushE(FlushE),
                
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
        .MemoryWEE(MemoryWEE),
        .PCSrcE(PCSrcE),
        .RSrc1E(RSrc1E),
        .RSrc2E(RSrc2E)
    );
    
    //--- Memory Stage ---
    MemoryStage memoryStage(
        .clk(clk),
        .reset(reset),
        
        //From Execute Stage
        .ALUResE(ALUResE),
        .WriteDataE(WriteDataE),
        .PCPlus4E(PCPlus4E),
        .RDE(RDE),
        
        //CU Inputs 
        .RegisterFileWEE(RegisterFileWEE),
        .ResultSrcE(ResultSrcE),
        .MemoryWEE(MemoryWEE),
        
        //Outputs
        .ALUResM(ALUResM),
        .MemoryDataM(MemoryDataM),
        .RDM(RDM),
        .PCPlus4M(PCPlus4M),
        
        //CU Outputs
        .RegisterFileWEM(RegisterFileWEM),
        .ResultSrcM(ResultSrcM)
    );
    
    
    //--- Writeback Stage ---
    WritebackStage writebackStage(
        .clk(clk),
        .reset(reset),
        
        //From Memory Stage
        .PCPlus4M(PCPlus4M),
        .RDM(RDM),
        .MemoryDataM(MemoryDataM),
        .ALUResultM(ALUResM), // Mapped ALUResM to ALUResultM port
        
        //CU Inputs
        .RegisterFileWEM(RegisterFileWEM),
        .ResultSrcM(ResultSrcM),
        
        //Outputs routed back to Decode & Forwarding
        .ResultW(ResultW),
        .RegisterFileWEW(RegisterFileWEW),
        .RDW(RDW)
    );

endmodule