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
    /*
    module CPU(
        input logic clk,
        input logic reset
    );
    */
    
    //RegisterFile RAM ith register: dut.datapath.decodeStage.registerFile.RAM[i]
    //DataMemory ith data (+4): dut.datapath.memoryStage.dataMemory.RAM[i]
    
    CPU dut(
        .clk(clk),
        .reset(reset)
    );
    
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
        
        CPUTestcase1();
        
        #1000;          
        $display("Simulation finished.");
        $finish;         
    end
    
    task resetCPU();
        reset = 1;
        repeat(2) @(posedge clk);
        #1;
        reset = 0;
    endtask
    
    task automatic write_mem_file(input string filename, input logic [31:0] data []);
        int file_handle;
        
        // Open file in write mode ("w" overwrites existing content)
        file_handle = $fopen(filename, "w");
        
        if (file_handle == 0) begin
            $error("[TB ERROR] Could not open %s for writing.", filename);
            return;
        end
        
        // Write each element in uppercase hex format
        foreach (data[i]) begin
            $fdisplay(file_handle, "%0X", data[i]);
        end
        
        $fclose(file_handle);
        $display("[TB INFO] Successfully updated %s with %0d words.", filename, data.size());
    endtask
    
    task CPUTestcase1();
        //memory_data.mem
        write_mem_file("memory_data.mem", '{
            32'hAAAA1111, 32'hBBBB2222, 32'hCCCC3333,
            32'hDDDD4444, 32'hEEEE5555, 32'hFFFF6666,
            32'hAAAA7777, 32'hBBBB8888, 32'hCCCC9999
        });
        //program.mem
        write_mem_file("program.mem", '{
            32'h00A00113, // addi x2, x0, 10
            32'h00500193, // addi x3, x0, 5 
            32'h003100B3, // add  x1, x2, x3
            32'h00002203, // lw   x4, 0(x0)
            32'h00000013  // NOP
        });
        $readmemh("memory_data.mem", dut.datapath.memoryStage.dataMemory.RAM);
        $readmemh("program.mem", dut.datapath.fetchStage.instructionMemory.RAM);
       
        
        resetCPU();
        
        repeat(9) @(posedge clk);
                
        if (dut.datapath.decodeStage.registerFile.RAM[2] !== 32'd10 || 
            dut.datapath.decodeStage.registerFile.RAM[3] !== 32'd5  || 
            dut.datapath.decodeStage.registerFile.RAM[1] !== 32'd15 || 
            dut.datapath.decodeStage.registerFile.RAM[4] !== 32'hAAAA1111) begin
            
            $display("\n==================================================");
            $error("[CPUTestcase1 FAILURE] CPU Register state does not match expected results!");
            $display("--------------------------------------------------");
            $display("Reg | Expected | Actual (Dec) | Actual (Hex)");
            $display("--------------------------------------------------");
            $display("$2  |       10 | %12d | 0x%08X", dut.datapath.decodeStage.registerFile.RAM[2], dut.datapath.decodeStage.registerFile.RAM[2]);
            $display("$3  |        5 | %12d | 0x%08X", dut.datapath.decodeStage.registerFile.RAM[3], dut.datapath.decodeStage.registerFile.RAM[3]);
            $display("$1  |       15 | %12d | 0x%08X", dut.datapath.decodeStage.registerFile.RAM[1], dut.datapath.decodeStage.registerFile.RAM[1]);
            $display("$4  |        0 | %12d | 0x%08X", dut.datapath.decodeStage.registerFile.RAM[4], dut.datapath.decodeStage.registerFile.RAM[4]);
            $display("==================================================\n");
            
        end
        else begin
            
            $display("\n==================================================");
            $display("[CPUTestcase1 SUCCESS] Test completed perfectly!");
            $display("--------------------------------------------------");
            $display(" Final Register States:");
            $display("  $2 = %0d", dut.datapath.decodeStage.registerFile.RAM[2]);
            $display("  $3 = %0d", dut.datapath.decodeStage.registerFile.RAM[3]);
            $display("  $1 = %0d", dut.datapath.decodeStage.registerFile.RAM[1]);
            $display("  $4 = %0d", dut.datapath.decodeStage.registerFile.RAM[4]);
            $display("==================================================\n");
            
        end
        
    endtask
    
endmodule
