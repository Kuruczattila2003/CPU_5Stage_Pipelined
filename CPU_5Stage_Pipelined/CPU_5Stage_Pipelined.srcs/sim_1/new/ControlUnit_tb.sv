`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2026 18:00:00
// Design Name: 
// Module Name: ControlUnit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Base testbench wrapper for verifying combinational instruction decoding.
// 
//////////////////////////////////////////////////////////////////////////////////

module ControlUnit_tb(

    );
    
    logic clk;
    logic reset;
    
    // --- DUT Inputs ---
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    // --- DUT Outputs & Expected Values ---
    logic       RegisterFileWED, expected_RegisterFileWED;
    logic [1:0] ResultSrcD,      expected_ResultSrcD;
    logic       MemoryWED,       expected_MemoryWED;
    logic       JumpD,           expected_JumpD;
    logic       BranchD,         expected_BranchD;
    logic [2:0] ALUControlD,     expected_ALUControlD;
    logic       ALUSrcBD,        expected_ALUSrcBD;
    
    // --- DUT Instantiation ---
    ControlUnit dut(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        
        .RegisterFileWED(RegisterFileWED),
        .ResultSrcD(ResultSrcD),
        .MemoryWED(MemoryWED),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcBD(ALUSrcBD)
    );
    
    // --- Clock Generation ---
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // --- Main Verification Flow ---
    initial begin
        
        resetControlUnit();
        ControlUnitTestcase1();
        ControlUnitTestcase2();
        ControlUnitTestcase3();
        ControlUnitTestcase4();
        ControlUnitTestcase5();
        ControlUnitTestcase6();
        
        
        #100;
        $display("ControlUnit verification finished!");
        $finish;
    end
    
    // --- Reset Task ---
    task resetControlUnit();
        reset = 1'b1;
        
        opcode = 7'b0;
        funct3 = 3'b0;
        funct7 = 7'b0;
        
        @(posedge clk);
        #1;
        reset = 1'b0;
    endtask
    
    // --- R-Type Test Task ---
    task ControlUnitTestcase1();
        //R-Type Addition
        
        @(posedge clk);
        #1;
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        
        expected_RegisterFileWED = 1'b1;
        expected_ResultSrcD = 2'b00;
        expected_MemoryWED = 1'b0;
        expected_JumpD = 1'b0;
        expected_BranchD = 1'b0;
        expected_ALUControlD = 3'b000;
        expected_ALUSrcBD = 1'b0;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase1 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase1 was successful!");
        end
        
        
    endtask
    
    // --- I-Type Arithmetic Test Task ---
    task ControlUnitTestcase2();
        //I-Type AND
        
        @(posedge clk);
        #1;
        opcode = 7'b0010011;
        funct3 = 3'b111;
        funct7 = 7'b0;
        
        expected_RegisterFileWED = 1'b1;
        expected_ResultSrcD = 2'b00;
        expected_MemoryWED = 1'b0;
        expected_JumpD = 1'b0;
        expected_BranchD = 1'b0;
        expected_ALUControlD = 3'b010;
        expected_ALUSrcBD = 1'b1;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase2 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase2 was successful!");
        end
        
        
    endtask
    
    // --- I-Type Load Test Task ---
    task ControlUnitTestcase3();
        //I-Type Load
        
        @(posedge clk);
        #1;
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0;
        
        expected_RegisterFileWED = 1'b1;
        expected_ResultSrcD = 2'b01;
        expected_MemoryWED = 1'b0;
        expected_JumpD = 1'b0;
        expected_BranchD = 1'b0;
        expected_ALUControlD = 3'b000;
        expected_ALUSrcBD = 1'b1;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase3 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase3 was successful!");
        end
        
        
    endtask
    
    // --- S-Type Test Task ---
    task ControlUnitTestcase4();
        //S-Type
        
        @(posedge clk);
        #1;
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b0;
        
        expected_RegisterFileWED = 1'b0;
        expected_ResultSrcD = 2'b00;
        expected_MemoryWED = 1'b1;
        expected_JumpD = 1'b0;
        expected_BranchD = 1'b0;
        expected_ALUControlD = 3'b000;
        expected_ALUSrcBD = 1'b1;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase4 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase4 was successful!");
        end
        
        
        
    endtask
    
    // --- B-Type Test Task ---
    task ControlUnitTestcase5();
        //B-Type
        
        @(posedge clk);
        #1;
        opcode = 7'b1100011;
        funct3 = 3'b000;
        funct7 = 7'b0;
        
        expected_RegisterFileWED = 1'b0;
        expected_ResultSrcD = 2'b00;
        expected_MemoryWED = 1'b0;
        expected_JumpD = 1'b0;
        expected_BranchD = 1'b1;
        expected_ALUControlD = 3'b001;
        expected_ALUSrcBD = 1'b0;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase5 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase5 was successful!");
        end
        
        
    endtask
    
     // --- J-Type Test Task ---
    task ControlUnitTestcase6();
        //J-Type
        
        @(posedge clk);
        #1;
        opcode = 7'b1101111;
        funct3 = 3'b0;
        funct7 = 7'b0;
        
        expected_RegisterFileWED = 1'b1;
        expected_ResultSrcD = 2'b10;
        expected_MemoryWED = 1'b0;
        expected_JumpD = 1'b1;
        expected_BranchD = 1'b0;
        expected_ALUControlD = 3'b000;
        expected_ALUSrcBD = 1'b0;
        
        #8;
        if(expected_RegisterFileWED != RegisterFileWED || expected_ResultSrcD != ResultSrcD || expected_MemoryWED != MemoryWED || expected_JumpD != JumpD || expected_BranchD != BranchD || expected_ALUControlD != ALUControlD || expected_ALUSrcBD != ALUSrcBD) begin
            
            $display("ControlUnitTestcase6 failed with values:");
            $display("  RegisterFileWED : Expected %b, Got %b", expected_RegisterFileWED, RegisterFileWED);
            $display("  ResultSrcD      : Expected %b, Got %b", expected_ResultSrcD, ResultSrcD);
            $display("  MemoryWED       : Expected %b, Got %b", expected_MemoryWED, MemoryWED);
            $display("  JumpD           : Expected %b, Got %b", expected_JumpD, JumpD);
            $display("  BranchD         : Expected %b, Got %b", expected_BranchD, BranchD);
            $display("  ALUControlD     : Expected %b, Got %b", expected_ALUControlD, ALUControlD);
            $display("  ALUSrcBD        : Expected %b, Got %b", expected_ALUSrcBD, ALUSrcBD);
            
        end
        else begin
            $display("ControlUnitTestcase6 was successful!");
        end
        
        
    endtask

endmodule