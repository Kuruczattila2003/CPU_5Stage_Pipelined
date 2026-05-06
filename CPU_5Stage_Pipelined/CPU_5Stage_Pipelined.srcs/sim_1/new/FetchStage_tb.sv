`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 21:56:37
// Design Name: 
// Module Name: FetchStage_tb
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



module FetchStage_tb(

    );
    
    logic clk;
    logic reset;
    
    //clock
    initial begin
        clk = 0; 
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1;
        @(posedge clk);
        //check reset
        @(posedge clk);
        #1;
        reset = 0;
        
        testFetchStage();
        
        #1000;
        $display("FlipFlop32_bit testbanch finished");
        $finish;
    end
    
    //dut
    /*
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
    */
    
    // inputs
    logic testStallF, testPCSrcE;
    logic [31:0] testPCPlusImmE;
    // outputs
    logic [31:0] testInstrF, testPCPlus4F, testPCF;
    // expected outputs
    logic [31:0] expectedInstrF, expectedPCPlus4F, expectedPCF;
    
    FetchStage dut(
        .clk(clk),
        .reset(reset),
        
        .StallF(testStallF),
        
        .PCSrcE(testPCSrcE),
        
        .PCPlusImmE(testPCPlusImmE),
        
        .InstrF(testInstrF),
        .PCPlus4F(testPCPlus4F),
        .PCF(testPCF)
    );
    
    task testFetchStage();
        
        int testCount;
        int totalTestCount = 100;
        int incorrectTestCount = 0;
        
        
    endtask
    
endmodule
