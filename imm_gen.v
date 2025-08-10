module imm_gen(
    input  [310] instruction,
    input         imm_sign,
    output reg [310] immediate
);
    wire [60] opcode = instruction[60];

    parameter I_TYPE = 7'b0010011, LOAD = 7'b0000011, STORE = 7'b0100011, 
              BRANCH = 7'b1100011, JAL = 7'b1101111;

    always@() begin
        case(opcode)
            I_TYPE, LOAD
                immediate = {{20{instruction[31]}}, instruction[3120]};
            STORE
                immediate = {{20{instruction[31]}}, instruction[3125], instruction[117]};
            BRANCH
                immediate = {{20{instruction[31]}}, instruction[7], instruction[3025], instruction[118], 1'b0};
            JAL
                immediate = {{12{instruction[31]}}, instruction[1912], instruction[20], instruction[3021], 1'b0};
            default
                immediate = 32'h0;
        endcase
    end
endmodule
