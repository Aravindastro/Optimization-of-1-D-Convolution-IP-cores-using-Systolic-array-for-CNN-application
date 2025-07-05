`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2025 11:16:08
// Design Name: 
// Module Name: tb_pe
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

module tb_pe;

    parameter DATA_WIDTH = 8;

    // Clock and reset
    reg clk;
    reg rst_n;

    // Inputs to DUT
    reg valid_in;
    reg [DATA_WIDTH-1:0] data_in;
    reg [DATA_WIDTH-1:0] weight_in;
    reg [15:0] psum_in;

    // Outputs from DUT
    wire valid_out;
    wire [15:0] psum_out;

    // Instantiate the Device Under Test (DUT)
    pe #(.DATA_WIDTH(DATA_WIDTH)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in(data_in),
        .weight_in(weight_in),
        .psum_in(psum_in),
        .valid_out(valid_out),
        .psum_out(psum_out)
    );

    // Clock generation: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
        // Initial values
        rst_n     = 0;
        valid_in  = 0;
        data_in   = 0;
        weight_in = 0;
        psum_in   = 0;

        // Apply reset
        #15;
        rst_n = 1;

        // ==== Input #1 ====
        @(posedge clk);
        valid_in  = 1;
        data_in   = 8'd2;
        weight_in = 8'd3;
        psum_in   = 16'd10;

        // ==== Hold input one cycle ====
        @(posedge clk);
        valid_in = 0;

        // ==== Wait for result ====
        repeat(3) @(posedge clk);

        // ==== Input #2 ====
        valid_in  = 1;
        data_in   = 8'd4;
        weight_in = 8'd2;
        psum_in   = 16'd5;

        @(posedge clk);
        valid_in = 0;

        // ==== Wait for result ====
        repeat(3) @(posedge clk);

        // ==== Input #3 ====
        valid_in  = 1;
        data_in   = 8'd6;
        weight_in = 8'd1;
        psum_in   = 16'd0;

        @(posedge clk);
        valid_in = 0;

        repeat(4) @(posedge clk);

        $finish;
    end

    // Monitor output on console
    initial begin
        $display("Time\tclk\tvalid_in\tdata\tweight\tpsum_in\t|\tpsum_out\tvalid_out");
        $monitor("%0t\t%b\t%b\t\t%d\t%d\t%d\t|\t%d\t\t%b",
                 $time, clk, valid_in, data_in, weight_in, psum_in, psum_out, valid_out);
    end

endmodule






