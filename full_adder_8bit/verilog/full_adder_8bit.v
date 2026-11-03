
module full_adder_1bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;

assign cout = (a & b) | (b & cin) | (a & cin);

endmodule


module full_adder_8bit(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);

wire [8:0] carry;

assign carry[0] = Cin;
assign Cout = carry[8];

genvar i;

generate
    for (i = 0; i < 8; i = i + 1) begin : FA

        full_adder_1bit FA_inst(
            .a(A[i]),
            .b(B[i]),
            .cin(carry[i]),
            .sum(Sum[i]),
            .cout(carry[i+1])
        );

    end
endgenerate

endmodule
