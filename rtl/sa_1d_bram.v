`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025
// Design Name: 
// Module Name: sa_1d_bram
// Description: Systolic Array with BRAM input using shift register window
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025
// Design Name: 
// Module Name: sa_1d_bram
// Description: Systolic Array with BRAM input using shift register window
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025
// Design Name: 
// Module Name: sa_1d_bram
// Description: Systolic Array with BRAM input using shift register window
//////////////////////////////////////////////////////////////////////////////////

module sa_1d_bram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input clk,
    input rst_n,
    input start,
    input [DATA_WIDTH-1:0] weight0,
    input [DATA_WIDTH-1:0] weight1,
    input [DATA_WIDTH-1:0] weight2,
    output valid_out,
    output [15:0] psum_out
);

    // Internal signals
    reg [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] data_from_bram;
    reg [DATA_WIDTH-1:0] shift_reg0, shift_reg1, shift_reg2;
    reg valid_in;
    reg [15:0] psum_in;

    // BRAM instance (read-only, testbench will force data here)
    bram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) bram0_inst (  // <- instance name used in testbench
        .clk(clk),
        .we(1'b0),
        .addr(addr),
        .din(8'd0),
        .dout(data_from_bram)
    );

    // Systolic Array Instance (3 PE version)
    sa_1d #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in0(shift_reg0),
        .data_in1(shift_reg1),
        .data_in2(shift_reg2),
        .weight_in0(weight0),
        .weight_in1(weight1),
        .weight_in2(weight2),
        .psum_in(psum_in),
        .valid_out(valid_out),
        .psum_out(psum_out)
    );

    // Control Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr <= 0;
            shift_reg0 <= 0;
            shift_reg1 <= 0;
            shift_reg2 <= 0;
            valid_in <= 0;
            psum_in <= 0;
        end else if (start) begin
            addr <= addr + 1;
            shift_reg0 <= shift_reg1;
            shift_reg1 <= shift_reg2;
            shift_reg2 <= data_from_bram;
            valid_in <= 1;
            psum_in <= 0;
        end else begin
            valid_in <= 0;
        end
    end

endmodule
