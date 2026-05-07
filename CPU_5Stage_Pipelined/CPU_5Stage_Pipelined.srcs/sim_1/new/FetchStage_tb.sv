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
        
        
        testFetchStage();
        
        #1000;
        $display("Fetch Stage testbanch finished");
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
        
        int incorrectTestCountTestcase1;
        int incorrectTestCountTestcase2;
        int incorrectTestCountTestcase3;
        
        //--- First Testcase ---
        //Step by 4 two times
        resetFetchStage();
        firstTestcase(incorrectTestCountTestcase1);
        incorrectTestCount += incorrectTestCountTestcase1;
        
        
        //--- Second Testcase ---
        ////Step by Imm, then step by 4
        resetFetchStage();
        secondTestcase(incorrectTestCountTestcase2);
        incorrectTestCount += incorrectTestCountTestcase2;
        
        
        //--- Third Testcase ---
        //Stall Fetch Stage
        resetFetchStage();
        thirdTestcase(incorrectTestCountTestcase3);
        incorrectTestCount += incorrectTestCountTestcase3;
        
        
        $display("Total failures: 0%d", incorrectTestCount);
    endtask
    
    /*
    test program.mem
        AAAA1111
        BBBB2222
        CCCC3333
        DDDD4444
        EEEE5555
        FFFF6666
        AAAA7777
        BBBB8888
    */
    
    task resetFetchStage();
        reset = 1;
        testStallF <= 1'b0; //no stall
        testPCSrcE <= 1'b0; //select +4 
        testPCPlusImmE <= 32'b0;
        @(posedge clk);
        //check reset
        @(posedge clk);
        #1;
        reset = 0;
    endtask 
    
    task firstTestcase(
        output int incorrectTestCount
    );
    //test +4 only
    
        incorrectTestCount = 0;
        
        //expected
        expectedInstrF = 32'hAAAA1111;
        expectedPCPlus4F = 32'h4; 
        expectedPCF = 32'h0;
        
         if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase1 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
         end
        
        //input
        @(posedge clk);
        #9;
        testStallF <= 1'b0; //no stall
        testPCSrcE <= 1'b0; //select +4 
        testPCPlusImmE <= 32'hAAAAEEEE;
        //expected
        expectedInstrF = 32'hBBBB2222;
        expectedPCPlus4F = 32'h8; 
        expectedPCF = 32'h4;
        
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase1 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
        @(posedge clk);
        #9;
        //expected
        expectedInstrF = 32'hCCCC3333;
        expectedPCPlus4F = 32'hC; 
        expectedPCF = 32'h8;
        
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase1 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
        
    endtask
    
    task secondTestcase(
        output int incorrectTestCount
    );
    //test PC + immediate value, then +4
        incorrectTestCount = 0;
        
        //input
        @(posedge clk);
        #1;
        testStallF <= 1'b0; //no stall
        testPCSrcE <= 1'b1; //select Imm 
        testPCPlusImmE <= 32'hC; //(12/4)th instruction
        
        @(posedge clk);
        #9;
        //expected
        expectedInstrF = 32'hDDDD4444; //(12/4)th instruction is DDDD4444 
        expectedPCPlus4F = 32'h10; 
        expectedPCF = 32'hC;
        
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase2 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
        testStallF <= 1'b0; //no stall
        testPCSrcE <= 1'b0; //select Imm 
        testPCPlusImmE <= 32'hC;
        
        @(posedge clk);
        #9;
        //expected
        expectedInstrF = 32'hEEEE5555; //DDDD4444 + 4 instruction is EEEE5555
        expectedPCPlus4F = 32'h14; 
        expectedPCF = 32'h10;
        
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase2 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
    endtask
    
    task thirdTestcase(
        output int incorrectTestCount
    );
    //test Stall
        incorrectTestCount = 0;
        
        //Stall with PCSrcE = 0
        @(posedge clk);
        #1;
        testStallF <= 1'b1; //stall
        testPCSrcE <= 1'b0; //select +4 
        testPCPlusImmE <= 32'hAAAAEEEE; //X
        
        expectedInstrF = testInstrF;
        expectedPCPlus4F = testPCPlus4F; 
        expectedPCF = testPCF;
        
        @(posedge clk);
        #9;
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase3 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
        
        //Stall with PCSrcE = 1
        @(posedge clk);
        #1;
        testStallF <= 1'b1; //stall
        testPCSrcE <= 1'b1; //select Imm
        testPCPlusImmE <= 32'hAAAAEEEE; //X
        
        @(posedge clk);
        #9;
        if(testInstrF != expectedInstrF || testPCPlus4F != expectedPCPlus4F || testPCF != expectedPCF) begin
            //failure
            incorrectTestCount += 1;
            $display("Failure in Testcase3 with values: InstrF: %h, PCPlus4F: %h, PCF: %h, expectedInstrF: %h, expectedPCPlust4F: %h, expectedPCF: %h", testInstrF, testPCPlus4F, testPCF, expectedInstrF, expectedPCPlus4F, expectedPCF);
        end
        
    endtask
    
    
endmodule
