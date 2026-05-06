`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 17:31:36
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
    
    logic clk;
    logic reset;
    int totalTestCount = 100;
    int incorrectTestCount = 0;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1;
        repeat(2) @(posedge clk);
        #1;
        reset = 0;
        
        testALU();
        
        #1000;
        $display("Simulation finished.");
        $finish;  
    end
    
    /*
    module ALU(
        input logic [31:0] A,B,
        input logic [2:0] ALUControl,
        output logic [31:0] Y,
        output logic Zero, Negative, Overflow, Carry
    );
    */
    logic [31:0] testA, testB;
    logic [2:0] testALUControl;
    logic [31:0] testY;
 
    logic [31:0] expectedY;

    ALU dut(
        .A(testA),
        .B(testB),
        .ALUControl(testALUControl),
        .Y(testY),
        .Zero(),
        .Negative(), 
        .Overflow(), 
        .Carry()
    );
    
    
    //task
    task testALU();
        int test_count;
        $display("Starting Random ALU Tests...");
        
        for(test_count = 0; test_count < 100; test_count += 1) begin
        
            if(!std::randomize(testA, testB, testALUControl) with {
            //110 and 111 are just defaults
                testALUControl <= 3'b101;
            }) begin
                //catch error by randomization
                $display("Randomization failed!");
                $finish;
            end
            
            case(testALUControl) 
                3'b000: expectedY = testA + testB;
                3'b001: expectedY = testA - testB;
                3'b010: expectedY = testA & testB;
                3'b011: expectedY = testA | testB;
                3'b100: expectedY = testA ^ testB;
                3'b101: expectedY = ($signed(testA) < $signed(testB)) ? 32'b1 : 32'b0;
                default: expectedY = testA + testB;
            endcase
            
            #10 //wait for ALU calculation
            
            if(expectedY != testY) begin
                //incorrect solution
                $display("FAIL: A:%h B:%h ALUControl:%b | Got:%h | Expected:%h", 
                      testA, testB, testALUControl, testY, expectedY);
                incorrectTestCount += 1;
            end
        end
        
        $display("Random Testing Finished.");
        $display("Test results:");
        $display("Total Test: %0d", totalTestCount);
        $display("Test failures: %0d", incorrectTestCount);
    endtask
    
endmodule
