`timescale 1ns/10ps
module tbec_memory(
    input logic clk, we,
    input logic [7:0] addr,
    input logic [31:0] data_in,
    output logic [31:0] data_out
);

logic [31:0] mem_data [7:0];

assign data_out = mem_data[addr[7:0]];

always_ff @(posedge clk) begin
    if (we) begin
        mem_data[addr[7:0]] <= data_in;
    end
end



endmodule