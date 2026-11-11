`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: register_file
// Description: 32 x 32-bit General Purpose Register File for RV32I.
//              Register x0 is hardwired to zero.
//              Dual asynchronous read ports, single synchronous write port.
//////////////////////////////////////////////////////////////////////////////////

module register_file (
    input  wire        clk,
    input  wire        rst_n,          // Active-low asynchronous reset
    input  wire        reg_write,      // Write enable
    input  wire [4:0]  rs1,            // Source register 1 address
    input  wire [4:0]  rs2,            // Source register 2 address
    input  wire [4:0]  rd,             // Destination register address
    input  wire [31:0] wdata,          // Data to write into rd
    output wire [31:0] rdata1,         // Read data 1 (rs1)
    output wire [31:0] rdata2          // Read data 2 (rs2)
);

    reg [31:0] registers [31:0];
    integer i;

    // Asynchronous reads: x0 is always 0
    assign rdata1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign rdata2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

    // Synchronous write on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= wdata;
        end
    end

endmodule
