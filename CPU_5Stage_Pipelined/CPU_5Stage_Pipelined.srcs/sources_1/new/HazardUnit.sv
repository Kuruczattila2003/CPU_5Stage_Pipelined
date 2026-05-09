module HazardUnit(
    input logic [4:0] RSrc1D, RSrc2D,
    input logic [4:0] RSrc1E, RSrc2E,
    input logic [4:0] RDE, RDM, RDW,
    input logic RegisterFileWEM, RegisterFileWEW,
    
    output logic [1:0] ForwardAE, ForwardBE
    
);

    always_comb begin
    //Forward ALUSrcA
    if((RSrc1E == RDM) && (RSrc1E != 5'b0) && RegisterFileWEM) begin
        ForwardAE = 2'b10;
    end
    else if((RSrc1E == RDW) && (RSrc1E != 5'b0) && RegisterFileWEW) begin
        ForwardAE = 2'b01;
    end
    else begin
        ForwardAE = 2'b00;
    end
    
    //Forward ALUSrcB
    if((RSrc2E == RDM) && (RSrc2E != 5'b0) && RegisterFileWEM) begin
        ForwardBE = 2'b10;
    end
    else if((RSrc2E == RDW) && (RSrc2E != 5'b0) && RegisterFileWEW) begin
        ForwardBE = 2'b01;
    end
    else begin
        ForwardBE = 2'b00;
    end
    
    //Stall for Load
    
    //Flush for jump and branch -> branch missprediction
    
    end
    
endmodule