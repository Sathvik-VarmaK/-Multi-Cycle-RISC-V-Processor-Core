module top_module(
    input clk,
    input reset
);

    // Control Wires
    wire        reg_write, mem_read, mem_write;
    wire [1:0]  pc_source, alu_src_b, wb_src;
    wire [2:0]  alu_op;
    wire        imm_sign;

    // Datapath Wires
    wire        zero_flag;
    wire [31:0] pc, instruction;
    wire [31:0] read_data_1, read_data_2, write_back_data;
    wire [31:0] immediate_extended;
    wire [31:0] alu_input_b, alu_result;
    wire [31:0] mem_read_data;
    
    // Instruction Field Wires (decoded from instruction)
    wire [6:0]  opcode = instruction[6:0];
    wire [4:0]  rs1    = instruction[19:15];
    wire [4:0]  rs2    = instruction[24:20];
    wire [4:0]  rd     = instruction[11:7];
    wire [2:0]  funct3 = instruction[14:12];
    wire        funct7 = instruction[30];

    // 1. Control Unit Instantiation
    control_unit ctrl_unit (
        .clk(clk), .reset(reset), .opcode(opcode), .funct3(funct3),
        .funct7(funct7), .zero_flag(zero_flag),
        .pc_source(pc_source), .reg_write(reg_write), .mem_read(mem_read),
        .mem_write(mem_write), .alu_src_b(alu_src_b), .wb_src(wb_src),
        .alu_op(alu_op), .imm_sign(imm_sign)
    );

    // 2. PC Logic
    PC pc_reg (.clk(clk), .reset(reset), .pc_in(next_pc), .pc_out(pc));
    assign pc_plus_4   = pc + 4;
    assign branch_addr = pc + immediate_extended;
    assign jump_addr   = pc + immediate_extended;
    assign next_pc     = (pc_source == 2'b01) ? branch_addr :
                       (pc_source == 2'b10) ? jump_addr   :
                       pc_plus_4;

    // 3. Instruction Fetch
    instruction_memory inst_mem (.addr(pc), .instruction(instruction));

    // 4. Register File
    register_file reg_file_inst (
        .clk(clk), .reg_write(reg_write), .rs1(rs1), .rs2(rs2), .rd(rd),
        .write_data(write_back_data), .read_data1(read_data_1), .read_data2(read_data_2)
    );
    
    // 5. Immediate Generator
    imm_gen imm_gen_inst (.instruction(instruction), .imm_sign(imm_sign), .immediate(immediate_extended));
    
    // 6. ALU Logic
    assign alu_input_b = (alu_src_b == 2'b01) ? immediate_extended : read_data_2;
    alu alu_inst (.a(read_data_1), .b(alu_input_b), .alu_op(alu_op), .alu_out(alu_result), .zero(zero_flag));
    
    // 7. Memory Access
    data_memory data_mem_inst (
        .clk(clk), .addr(alu_result), .write_data(read_data_2),
        .mem_write(mem_write), .mem_read(mem_read), .read_data(mem_read_data)
    );
    
    // 8. Write-Back Logic
    assign write_back_data = (wb_src == 2'b01) ? mem_read_data :
                           (wb_src == 2'b10) ? pc_plus_4     :
                           alu_result;

endmodule
