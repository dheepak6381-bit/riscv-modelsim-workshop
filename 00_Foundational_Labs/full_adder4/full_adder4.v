`timescale 1ns/1ps

module full_adder4 (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);

reg [4:0] temp;

always @(*) begin

    // 4-BIT FULL ADDER
    temp = A + B + Cin;

    Sum = temp[3:0];
    Cout = temp[4];

end

endmodule
