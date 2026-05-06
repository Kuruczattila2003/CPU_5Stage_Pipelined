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
