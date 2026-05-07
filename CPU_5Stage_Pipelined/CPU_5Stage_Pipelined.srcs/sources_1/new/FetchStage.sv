`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 21:35:25
// Design Name: 
// Module Name: FetchStage
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


module FetchStage(
        input logic clk,
        input logic reset,
        
        //hazard signals
        input logic StallF,
        
        //select signals
        input logic PCSrcE, //from EXECUTE stage based on (Zero flag + branch, or jump)
        
        //input from EXECUTE stage
        input logic [31:0] PCPlusImmE,
        
        output logic [31:0] InstrF,
        output logic [31:0] PCPlus4F,
        output logic [31:0] PCF
    );
    
    //--- first stage - FETCH ---
    logic [31:0] PCNextF; 


    mux2_1_32bit PCRegisterMux(
        .a(PCPlus4F),
        .b(PCPlusImmE),
        .s(PCSrcE),
        .q(PCNextF)
    );
    
    FlipFlop_32bit PCRegister(
        .clk(clk),
        .reset(reset),
        .en(~StallF),
        .D(PCNextF),
        .Q(PCF)
    );
    
    //calculating PC+4
    Prefix_adder PCPlus4Adder(
      .a(PCF),
      .b(32'h4),
      .cin(1'b0),
      .sum(PCPlus4F),
      .cout()  
    );
    
    //Instruction memory
    InstructionMemory instructionMemory(
        .A(PCF),
        .RD(InstrF)
    );
    
endmodule
