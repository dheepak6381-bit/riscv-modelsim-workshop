
module full_adder_8bit_tb;

reg [7:0] A, B;
reg Cin;

wire [7:0] Sum;
wire Cout;

full_adder_8bit uut(
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
);

initial begin

    $display("======================================");
    $display("       8-BIT FULL ADDER TEST");
    $display("======================================");

    $monitor("Time=%0t | A=%d | B=%d | Cin=%b | Sum=%d | Cout=%b",
             $time, A, B, Cin, Sum, Cout);

    // Test 1
    A = 8'd10; B = 8'd20; Cin = 0;
    #10;

    // Test 2
    A = 8'd100; B = 8'd50; Cin = 0;
    #10;

    // Test 3
    A = 8'd255; B = 8'd1; Cin = 0;
    #10;

    // Test 4
    A = 8'd255; B = 8'd255; Cin = 1;
    #10;

    // Test 5
    A = 8'd128; B = 8'd127; Cin = 1;
    #10;

    // Test 6
    A = 8'd50; B = 8'd25; Cin = 1;
    #10;

    $display("======================================");
    $display("      SIMULATION COMPLETED");
    $display("======================================");

    $finish;

end

endmodule