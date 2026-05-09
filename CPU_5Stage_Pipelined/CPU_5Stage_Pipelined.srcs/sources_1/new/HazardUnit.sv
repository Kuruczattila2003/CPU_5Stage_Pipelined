
module HazardUnit(
    input logic [4:0] RSrc1D, RSrc2D,
    input logic [4:0] RSrc1E, RSrc2E,
    input logic [4:0] RDE, RDM, RDW,
    input logic RegisterFileWEM, RegisterFileWEW,
    input logic [1:0] ResultSrcE,
    input logic PCSrcE,
    
    output logic [1:0] ForwardAE, ForwardBE, //forwarding
    output logic StallF, StallD, FlushE, //stalling for lw instruction
    output logic FlushD //flushing for branch or jump
);

    always_comb begin
    
    ForwardAE = 2'b0;
    ForwardBE = 2'b0;
    StallF = 1'b0;
    StallD = 1'b0;
    FlushE = 1'b0;
    FlushD = 1'b0;
    
    //Forward ALUSrcA
    if((RSrc1E == RDM) && (RSrc1E != 5'b0) && RegisterFileWEM) begin
        ForwardAE = 2'b10;
    end
    else if((RSrc1E == RDW) && (RSrc1E != 5'b0) && RegisterFileWEW) begin
        ForwardAE = 2'b01;
    end
    
    //Forward ALUSrcB
    if((RSrc2E == RDM) && (RSrc2E != 5'b0) && RegisterFileWEM) begin
        ForwardBE = 2'b10;
    end
    else if((RSrc2E == RDW) && (RSrc2E != 5'b0) && RegisterFileWEW) begin
        ForwardBE = 2'b01;
    end
    
    //Stall for Load
    if(((RSrc1D == RDE) && (RSrc1D != 5'b0) && (ResultSrcE == 2'b01)) || ((RSrc2D == RDE) && (RSrc2D != 5'b0) && (ResultSrcE == 2'b01))) begin
        StallF = 1'b1;
        StallD = 1'b1;
        FlushE = 1'b1;
    end
    
    //Flush for jump or branch -> branch missprediction
    if(PCSrcE == 1'b1) begin
        FlushD = 1'b1;
        FlushE = 1'b1;
    end    
    
    end
    
endmodule