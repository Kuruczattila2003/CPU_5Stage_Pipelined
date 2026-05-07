`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2026 15:42:03
// Design Name: 
// Module Name: PipelineRegister_tb
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


module PipelineRegister_tb(

    );
    
    logic clk;
    logic reset;
    
    // Test for 5-bit, 32-bit, and 121-bit
    logic testEN;
    logic [4:0]   D_5,   Q_5, expected_Q_5;
    logic [31:0]  D_32,  Q_32, expected_Q_32;
    logic [120:0] D_121, Q_121, expected_Q_121;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        
        //test enable = 1
        testPipelineRegister();
        //test enable = 0
        testEnablePipelineRegister();
        
        #1000;
        $display("PipelineRegister verification finished!");
        $finish;
    end
    
    //dut
    /*
    module PipelineRegister #(parameter WIDTH = 32) (
        input  logic clk,
        input  logic reset,
        input  logic en,
        input  logic [WIDTH-1:0] D,
        output logic [WIDTH-1:0] Q
    );
    */

    task resetPipelineRegister();
        reset = 1;
        testEN = 1'b1;
        D_5 = 5'b0;
        D_32 = 32'b0;  
        D_121 = 121'b0;
        @(posedge clk);
        #1;
        reset = 0;
    endtask
    

    //duts
    PipelineRegister #(.WIDTH(5)) dut_5(
        .clk(clk),
        .reset(reset),
        .en(testEN),
        .D(D_5),
        .Q(Q_5)
    );
    PipelineRegister #(.WIDTH(32)) dut_32(
        .clk(clk),
        .reset(reset),
        .en(testEN),
        .D(D_32),
        .Q(Q_32)
    );
    PipelineRegister #(.WIDTH(121)) dut_121(
        .clk(clk),
        .reset(reset),
        .en(testEN),
        .D(D_121),
        .Q(Q_121)
    );

    task testPipelineRegister();
    
        
        resetPipelineRegister();
        
        @(posedge clk);
        #1;
        testEN = 1'b1;
        D_5 = 5'hA;
        D_32 = 32'hBB;
        D_121 = 121'hCCC;
        //expected
        expected_Q_5 = 5'hA;
        expected_Q_32 = 32'hBB;
        expected_Q_121 = 121'hCCC;
               
        @(posedge clk);
        #9;
        if(expected_Q_5 != Q_5 || expected_Q_32 != Q_32 || expected_Q_121 != Q_121) begin
            $display("Failure in testPipelineRegister with values: Q_5: %h, Q_32: %h, Q_121: %h, expected_Q_5: %h, expected_Q_32: %h, expected_Q_121: %h", Q_5, Q_32, Q_121, expected_Q_5, expected_Q_32, expected_Q_121);
        end    
        else begin
            $display("PipelineRegister when enabled works as intended!");
        end   
    
    endtask    
    
    task testEnablePipelineRegister();
        
        resetPipelineRegister();
        
        @(posedge clk);
        #1;
        testEN = 1'b0;
        D_5 = 5'hA;
        D_32 = 32'hBB;
        D_121 = 121'hCCC;
        //expected
        expected_Q_5 = 5'b0;
        expected_Q_32 = 32'b0;
        expected_Q_121 = 121'b0;
               
        @(posedge clk);
        #9;
        if(expected_Q_5 != Q_5 || expected_Q_32 != Q_32 || expected_Q_121 != Q_121) begin
            $display("Failure in testEnablePipelineRegister with values: Q_5: %h, Q_32: %h, Q_121: %h, expected_Q_5: %h, expected_Q_32: %h, expected_Q_121: %h", Q_5, Q_32, Q_121, expected_Q_5, expected_Q_32, expected_Q_121);
        end       
        else begin
            $display("Disabling PipelineRegister works as intended!");
        end
    
    endtask
        
            
endmodule
