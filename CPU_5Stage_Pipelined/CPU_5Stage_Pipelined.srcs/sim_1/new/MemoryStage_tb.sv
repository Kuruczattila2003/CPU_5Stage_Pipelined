`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2026 15:21:26
// Design Name: 
// Module Name: MemoryStage_tb
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


module MemoryStage_tb(

    );
    
    logic clk;
    logic reset;
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    //dut 
     //From Execute Stage
     logic [31:0] ALUResE;
     logic [31:0] WriteDataE;
     logic [31:0] PCPlus4E;
     logic [4:0] RDE;
    //CU 
     logic RegisterFileWEE;
     logic [1:0] ResultSrcE;
     logic MemoryWEE;
    
    //output
     logic [31:0] ALUResM, expected_ALUResM;
     logic [31:0] MemoryDataM, expected_MemoryDataM;
     logic [4:0] RDM, expected_RDM;
     logic [31:0] PCPlus4M, expected_PCPlus4M;
    //CU
     logic RegisterFileWEM, expected_RegisterFileWEM;
     logic [1:0] ResultSrcM, expected_ResultSrcM;
    
    MemoryStage dut(
       .clk(clk),
        .reset(reset),
        
        .ALUResE(ALUResE),
       .WriteDataE(WriteDataE),
       .PCPlus4E(PCPlus4E),
       .RDE(RDE),
    //CU 
      .RegisterFileWEE(RegisterFileWEE),
       .ResultSrcE(ResultSrcE),
      .MemoryWEE(MemoryWEE),
    
    //output
       .ALUResM(ALUResM),
       .MemoryDataM(MemoryDataM),
      .RDM(RDM),
      .PCPlus4M(PCPlus4M),
    //CU
      .RegisterFileWEM(RegisterFileWEM),
      .ResultSrcM(ResultSrcM)
        
    );
    
    initial begin 
        testDataStage();
        
        #1000;
        $display("DataStage verification finished.");
        $finish;
    end

    task resetDataStage();
        reset = 1'b1;
        // --- Datapath Inputs from Execute Stage ---
        ALUResE         = 32'b0;
        WriteDataE      = 32'b0;
        PCPlus4E        = 32'b0;
        RDE             = 5'b0;
        // --- Control Unit Inputs ---
        RegisterFileWEE = 1'b0;
        ResultSrcE      = 2'b0;
        MemoryWEE       = 1'b0;
        @(posedge clk);
        #1;
        reset = 1'b0;
    endtask
    
    task testDataStage();
        //SW instruction
        /* Memdata
        AAAA1111
        BBBB2222
        CCCC3333
        DDDD4444
        EEEE5555
        FFFF6666
        AAAA7777
        BBBB8888
        CCCC9999
        */
        
        resetDataStage();
        
        @(posedge clk);
        #1;
        // --- Datapath Inputs from Execute Stage ---
        ALUResE         = 32'h4;
        WriteDataE      = 32'hFFFFFFFF;
        PCPlus4E        = 32'b0;
        RDE             = 5'b0;
        // --- Control Unit Inputs ---
        RegisterFileWEE = 1'b0;
        ResultSrcE      = 2'b0;
        MemoryWEE       = 1'b1;
        
        @(posedge clk);
        #9;
        //expected output:
        expected_ALUResM = ALUResE;
        expected_MemoryDataM = 32'hBBBB2222;
        expected_RDM = RDE;
        expected_PCPlus4M = PCPlus4E;
        expected_RegisterFileWEM = RegisterFileWEE;
        expected_ResultSrcM = ResultSrcE;
        
        //check pipelining
        if(expected_ALUResM != ALUResM || expected_MemoryDataM != MemoryDataM || expected_RDM != RDM || expected_PCPlus4M != PCPlus4M || expected_RegisterFileWEM != RegisterFileWEM || expected_ResultSrcM != ResultSrcM) begin
        $display("Memory Stage verification read failed with values:");
            $display("  ALUResM         : Expected %h, Got %h", expected_ALUResM, ALUResM);
            $display("  MemoryDataM     : Expected %h, Got %h", expected_MemoryDataM, MemoryDataM);
            $display("  RDM             : Expected %d, Got %d", expected_RDM, RDM);
            $display("  PCPlus4M        : Expected %h, Got %h", expected_PCPlus4M, PCPlus4M);
            $display("  RegisterFileWEM : Expected %b, Got %b", expected_RegisterFileWEM, RegisterFileWEM);
            $display("  ResultSrcM      : Expected %b, Got %b", expected_ResultSrcM, ResultSrcM);
            
        end
        else begin
            $display("Memory Stage verification read was successful!");
        end
        
        //check written memory
        @(posedge clk);
        #9;
        expected_MemoryDataM = 32'hFFFFFFFF;
        
        if(expected_MemoryDataM != MemoryDataM) begin
            $display("Write to DataMemory failed!");
            $display("  MemoryDataM     : Expected %h, Got %h", expected_MemoryDataM, MemoryDataM);
        end
        else begin
            $display("Memory Stage verification write was successful!");
        end
        
    endtask

endmodule
