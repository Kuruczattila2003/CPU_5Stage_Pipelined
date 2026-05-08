`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2026 14:27:55
// Design Name: 
// Module Name: DecodeStage_tb
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


module DecodeStage_tb(

    );
    
    logic clk;
    logic reset;
    
        
    //From Fetch Stage
    logic [31:0] InstrF;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF;
    //From Writeback stage -> because of Register File
    logic [4:0] RDW;
    logic [31:0] ResultSrcW;
    //Control Unit
    logic RegisterFileWEW;
    //Hazard Unit
    logic StallD;
    //outputs
    logic [31:0] RD1D, expected_RD1D;
    logic [31:0] RD2D, expected_RD2D;
    
    logic [4:0] RSrc1D, expected_RSrc1D;
    logic [4:0] RSrc2D, expected_RSrc2D;
    logic [4:0] RDD, expected_RDD;
    
    logic [31:0] ImmExtD, expected_ImmExtD;
    logic [31:0] PCPlus4D, expected_PCPlus4D;
    logic [31:0] PCD, expected_PCD;
    
    
    //dut
    DecodeStage dut(
        .clk(clk),
        .reset(reset),
        
        //From Fetch Stage
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCF(PCF),
        
        //From Writeback stage -> because of Register File
        .RDW(RDW),
        .ResultSrcW(ResultSrcW),
        
        //Control Unit
        .RegisterFileWEW(RegisterFileWEW),
        
        //Hazard Unit
        .StallD(StallD),
        
        //outputs
        .RD1D(RD1D),
        .RD2D(RD2D),
        
        .RSrc1D(RSrc1D),
        .RSrc2D(RSrc2D),
        .RDD(RDD),
        
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .PCD(PCD)
    );
    
    /*
    module DecodeStage(
        input logic clk,
        input logic reset,
        
        //From Fetch Stage
        input logic [31:0] InstrF,
        input logic [31:0] PCPlus4F,
        input logic [31:0] PCF,
        
        //From Writeback stage -> because of Register File
        input logic [4:0] RDW,
        input logic [31:0] ResultSrcW,
        
        //Control Unit
        input logic RegisterFileWEW,
        
        //Hazard Unit
        input logic StallD,
        
        //outputs
        output logic [31:0] RD1D,
        output logic [31:0] RD2D,
        
        output logic [4:0] RSrc1D,
        output logic [4:0] RSrc2D,
        output logic [4:0] RDD,
        
        output logic [31:0] ImmExtD,
        output logic [31:0] PCPlus4D,
        output logic [31:0] PCD
    );
    */
    
    initial begin
        clk = 0; 
        forever #5 clk = ~clk;
    end
    
    
    initial begin
        
        DecodeStageTestcase1();
        DecodeStageTestcase2();
        #1000;
        $display("Decode Stage verification finished!");
        $finish;
    end
    
    
    task resetDecodeStage();
        
        reset = 1;
        InstrF = 32'b0;
        PCPlus4F = 32'b0;
        PCF = 32'b0;
        RDW = 5'b0;
        ResultSrcW = 32'b0;
        RegisterFileWEW = 1'b0;
        StallD = 1'b0;
        @(posedge clk);
        #1;
        reset = 0;
        
    endtask
    
    
    task DecodeStageTestcase1();
        //decode addi x10, x1, 5
        //000000000101 00001 000 01010 0010011
        //imm          rs1   f3  rd    opcode
        
        //write to x1
        @(posedge clk);
        #1;
        RDW = 5'b0001;
        ResultSrcW = 32'hAAAA1111;
        RegisterFileWEW = 1'b1;
        
        
        @(posedge clk);
        #1;
        InstrF = 32'b00000000010100001000010100010011;
        PCPlus4F = 32'h4;
        PCF = 32'b0;
        RDW = 5'b0;
        ResultSrcW = 32'b0;
        RegisterFileWEW = 1'b0;
        StallD = 1'b0;
        
        @(posedge clk);
        #9;
        expected_RD1D = 32'hAAAA1111; //x1
        //expected_RD2D = 32'b00101; //not important for this testcase
        expected_RSrc1D = 5'b00001; //x1 = AAAA1111
        expected_RSrc2D = 5'b00101; 
        expected_RDD = 5'b01010;
        expected_ImmExtD = 32'b101; 
        expected_PCPlus4D = 32'h4; 
        expected_PCD = 32'b0;
        
        if(expected_RD1D != RD1D || expected_RSrc2D != RSrc2D || expected_RSrc1D != RSrc1D || expected_RDD != RDD || expected_ImmExtD != ImmExtD || expected_PCPlus4D != PCPlus4D || expected_PCD != PCD) begin
            $display("DecodeStage Testcase1 failed with values:");
            $display("RD1D: %b, expected_RD1D: %b", RD1D, expected_RD1D);
            $display("RSrc2D: %b, expected_RSrc2D: %b", RSrc2D, expected_RSrc2D);
            $display("RSrc1D: %b, expected_RSrc1D: %b", RSrc1D, expected_RSrc1D);
            $display("RDD: %b, expected_RDD: %b", RDD, expected_RDD);
            $display("ImmExtD: %b, expected_ImmExtD: %b", ImmExtD, expected_ImmExtD);
            $display("PCPlus4D: %b, expected_PCPlus4D: %b", PCPlus4D, expected_PCPlus4D);
            $display("PCD: %b, expected_PCD: %b", PCD, expected_PCD);
        end
        else begin
            $display("DecodeStage Testcase1 successfull!");
        end
        
        
    endtask;
    
    task DecodeStageTestcase2();
        //Stall Decode Stage
        
        @(posedge clk);
        #1;
        InstrF = 32'b00000000010100001000010100010011;
        PCPlus4F = 32'h4;
        PCF = 32'b0;
        RDW = 5'b0;
        ResultSrcW = 32'b0;
        RegisterFileWEW = 1'b0;
        StallD = 1'b1;
        
        expected_RD1D = RD1D; //x1
        expected_RD2D = RD2D; 
        expected_RSrc1D = RSrc1D; //x1 = AAAA1111
        expected_RSrc2D = RSrc2D; 
        expected_RDD = RDD;
        expected_ImmExtD = ImmExtD; 
        expected_PCPlus4D = PCPlus4D; 
        expected_PCD = PCD;
        
        @(posedge clk);
        #9;
        if(expected_RD1D != RD1D || expected_RD2D != RD2D || expected_RSrc1D != RSrc1D || expected_RSrc2D != RSrc2D || expected_RDD != RDD || expected_ImmExtD != ImmExtD || expected_PCPlus4D != PCPlus4D || expected_PCD != PCD) begin
            $display("DecodeStage Testcase2 failed with values:");
            $display("RD1D: %b, expected_RD1D: %b", RD1D, expected_RD1D);
            $display("RD2D: %b, expected_RD2D: %b", RD1D, expected_RD1D);
            $display("RSrc1D: %b, expected_RSrc1D: %b", RSrc1D, expected_RSrc1D);
            $display("RSrc2D: %b, expected_RSrc2D: %b", RSrc2D, expected_RSrc2D);
            $display("RDD: %b, expected_RDD: %b", RDD, expected_RDD);
            $display("ImmExtD: %b, expected_ImmExtD: %b", ImmExtD, expected_ImmExtD);
            $display("PCPlus4D: %b, expected_PCPlus4D: %b", PCPlus4D, expected_PCPlus4D);
            $display("PCD: %b, expected_PCD: %b", PCD, expected_PCD);
        end
        else begin
            $display("DecodeStage Testcase2 successfull!");
        end
        
        
    endtask
    
endmodule
