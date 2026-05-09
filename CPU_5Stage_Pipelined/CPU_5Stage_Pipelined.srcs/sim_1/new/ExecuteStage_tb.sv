`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 17:56:21
// Design Name: 
// Module Name: ExecuteStage_tb
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


module ExecuteStage_tb(
        
    );
    
    logic clk;
    logic reset;
     logic [31:0] RD1D;
     logic [31:0] RD2D;
    
     logic [4:0] RSrc1D;
     logic [4:0] RSrc2D;
     logic [4:0] RDD;
    
     logic [31:0] ImmExtD;
     logic [31:0] PCPlus4D;
     logic [31:0] PCD;
    
    //From Memory Stage
     logic [31:0] ALUResM;
    
    //From Writeback Stage
     logic [31:0] ResultSrcW;
    
    //From Hazard Unit
     logic [1:0] ForwardAE;
     logic [1:0] ForwardBE;
     logic StallE;
            
    //output
    //For Fetch Stage
     logic [31:0] PCPlusImmE;
     logic PCSrcE;
    //For Memory Stage
     logic [31:0] ALUResE;
     logic [31:0] WriteDataE;
     logic [4:0] RDE;
     logic [31:0] PCPlus4E;
    
    
    //Control Unit pipelining
     logic RegisterFileWED;
     logic [1:0] ResultSrcD;
     logic MemoryWED;
     logic JumpD;
     logic BranchD;
     logic [2:0] ALUControlD;
     logic ALUSrcBED;
    
     logic RegisterFileWEE;
     logic [1:0] ResultSrcE;
     logic MemoryWEE;
     
     logic [31:0] PCPlusImmE, expected_PCPlusImmE;
     logic PCSrcE, expected_PCSrcE;
     //For Memory Stage
     logic [31:0] ALUResE, expected_ALUResE;
     logic [31:0] WriteDataE, expected_WriteDataE;
     logic [4:0] RDE, expected_RDE;
     logic [31:0] PCPlus4E, expected_PCPlus4E;
     
     
    
    //dut
    ExecuteStage dut(
      .clk(clk),
      .reset(reset),
      .RD1D(RD1D),
      .RD2D(RD2D),
    
     .RSrc1D(RSrc1D),
     .RSrc2D(RSrc2D),
     .RDD(RDD),
    
     .ImmExtD(ImmExtD),
     .PCPlus4D(PCPlus4D),
     .PCD(PCD),
    
    //From Memory Stage
     .ALUResM(ALUResM),
    
    //From Writeback Stage
     .ResultSrcW(ResultSrcW),
    
    //From Hazard Unit
     .ForwardAE(ForwardAE),
     .ForwardBE(ForwardBE),
     .StallE(StallE),
     .FlushE(),
            
    //output
    //For Fetch Stage
     .PCPlusImmE(PCPlusImmE),
     .PCSrcE(PCSrcE),
    //For Memory Stage
     .ALUResE(ALUResE),
     .WriteDataE(WriteDataE),
     .RDE(RDE),
     .PCPlus4E(PCPlus4E),
    
     .RSrc1E(),
     .RSrc2E(),
    
    //Control Unit pipelining
     .RegisterFileWED(RegisterFileWED),
      .ResultSrcD(ResultSrcD),
      .MemoryWED(MemoryWED),
      .JumpD(JumpD),
      .BranchD(BranchD),
      .ALUControlD(ALUControlD),
      .ALUSrcBED(ALUSrcBED),
    
      .RegisterFileWEE(RegisterFileWEE),
      .ResultSrcE(ResultSrcE),
      .MemoryWEE(MemoryWEE)
      
    );
    
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        
        testExecuteStage_ForwardingAndJump();  //Stress test
        testExecuteStage_StandardRType();     // Normal ADD, no forwarding
        testExecuteStage_ImmediateMath();     // I-Type instruction (ALUSrc = 1)
        testExecuteStage_BranchTaken();       // Proves Zero flag triggers PCSrcE
        
        #100;
        $display("ExecuteStage verification finished!");
        $finish;
    end
    
    task resetExecuteStage();
        reset = 1;
        
        // --- Datapath Inputs ---
        RD1D       = 32'b0;
        RD2D       = 32'b0;
        RSrc1D     = 5'b0;
        RSrc2D     = 5'b0;
        RDD        = 5'b0;
        ImmExtD    = 32'b0;
        PCPlus4D   = 32'b0;
        PCD        = 32'b0;
        
        // --- Forwarding & Hazard Inputs ---
        ALUResM    = 32'b0;
        ResultSrcW = 32'b0;
        ForwardAE  = 2'b0;
        ForwardBE  = 2'b0;
        StallE     = 1'b0;
        
        // --- Control Unit Inputs ---
        RegisterFileWED = 1'b0;
        ResultSrcD      = 2'b0;
        MemoryWED       = 1'b0;
        JumpD           = 1'b0;
        BranchD         = 1'b0;
        ALUControlD     = 3'b0;
        ALUSrcBED       = 1'b0;

        @(posedge clk);
        #1;
        reset = 0;
    endtask
    
    task testExecuteStage_ForwardingAndJump();
        resetExecuteStage();
        
        @(posedge clk);
        #1;
        // --- Datapath Inputs ---
        RD1D       = 32'hAAAA1111;
        ImmExtD    = 32'hEEEEEEEE;
        PCPlus4D   = 32'h4;
        PCD        = 32'h1;
        
        // --- Forwarding & Hazard Inputs ---
        ALUResM    = 32'h1111AAAA;
        ForwardBE  = 2'b10;
        
        // --- Control Unit Inputs ---
        JumpD           = 1'b1;
        
        expected_PCPlusImmE = 32'hEEEEEEEF;
        expected_PCSrcE = 1'b1;
         //For Memory Stage
        expected_ALUResE = 32'hBBBBBBBB;
        expected_WriteDataE = ALUResM;
        expected_RDE = RDD;
        expected_PCPlus4E = PCPlus4D;
        @(posedge clk);
        #9;
        
        if(expected_PCPlusImmE != PCPlusImmE || expected_PCSrcE != PCSrcE || expected_ALUResE != ALUResE || expected_WriteDataE != WriteDataE || expected_RDE != RDE || expected_PCPlus4E != PCPlus4E) begin
        
           $display("Execute Stage verification failed with values:");
            $display("  PCPlusImmE : Expected %h, Got %h", expected_PCPlusImmE, PCPlusImmE);
            $display("  PCSrcE     : Expected %b, Got %b", expected_PCSrcE, PCSrcE);
            $display("  ALUResE    : Expected %h, Got %h", expected_ALUResE, ALUResE);
            $display("  WriteDataE : Expected %h, Got %h", expected_WriteDataE, WriteDataE);
            $display("  RDE        : Expected %d, Got %d", expected_RDE, RDE);
            $display("  PCPlus4E   : Expected %h, Got %h", expected_PCPlus4E, PCPlus4E);
        
        end
        else begin
            $display("Execute Stage verification was successfull!");
        end
        
    endtask
    
    // ---------------------------------------------------------
    // TEST 2: Standard R-Type (No Forwarding)
    // ---------------------------------------------------------
    task testExecuteStage_StandardRType();
        resetExecuteStage();
        
        @(posedge clk);
        #1;
        RD1D        = 32'd10;
        RD2D        = 32'd20;
        ALUControlD = 3'b000; // ADD
        ALUSrcBED   = 1'b0;   // Use RD2D
        ForwardAE   = 2'b00;  // No forwarding
        ForwardBE   = 2'b00;  // No forwarding
        
        expected_ALUResE    = 32'd30;
        expected_WriteDataE = 32'd20;
        expected_PCSrcE     = 1'b0;
        expected_PCPlusImmE = 32'b0; // PCD and ImmExtD are 0
        expected_RDE        = 5'b0;
        expected_PCPlus4E   = 32'b0;
        
        @(posedge clk);
        #9;
        if(expected_ALUResE != ALUResE || expected_WriteDataE != WriteDataE || expected_PCSrcE != PCSrcE) begin
            $display("Test 2 (Standard R-Type) failed!");
            $display("  ALUResE    : Expected %h, Got %h", expected_ALUResE, ALUResE);
        end else begin
            $display("Test 2 (Standard R-Type) successful!");
        end
    endtask

    // ---------------------------------------------------------
    // TEST 3: I-Type / Immediate Math
    // ---------------------------------------------------------
    task testExecuteStage_ImmediateMath();
        resetExecuteStage();
        
        @(posedge clk);
        #1;
        RD1D        = 32'd100;
        ImmExtD     = 32'd50;
        ALUControlD = 3'b001; // SUB
        ALUSrcBED   = 1'b1;   // Use ImmExtD instead of RD2D!
        ForwardAE   = 2'b00;  
        
        expected_ALUResE    = 32'd50; // 100 - 50 = 50
        expected_PCSrcE     = 1'b0;
        expected_PCPlusImmE = 32'd50; // PCD(0) + ImmExtD(50)
        expected_WriteDataE = 32'b0;  
        expected_RDE        = 5'b0;
        expected_PCPlus4E   = 32'b0;
        
        @(posedge clk);
        #9;
        if(expected_ALUResE != ALUResE || expected_PCSrcE != PCSrcE) begin
            $display("Test 3 (Immediate Math) failed!");
            $display("  ALUResE    : Expected %h, Got %h", expected_ALUResE, ALUResE);
        end else begin
            $display("Test 3 (Immediate Math) successful!");
        end
    endtask

    // ---------------------------------------------------------
    // TEST 4: Branch Taken Test
    // ---------------------------------------------------------
    task testExecuteStage_BranchTaken();
        resetExecuteStage();
        
        @(posedge clk);
        #1;
        PCD         = 32'd100;
        ImmExtD     = 32'd12;
        RD1D        = 32'd25;
        RD2D        = 32'd25;
        ALUControlD = 3'b001; // SUB (25 - 25 = 0, triggers Zero flag)
        ALUSrcBED   = 1'b0;   // Compare registers
        BranchD     = 1'b1;   // It is a branch instruction
        JumpD       = 1'b0;
        
        expected_ALUResE    = 32'd0;
        expected_PCSrcE     = 1'b1;   // Branch is 1 AND Zero is 1 -> Should be 1!
        expected_PCPlusImmE = 32'd112; // 100 + 12
        expected_WriteDataE = 32'd25;
        expected_RDE        = 5'b0;
        expected_PCPlus4E   = 32'b0;
        
        @(posedge clk);
        #9;
        if(expected_PCSrcE != PCSrcE || expected_PCPlusImmE != PCPlusImmE) begin
            $display("Test 4 (Branch Taken) failed!");
            $display("  PCSrcE     : Expected %b, Got %b", expected_PCSrcE, PCSrcE);
            $display("  PCPlusImmE : Expected %d, Got %d", expected_PCPlusImmE, PCPlusImmE);
        end else begin
            $display("Test 4 (Branch Taken) successful!");
        end
    endtask
endmodule
