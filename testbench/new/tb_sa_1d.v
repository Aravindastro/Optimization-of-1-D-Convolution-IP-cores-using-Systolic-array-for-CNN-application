// tb_sa_1d.v - Updated Testbench for pipelined sa_1d module

`timescale 1ns / 1ps

module tb_sa_1d;

    parameter DATA_WIDTH = 8;

    // DUT Inputs
    reg clk;
    reg rst_n;
    reg valid_in;
    reg [DATA_WIDTH-1:0] data_in;
    reg [DATA_WIDTH-1:0] weight_in0, weight_in1, weight_in2;
    reg [15:0] psum_in;

    // DUT Outputs
    wire valid_out;
    wire [15:0] psum_out;

    // Instantiate the DUT (Design Under Test)
    sa_1d uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in(data_in),
        .weight_in0(weight_in0),
        .weight_in1(weight_in1),
        .weight_in2(weight_in2),
        .psum_in(psum_in),
        .valid_out(valid_out),
        .psum_out(psum_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Sample input stream (data to convolve)
    reg [7:0] input_stream [0:9];
    integer i;

    initial begin
        // Initialize
        rst_n = 0;
        valid_in = 0;
        data_in = 0;
        psum_in = 0;
        weight_in0 = 8'd1;  // Kernel = [1, 2, 3]
        weight_in1 = 8'd2;
        weight_in2 = 8'd3;

        // Load example data [2, 3, 4, 5, 6, 7, 8, 9]
        input_stream[0] = 8'd2;
        input_stream[1] = 8'd3;
        input_stream[2] = 8'd4;
        input_stream[3] = 8'd5;
        input_stream[4] = 8'd6;
        input_stream[5] = 8'd7;
        input_stream[6] = 8'd8;
        input_stream[7] = 8'd9;
        input_stream[8] = 8'd10;
        input_stream[9] = 8'd0;

        // Reset
        #12;
        rst_n = 1;

        // Feed input stream
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            valid_in = 1;
            data_in = input_stream[i];
        end

        // Stop sending valid data
        @(posedge clk);
        valid_in = 0;
        data_in = 0;

        // Wait for remaining pipeline outputs
        #100;
        $finish;
    end

    // Output monitor
    initial begin
        $display("Time | valid_in | data_in | valid_out | psum_out");
        $monitor("%4t |     %b     |   %3d   |     %b     |   %d",
                  $time, valid_in, data_in, valid_out, psum_out);
    end

endmodule

