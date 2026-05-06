`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2026 17:36:19
// Design Name: 
// Module Name: ALU
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

module ALU(
        input logic [31:0] A,B,
        input logic [2:0] ALUControl,
        output logic [31:0] Y,
        output logic Zero, Negative, Overflow, Carry
    );
    
    //Addition and Substraction
    logic [31:0] adderA, adderB;
    logic [31:0] adderSum;
    logic adderCout;
    assign adderA = A;
    assign adderB = (ALUControl[0] == 1'b0) ? B : ~B; 
    
    Prefix_adder adder(
        .a(adderA),
        .b(adderB),
        .cin(ALUControl[0]),
        .sum(adderSum),
        .cout(adderCout)
    );
    
    //AND, OR, XOR, SLT
    logic [31:0] ANDResult, ORResult, XORResult, SLTResult;
    assign ANDResult = A&B;
    assign ORResult = A|B;
    assign XORResult = A^B;
    assign SLTResult = Negative ^ Overflow;
    
    // 111 and 110 are empty right now (not needed)
    always_comb begin
        case(ALUControl) 
            3'b000: begin
                //addition
                Y = adderSum;
            end
            3'b001: begin
                //substraction
                Y = adderSum;
            end
            3'b010: begin
                //AND
                Y = ANDResult;
            end
            3'b011: begin
                //OR
                Y = ORResult;
            end
            3'b100: begin
                //XOR
                Y = XORResult;
            end
            3'b101: begin
                //SLT
                Y = SLTResult;
            end
            default: begin
                //default: addition
                Y = adderSum;
            end
        endcase
    end
    
    //flags
    assign Zero = (adderSum == 32'b0);
    assign Negative = (adderSum[31] == 1'b1);
    assign Overflow = ((adderA[31] != adderSum[31]) && (adderA[31] == adderB[31]));
    assign Carry = (ALUControl[0]) ? ~adderCout : adderCout;
    
endmodule
