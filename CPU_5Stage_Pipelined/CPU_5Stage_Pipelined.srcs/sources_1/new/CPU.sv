`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 17:14:54
// Design Name: 
// Module Name: CPU
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


module CPU(
        input logic clk,
        input logic reset
    );
    
    //--- ControlUnit output ---
    logic RegisterFileWED;
    logic [1:0] ResultSrcD;
    logic MemoryWED;
    logic JumpD;
    logic BranchD;
    logic [2:0] ALUControlD;
    logic ALUSrcBD;
    //--- Datapath output ---
    logic [31:0] InstrD;
    logic [4:0] RSrc1D, RSrc2D;
    logic [4:0] RSrc1E, RSrc2E;
    logic [4:0] RDE, RDM, RDW;
    logic RegisterFileWEM, RegisterFileWEW;
    logic [1:0] ResultSrcE;
    logic PCSrcE;
    //--- HazardUnit output ---
    logic [1:0] ForwardAE, ForwardBE; //forwarding
    logic StallF, StallD, FlushE; //stalling for lw instruction
    logic FlushD; //flushing for branch or jump
    
    
    ControlUnit controlUnit(
        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
    
        .RegisterFileWED(RegisterFileWED),
        .ResultSrcD(ResultSrcD),
        .MemoryWED(MemoryWED),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcBD(ALUSrcBD)
    ); 
    
    Datapath datapath(
        .clk(clk),
        .reset(reset),
   
    //Control Unit
        .RegisterFileWED(RegisterFileWED),
        .ResultSrcD(ResultSrcD),
        .MemoryWED(MemoryWED),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcBED(ALUSrcBD),
    
    //HazardUnit
    //Fetch Stage
        .StallF(StallF), //Hazard Unit
    //Decode Stage
        .StallD(StallD),  //Hazard Unit
    //Execute Stage
        .FordwardAE(ForwardAE), //Hazard Unit
        .FordwardBE(ForwardBE), //Hazard Unit
        .StallE(1'b0),
        .FlushD(FlushD),
        .FlushE(FlushE),
    //output
        .InstrD(InstrD),
        .RSrc1D(RSrc1D), 
        .RSrc2D(RSrc2D),
        .RSrc1E(RSrc1E), 
        .RSrc2E(RSrc2E),
        .RDE(RDE), 
        .RDM(RDM), 
        .RDW(RDW),
        .RegisterFileWEM(RegisterFileWEM),
        .RegisterFileWEW(RegisterFileWEW),
        .ResultSrcE(ResultSrcE),
        .PCSrcE(PCSrcE)
    );
    
    HazardUnit hazardUnit(
        .RSrc1D(RSrc1D), 
        .RSrc2D(RSrc2D),
        .RSrc1E(RSrc1E), 
        .RSrc2E(RSrc2E),
        .RDE(RDE), 
        .RDM(RDM), 
        .RDW(RDW),
        .RegisterFileWEM(RegisterFileWEM),
        .RegisterFileWEW(RegisterFileWEW),
        .ResultSrcE(ResultSrcE),
        .PCSrcE(PCSrcE),
    
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE),
        .StallF(StallF), 
        .StallD(StallD), 
        .FlushE(FlushE),
        .FlushD(FlushD)
    );
    
endmodule
