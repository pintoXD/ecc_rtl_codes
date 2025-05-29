`timescale 1ns/10ps
module tbec_full (
    input logic tbec_clk,
    input logic [7:0] tbec_addr,
    input logic [15:0] data_in,
    input logic mem_we, rst,
    output logic [15:0] data_out,
    output logic [1:0] out_error_code
);

    logic [31:0] tbec_enc_out_word;
    logic [31:0] tbec_mem_data_in;

    logic [31:0] tbec_dec_in_word;
    logic [31:0] tbec_mem_data_out;

    // Instantiate the Encoder
    tbec_encoder tbec_enc_inst (
        .in_word(data_in),
        .encoded_word(tbec_enc_out_word)
    );

    // Instantiate the Decoder
    tbec_decoder tbec_dec_inst (
    .in_word(tbec_dec_in_word),
    .decoded_word(data_out),
    .error_code(out_error_code)
    );

    // Instantiate the Memory
    tbec_memory dut (
        .clk(tbec_clk),
        .we(mem_we),
        .addr(tbec_addr),
        .data_in(tbec_mem_data_in),
        .data_out(tbec_mem_data_out)
    );

    // always_comb begin
    //     if (rst) begin
    //         tbec_mem_data_in = 32'h0; // Reset memory input
    //         tbec_dec_in_word = 32'h0; // Reset decoder input
    //     end else begin
    //         tbec_mem_data_in = tbec_enc_out_word; // Pass encoded word to memory
    //         tbec_dec_in_word = tbec_mem_data_out; // Pass memory output to decoder
    //     end
    // end

    always_ff @(posedge tbec_clk ) begin
        if (rst) begin
            tbec_enc_out_word <= 32'h00; // Reset encoder output
            tbec_dec_in_word <= 32'h00; // Reset decoder input
        end else begin
            tbec_mem_data_in <= tbec_enc_out_word; // Pass encoded word to memory
            tbec_dec_in_word <= tbec_mem_data_out; // Pass memory output to decoder
        end
        
    end

endmodule