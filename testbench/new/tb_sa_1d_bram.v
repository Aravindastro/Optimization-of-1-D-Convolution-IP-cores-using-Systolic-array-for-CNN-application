`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 15:08:10
// Design Name: 
// Module Name: tb_sa_1d_bram
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


`timescale 1ns / 1ps

module tb_sa_1d_bram;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg rst_n;
    reg start;

    reg [DATA_WIDTH-1:0] weight0, weight1, weight2;
    wire valid_out;
    wire [15:0] psum_out;

    // Instantiate the DUT
    sa_1d_bram #(DATA_WIDTH, ADDR_WIDTH) uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .weight0(weight0),
        .weight1(weight1),
        .weight2(weight2),
        .valid_out(valid_out),
        .psum_out(psum_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz

    // Simulated BRAM data (override the internal memory of BRAMs directly)
    initial begin
        // Reset
        rst_n = 0;
        start = 0;
        weight0 = 8'd1;
        weight1 = 8'd2;
        weight2 = 8'd3;

        #20;
        rst_n = 1;

        // Wait one cycle before writing to BRAMs
        #10;

   
       // Force values into BRAM memory
        force uut.bram0_inst.mem[0] = 8'd1;
        force uut.bram0_inst.mem[1] = 8'd2;
        force uut.bram0_inst.mem[2] = 8'd3;
        force uut.bram0_inst.mem[3] = 8'd4;
        force uut.bram0_inst.mem[4] = 8'd5;
        force uut.bram0_inst.mem[5] = 8'd6;
        force uut.bram0_inst.mem[6] = 8'd7;

        // Start signal (simulate input stream)
        #10 start = 1;
        #80 start = 0;

        // Wait and finish
        #100;
        $finish;
    end

    // Monitor output
    initial begin
        $display("Time\tvalid_out\tpsum_out");
        $monitor("%4t\t%b\t\t%d", $time, valid_out, psum_out);
    end

endmodule

