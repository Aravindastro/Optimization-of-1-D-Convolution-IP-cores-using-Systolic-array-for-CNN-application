`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2025 16:16:11
// Design Name: 
// Module Name: sa_1d
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

//main code systolic array block
module sa_1d #(parameter DATA_WIDTH = 8)(
    input clk,
    input rst_n,
    input valid_in,
    input [DATA_WIDTH-1:0] data_in0,
    input [DATA_WIDTH-1:0] data_in1,
    input [DATA_WIDTH-1:0] data_in2,
    input [DATA_WIDTH-1:0] weight_in0,
    input [DATA_WIDTH-1:0] weight_in1,
    input [DATA_WIDTH-1:0] weight_in2,
    input [15:0] psum_in,

    output valid_out,
    output [15:0] psum_out
);

    // Internal wires
    wire [15:0] psum_wire0, psum_wire1, psum_wire2;
    wire valid_wire0, valid_wire1, valid_wire2;

    // PE 0
    pe #(.DATA_WIDTH(DATA_WIDTH)) pe0 (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in(data_in0),
        .weight_in(weight_in0),
        .psum_in(psum_in),
        .valid_out(valid_wire0),
        .psum_out(psum_wire0)
    );

    // PE 1
    pe #(.DATA_WIDTH(DATA_WIDTH)) pe1 (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_wire0),
        .data_in(data_in1),
        .weight_in(weight_in1),
        .psum_in(psum_wire0),
        .valid_out(valid_wire1),
        .psum_out(psum_wire1)
    );

    // PE 2
    pe #(.DATA_WIDTH(DATA_WIDTH)) pe2 (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_wire1),
        .data_in(data_in2),
        .weight_in(weight_in2),
        .psum_in(psum_wire1),
        .valid_out(valid_wire2),
        .psum_out(psum_wire2)
    );

    // Output from last PE
    assign psum_out  = psum_wire2;
    assign valid_out = valid_wire2;

endmodule
