`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 21:25:03
// Design Name: 
// Module Name: InstructionMemory
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


module ControlUnit(
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    
    output logic RegisterFileWED,
    output logic [1:0] ResultSrcD,
    output logic MemoryWED,
    output logic JumpD,
    output logic BranchD,
    output logic [2:0] ALUControlD,
    output logic ALUSrcBD
);
    
    //R-Type
    logic [6:0] RTypeOpcode = 7'b0110011;
    //I-Type
    logic [6:0] ITypeArithmeticOpcode = 7'b0010011;
    logic [6:0] ITypeLoadOpcode = 7'b0000011;
    logic [6:0] ITypeJumpAndLinkRegisterOpcode = 7'b1100111;
    //U-Type
    logic [6:0] UTypeLuiOpcode = 7'b0110111;
    logic [6:0] UTypeAuipcOpcode = 7'b0010111;
    //J-Type
    logic [6:0] JTypeOpcode = 7'b1101111;
    //S-Type
    logic [6:0] STypeOpcode = 7'b0100011;
    //B-Type
    logic [6:0] BTypeOpcode = 7'b1100011;
    
    logic isRType, isITypeArithmetic, isITypeLoad;
    logic isUTypeLui, isUTypeAuipc, isJType, isSType, isBType;
    //R-Type
    assign isRType = RTypeOpcode == opcode;
    //I-Type
    assign isITypeArithmetic = ITypeArithmeticOpcode == opcode;
    assign isITypeLoad = ITypeLoadOpcode == opcode;
    //U-Type
    assign isUTypeLui = UTypeLuiOpcode == opcode;
    assign isUTypeAuipc = UTypeAuipcOpcode == opcode;
    //J-Type
    assign isJType = JTypeOpcode == opcode;
    //S-Type
    assign isSType = STypeOpcode == opcode;
    //B-Type
    assign isBType = BTypeOpcode == opcode;
    
    //For ALUControl
    logic isRTypeAddition, isRTypeSubstraction, isRTypeAND;
    logic isRTypeOR, isRTypeXOR, isRTypeSLT;
    logic isITypeAddition, isITypeAND, isITypeOR, isITypeXOR, isITypeSLT;
    assign isRTypeAddition = (opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0000000);
    assign isRTypeSubstraction = (opcode == 7'b0110011) && (funct3 == 3'b000) && (funct7 == 7'b0100000);
    assign isRTypeAND = (opcode == 7'b0110011) && (funct3 == 3'b111) && (funct7 == 7'b0000000);
    assign isRTypeOR = (opcode == 7'b0110011) && (funct3 == 3'b110) && (funct7 == 7'b0000000);
    assign isRTypeXOR = (opcode == 7'b0110011) && (funct3 == 3'b100) && (funct7 == 7'b0000000);
    assign isRTypeSLT = (opcode == 7'b0110011) && (funct3 == 3'b010) && (funct7 == 7'b0000000);
    
    assign isITypeAddition = (opcode == 7'b0010011) && (funct3 == 3'b000);
    assign isITypeAND = (opcode == 7'b0010011) && (funct3 == 3'b111);
    assign isITypeOR = (opcode == 7'b0010011) && (funct3 == 3'b110);
    assign isITypeXOR = (opcode == 7'b0010011) && (funct3 == 3'b100);
    assign isITypeSLT = (opcode == 7'b0010011) && (funct3 == 3'b010);
    
    //S-Type, U-Type -> addition
    //B-Type -> substraction
    
    always_comb begin
    
        RegisterFileWED = 1'b0;
        ResultSrcD = 2'b0;
        MemoryWED = 1'b0;
        JumpD = 1'b0;
        BranchD = 1'b0;
        ALUControlD = 3'b0;
        ALUSrcBD = 1'b0;
    
        //RegisterFileWED
        RegisterFileWED = isRType || isITypeArithmetic || isITypeLoad || isUTypeLui || isUTypeAuipc || isJType; 
    
        //ResultSrcD
        if(isRType || isITypeArithmetic || isUTypeLui || isUTypeAuipc) begin
            ResultSrcD = 2'b00;
        end
        else if(isITypeLoad) begin
            ResultSrcD = 2'b01;
        end
        else if(isJType) begin
            ResultSrcD = 2'b10;
        end
        
        //MemoryWED
        if(isSType) begin
            MemoryWED = 1'b1;
        end
        
        //JumpD
        if(isJType) begin
            JumpD = 1'b1;
        end
        
        //BranchD
        if(isBType) begin
            BranchD = 1'b1;
        end
        
        //ALUControlD
        if(isRTypeAddition || isITypeAddition || isSType || isUTypeLui || isUTypeAuipc) begin
            //addition
            ALUControlD = 3'b000;
        end
        else if(isRTypeSubstraction || isBType) begin
            //substraction
            ALUControlD = 3'b001;
        end
        else if(isRTypeAND || isITypeAND) begin
            //AND
            ALUControlD = 3'b010;
        end
        else if(isRTypeOR || isITypeOR) begin
            //OR
            ALUControlD = 3'b011;
        end
        else if(isRTypeXOR || isITypeXOR) begin
            //XOR
            ALUControlD = 3'b100;
        end
        else if(isRTypeSLT || isITypeSLT) begin
            //SLT
            ALUControlD = 3'b101;
        end
        
        //ALUSrcBD
        if(isITypeLoad || isITypeArithmetic || isSType || isUTypeLui || isUTypeAuipc) begin
            ALUSrcBD = 1'b1;
        end
    end
    
endmodule