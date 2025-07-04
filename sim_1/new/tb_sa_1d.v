`timescale 1ns / 1ps

module tb_sa;

    parameter DATA_WIDTH = 8;

    // Signals
    reg clk;
    reg rst_n;
    reg valid_in;

    reg [DATA_WIDTH-1:0] data_in0, data_in1, data_in2;
    reg [DATA_WIDTH-1:0] weight0, weight1, weight2;

    wire valid_out;
    wire [15:0] psum_out;

    // DUT instantiation
    sa_1d uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .weight_in0(weight0),
        .weight_in1(weight1),
        .weight_in2(weight2),
        .psum_in(16'd0),
        .valid_out(valid_out),
        .psum_out(psum_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Input memory
    reg [7:0] input_data [0:9]; // 10 values
    integer i;

    initial begin
        // Init
        rst_n = 0;
        valid_in = 0;
        data_in0 = 0; data_in1 = 0; data_in2 = 0;
        weight0 = 8'd1;
        weight1 = 8'd2;
        weight2 = 8'd3;

        // Sample data
        input_data[0] = 8'd2;
        input_data[1] = 8'd3;
        input_data[2] = 8'd4;
        input_data[3] = 8'd5;
        input_data[4] = 8'd6;
        input_data[5] = 8'd7;
        input_data[6] = 8'd8;
        input_data[7] = 8'd9;
        input_data[8] = 8'd10;
        input_data[9] = 8'd0;

        #20;
        rst_n = 1;

        // Feed 3 data points per clock (sliding window)
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            data_in0 = input_data[i];
            data_in1 = input_data[i+1];
            data_in2 = input_data[i+2];
            valid_in = 1;
        end

        // End of stream
        @(posedge clk);
        valid_in = 0;
        data_in0 = 0;
        data_in1 = 0;
        data_in2 = 0;

        #100;
        $finish;
    end

    // Output log
    initial begin
        $display("Time | valid_in | D0 | D1 | D2 | valid_out | psum_out");
        $monitor("%4t |    %b     | %3d | %3d | %3d |     %b     |   %d",
                 $time, valid_in, data_in0, data_in1, data_in2, valid_out, psum_out);
    end

endmodule
