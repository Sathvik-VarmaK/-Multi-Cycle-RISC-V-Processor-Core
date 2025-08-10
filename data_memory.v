module data_memory(
    input         clk,
    input         mem_write,
    input         mem_read,
    input  [31:0] addr,
    input  [31:0] write_data,
    output reg [31:0] read_data
);
    reg [7:0] ram [0:4095];

    always @(posedge clk) begin
        if (mem_write) begin
            ram[addr+3] <= write_data[31:24];
            ram[addr+2] <= write_data[23:16];
            ram[addr+1] <= write_data[15:8];
            ram[addr]   <= write_data[7:0];
        end
    end

    always @(posedge clk) begin
        if (mem_read) begin
            read_data <= {ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
        end
    end
endmodule
