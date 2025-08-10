module control_unit(
    input             clk,
    input             reset,
    input       [6:0] opcode,
    input       [2:0] funct3,
    input             funct7,
    input             zero_flag,
    output reg  [1:0] pc_source,
    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg  [1:0] alu_src_b,
    output reg  [1:0] wb_src,
    output reg  [2:0] alu_op,
    output reg        imm_sign
);
    // FSM State Definitions
    parameter S_FETCH = 3'b000, S_DECODE = 3'b001, S_EXECUTE_R = 3'b010, 
              S_EXECUTE_I = 3'b011, S_MEM_ADDR = 3'b100, S_MEM_READ = 3'b101, 
              S_MEM_WRITE = 3'b110, S_WB = 3'b111;
    reg [2:0] state, next_state;

    // Opcode Definitions
    parameter R_TYPE = 7'b0110011, I_TYPE = 7'b0010011, LOAD = 7'b0000011,
              STORE = 7'b0100011, BRANCH = 7'b1100011, JAL = 7'b1101111;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) state <= S_FETCH;
        else       state <= next_state;
    end

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default values
        next_state = S_FETCH; pc_source = 2'b00; reg_write = 1'b0; mem_read = 1'b0;
        mem_write = 1'b0; alu_src_b = 2'b00; wb_src = 2'b00; alu_op = 3'b000; imm_sign = 1'b0;

        case (state)
            S_FETCH: next_state = S_DECODE;
            S_DECODE: begin
                case (opcode)
                    R_TYPE:   next_state = S_EXECUTE_R;
                    I_TYPE:   next_state = S_EXECUTE_I;
                    LOAD, STORE: next_state = S_MEM_ADDR;
                    BRANCH: begin
                        if (zero_flag) begin
                           pc_source = 2'b01; // Branch taken
                           next_state = S_FETCH;
                        end else next_state = S_FETCH;
                    end
                    JAL: begin
                        pc_source = 2'b10; // Jump taken
                        wb_src = 2'b10; // WB source is PC+4
                        reg_write = 1'b1;
                        next_state = S_FETCH;
                    end
                    default: next_state = S_FETCH;
                endcase
            end
            S_EXECUTE_R: begin
                alu_src_b = 2'b00; // Operand B is from register
                alu_op = {funct7, funct3}; // Simplified mapping
                next_state = S_WB;
            end
            S_EXECUTE_I: begin
                alu_src_b = 2'b01; // Operand B is from immediate
                alu_op = funct3; // Simplified mapping
                imm_sign = 1'b1;
                next_state = S_WB;
            end
            S_MEM_ADDR: begin
                alu_src_b = 2'b01; // Operand B is from immediate
                alu_op = 3'b000; // ADD for address calculation
                imm_sign = 1'b1;
                if (opcode == LOAD) next_state = S_MEM_READ;
                else next_state = S_MEM_WRITE;
            end
            S_MEM_READ: begin
                mem_read = 1'b1;
                next_state = S_WB;
            end
            S_MEM_WRITE: begin
                mem_write = 1'b1;
                next_state = S_FETCH;
            end
            S_WB: begin
                reg_write = 1'b1;
                if (opcode == LOAD) wb_src = 2'b01; // WB source is memory
                else wb_src = 2'b00; // WB source is ALU result
                next_state = S_FETCH;
            end
            default: next_state = S_FETCH;
        endcase
    end
endmodule
