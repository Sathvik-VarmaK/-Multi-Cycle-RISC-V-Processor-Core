module instruction_memory(
    input  [31:0] addr,
    output [31:0] instruction
);
    reg [31:0] rom_memory [0:1023];

    initial begin
        $readmemh("program.mem", rom_memory);
    end
    
    assign instruction = rom_memory[addr[11:2]];
endmodule
