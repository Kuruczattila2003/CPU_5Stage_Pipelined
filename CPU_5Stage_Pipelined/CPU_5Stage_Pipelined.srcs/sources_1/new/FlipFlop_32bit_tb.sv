`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 20:29:48
// Design Name: 
// Module Name: FlipFlop_32bit_tb
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



module FlipFlop_32bit_tb(

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
        if(testQ != 32'b0) begin
            $display("Reset works incorrectly!");
            $finish;
        end
        else begin
            $display("Reset works correctly!");
        end
        @(posedge clk);
        #1;
        reset = 0;
        
        testFlipFlop_32bit();
        
        #1000;
        $display("FlipFlop32_bit testbanch finished");
        $finish;
    end
    
    //dut
    /*
    module FlipFlop_32bit(
            input logic clk,
            input logic reset,
            input logic en,
            input logic [31:0] D,
            output logic [31:0] Q 
        );
    */
    
    logic testEN;
    logic [31:0] testD, testQ;
    logic [31:0] nextD;
    
    FlipFlop_32bit dut(
        .clk(clk),
        .reset(reset),
        .en(testEN),
        .D(testD),
        .Q(testQ)
    );
    
    task testFlipFlop_32bit();
        
        int testCount;
        int totalTestCount = 100;
        int incorrectTestCount = 0;
        logic [31:0] prevQ;
       
                
        testEN = 1'b1;
        for(testCount = 0; testCount < totalTestCount-2; testCount += 1) begin
            if(!std::randomize(nextD)) begin
                //test failure
                $display("Randomization failed!");
                $finish;
            end
            
            @(posedge clk);
            #1; //wait after clock cycle
            testD <= nextD;
            
            @(posedge clk);
            #9;
            if(testQ != nextD) begin
                incorrectTestCount += 1;
                $display("Incorrect solution for testcase: D:%h, Q:%h", nextD, testQ);
            end
        end
        
        //check if enable = 0
        @(posedge clk);
        #1;
        testEN <= 1'b0;
        testD <= 32'hABCDE;
        prevQ = testQ;
        
        @(posedge clk);
        if(testQ != prevQ) begin
            $display("Enable works incorrectly!");
            $finish;
        end
        else begin
            $display("Enable works correctly!");
        end
        
    endtask
    
endmodule
