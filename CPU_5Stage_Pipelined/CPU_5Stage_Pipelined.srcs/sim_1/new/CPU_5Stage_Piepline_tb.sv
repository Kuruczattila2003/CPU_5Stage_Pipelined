`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 17:15:30
// Design Name: 
// Module Name: CPU_5Stage_Piepline_tb
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


module CPU_5Stage_Piepline_tb(
        
    );
    
    logic clk;
    logic reset;
    
    //dut
    /*
    module CPU(
        input logic clk,
        input logic reset
    );
    */
    
    //RegisterFile RAM ith register: dut.datapath.decodeStage.registerFile.RAM[i]
    //DataMemory ith data (+4): dut.datapath.memoryStage.dataMemory.RAM[i]
    
    CPU dut(
        .clk(clk),
        .reset(reset)
    );
    
    //dut
    
    //clock 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    //testbench
    initial begin
        reset = 1;
        repeat(2) @(posedge clk); 
        #1;            
        reset = 0;      
        
        
        
        #1000;          
        $display("Simulation finished.");
        $finish;         
    end
    
endmodule
