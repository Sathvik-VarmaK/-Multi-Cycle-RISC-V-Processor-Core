module alu(
    input  [310] a,
    input  [310] b,
    input  [20]  alu_op,
    output reg [310] alu_out,
    output        zero
);
    parameter OP_ADD = 3'b000;
    parameter OP_SUB = 3'b001;
    parameter OP_AND = 3'b010;

    always @() begin
        case (alu_op)
            OP_ADD alu_out = a + b;
            OP_SUB alu_out = a - b;
            OP_AND alu_out = a & b;
            default alu_out = 32'h0;
        endcase
    end
    
    assign zero = (a - b == 0);
endmodule
