`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2026 16:30:47
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb(
        
    );
    
    logic clk;
    logic reset;
    
    logic WE;
    logic [4:0] A1, A2, A3;
    logic [31:0] WD3;
    logic [31:0] RD1, RD2;
    logic [31:0] expected_RD1, expected_RD2;
    
    initial begin
        clk = 0; 
        forever #5 clk = ~clk;
    end

    initial begin
        
        RegisterFileTestcase1();
        RegisterFileTestcase2();
        RegisterFileTestcase3();
        RegisterFileTestcase4();
        RegisterFileTestcase5();
        
        #1000;
        $display("Verification of Registerfile finished");
        $finish;
    end
    
    //dut
    RegisterFile dut(
        .clk(clk),
        .WE(WE),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1), 
        .RD2(RD2)
    );
    
    task RegisterFileTestcase1();
    //Read (zero) -> Write (x1/A1) -> Read (x1/A1)    
        
        /*
        logic WE;
        logic [4:0] A1, A2, A3;
        logic [31:0] WD3;
        logic [31:0] RD1, RD2;
        logic [31:0] expected_RD1, expected_RD2;
        */
        
        @(posedge clk);
        #1;
        //Read Zero
        WE = 1'b0; 
        A1 = 5'b0; //Zero
        A2 = 5'b0; //Zero
        A3 = 5'b0; //Zero
        WD3 = 32'b0;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'b0;
        expected_RD2 = 32'b0;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase1 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase1 -> Zero read correct!");
        end
        
        //Write to x1
        @(posedge clk);
        #1;
        WE = 1'b1;
        A1 = 5'h1; //Read x1
        A2 = 5'b0; //Zero
        A3 = 5'h1; //x1
        WD3 = 32'hAAAA1111;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'hAAAA1111;
        expected_RD2 = 32'b0;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase1 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase1 -> Write/Read correct!");
        end
   
    endtask
    
    task RegisterFileTestcase2();
    //Read (zero) -> Write (x2/A2) -> Read (x2/A2)    
        @(posedge clk);
        #1;
        //Read Zero
        WE = 1'b0; 
        A1 = 5'b0; //Zero
        A2 = 5'b0; //Zero
        A3 = 5'b0; //Zero
        WD3 = 32'b0;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'b0;
        expected_RD2 = 32'b0;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase2 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase2 -> Zero read correct!");
        end
        
        //Write to x1
        @(posedge clk);
        #1;
        WE = 1'b1;
        A1 = 5'h0; //Read x2
        A2 = 5'h2; //Zero
        A3 = 5'h2; //Write x2
        WD3 = 32'hBBBB2222;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'h0;
        expected_RD2 = 32'hBBBB2222;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase2 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase2 -> Write/Read X2 correct!");
        end
   
    endtask
    
    task RegisterFileTestcase3();
    //Write (zero) -> Read (zero)
        
        @(posedge clk);
        #1;
        WE = 1'b1;
        A1 = 5'h0; //Zero
        A2 = 5'b0; //Zero
        A3 = 5'h0; //Write Zero
        WD3 = 32'hCCCC2222;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'b0;
        expected_RD2 = 32'b0;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase3 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase3 -> Write Zero correct!");
        end
   
    endtask
    
    task RegisterFileTestcase4();
    //Write x1 -> Disable WE -> Write (x1) -> Read (x1)
        
        @(posedge clk);
        #1;
        WE = 1'b1;
        A1 = 5'h0; //Zero
        A2 = 5'b0; //Zero
        A3 = 5'h1; //Write Zero
        WD3 = 32'hAAAA1111;
        
        @(posedge clk);
        #1;
        WE = 1'b0;
        A1 = 5'h1; //Read x1
        A2 = 5'b0; //Zero
        A3 = 5'h1; //Write x1
        WD3 = 32'hCCCC3333;
        
        @(posedge clk);
        #9;
        expected_RD1 = 32'hAAAA1111;
        expected_RD2 = 32'b0;
        
        if(expected_RD1 != RD1 || expected_RD2 != RD2) begin
            $display("RegisterFileTestcase4 failed with values: RD1: %h, RD2: %h, expected_RD1: %h, expected_RD2: %h", RD1,RD2,expected_RD1,expected_RD2);
        end
        else begin
            $display("RegisterFileTestcase4 -> disabling WE correct!");
        end
   
    endtask
    
    task RegisterFileTestcase5();
        // Test Internal Forwarding (Write-Before-Read Bypass)
        
        @(posedge clk);
        #1;
        WE  = 1'b1;
        A3  = 5'h5;             // We are writing to x5
        WD3 = 32'hDEADBEEF;     // Data to write
        A1  = 5'h5;             // We are reading from x5 AT THE EXACT SAME TIME
        
        #1; 
        
        expected_RD1 = 32'hDEADBEEF;
        
        if(expected_RD1 != RD1) begin
            $display("RegisterFileTestcase5 failed! Internal Forwarding broken. Got: %h", RD1);
        end else begin
            $display("RegisterFileTestcase5 -> Internal Forwarding (Bypass) correct!");
        end
    endtask
    
endmodule
