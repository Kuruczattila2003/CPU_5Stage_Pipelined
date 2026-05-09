    `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 16:27:08
// Design Name: 
// Module Name: ExecuteStage
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


module ExecuteStage(
        //From Decode Stage
        input logic clk,
        input logic reset,
        
        input logic [31:0] RD1D,
        input logic [31:0] RD2D,
        
        input logic [4:0] RSrc1D,
        input logic [4:0] RSrc2D,
        input logic [4:0] RDD,
        
        input logic [31:0] ImmExtD,
        input logic [31:0] PCPlus4D,
        input logic [31:0] PCD,
        
        //From Memory Stage
        input logic [31:0] ALUResM,
        
        //From Writeback Stage
        input logic [31:0] ResultSrcW,
        
        //From Hazard Unit
        input logic [1:0] ForwardAE,
        input logic [1:0] ForwardBE,
        input logic StallE,
        input logic FlushE,
                
        //output
        //For Fetch Stage
        output logic [31:0] PCPlusImmE,
        output logic PCSrcE,
        //For Memory Stage
        output logic [31:0] ALUResE,
        output logic [31:0] WriteDataE,
        output logic [4:0] RDE,
        output logic [31:0] PCPlus4E,
        
        
        //Control Unit pipelining
        input logic RegisterFileWED,
        input logic [1:0] ResultSrcD,
        input logic MemoryWED,
        input logic JumpD,
        input logic BranchD,
        input logic [2:0] ALUControlD,
        input logic ALUSrcBED,
        
        output logic [4:0] RSrc1E, RSrc2E,
        output logic RegisterFileWEE,
        output logic [1:0] ResultSrcE,
        output logic MemoryWEE
    );
    
    logic [31:0] RD1E;
    logic [31:0] RD2E;
    logic [31:0] ImmExtE;
    logic [31:0] PCE;
    //ALU
    logic [31:0] ALUSrcA, ALUSrcBtmp, ALUSrcB;
    logic Zero, Negative, Overflow, Carry;
    //Control signals
    logic JumpE;
    logic BranchE;
    logic [2:0] ALUControlE;
    logic ALUSrcBEE;
    
    
    PipelineRegister #(.WIDTH(185)) ExecuteRegister(
        .clk(clk),
        .reset(reset || FlushE),
        .en(~StallE),
        .D({RD1D, RD2D, RSrc1D, RSrc2D, RDD, ImmExtD, PCPlus4D, PCD, 
        /*CU*/ RegisterFileWED, ResultSrcD, MemoryWED, JumpD, BranchD, ALUControlD, ALUSrcBED}),
        .Q({RD1E, RD2E, RSrc1E, RSrc2E, RDE, ImmExtE, PCPlus4E, PCE, 
        /*CU*/ RegisterFileWEE, ResultSrcE, MemoryWEE, JumpE, BranchE, ALUControlE, ALUSrcBEE})    
    );
    
    mux4_1_32bit ForwardAMux(
        .a(RD1E),
        .b(ResultSrcW),
        .c(ALUResM),
        .d(32'b0),
        .s(ForwardAE),
        .q(ALUSrcA)
    );
    
    mux4_1_32bit ForwardBMux(
        .a(RD2E),
        .b(ResultSrcW),
        .c(ALUResM),
        .d(32'b0),
        .s(ForwardBE),
        .q(ALUSrcBtmp)
    );
    assign WriteDataE = ALUSrcBtmp;
    
    mux2_1_32bit ALUSrcBMux(
        .a(ALUSrcBtmp),
        .b(ImmExtE),
        .s(ALUSrcBEE),
        .q(ALUSrcB)
    );
    
    
    ALU alu(
        .A(ALUSrcA),
        .B(ALUSrcB),
        .ALUControl(ALUControlE),
        .Y(ALUResE),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );
    
    Prefix_adder PCPlusImmAdder(
        .a(ImmExtE), 
        .b(PCE),
        .cin(1'b0),
        .sum(PCPlusImmE),
        .cout()
    );
    
    assign PCSrcE = JumpE || (BranchE && Zero);
    
endmodule
