`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2025 11:11:10
// Design Name: 
// Module Name: pe
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

module pe #(parameter DATA_WIDTH = 8)(
    input clk,
    input rst_n,

    input valid_in,
    input [DATA_WIDTH-1:0] data_in,
    input [DATA_WIDTH-1:0] weight_in,
    input [15:0] psum_in,

    output reg valid_out,
    output [15:0] psum_out  // Gated output
);

    // Internal pipeline registers
    reg [15:0] mul_result;
    reg [15:0] psum_result;
    reg stage_valid;

    // Output register
    reg [15:0] psum_out_reg;

    // Stage 1: Multiply
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_result   <= 0;
            stage_valid  <= 0;
        end else if (valid_in) begin
            mul_result   <= data_in * weight_in;
            stage_valid  <= 1;
        end else begin
            stage_valid  <= 0;
        end
    end

    // Stage 2: Accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            psum_result <= 0;
            valid_out   <= 0;
        end else if (stage_valid) begin
            psum_result <= psum_in + mul_result;
            valid_out   <= 1;
        end else begin
            valid_out   <= 0;
        end
    end

    // Output gating: only change output when valid_out is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            psum_out_reg <= 0;
        else if (valid_out)
            psum_out_reg <= psum_result;
    end

    // Final output
    assign psum_out = valid_out ? psum_out_reg : 16'd0;

endmodule




