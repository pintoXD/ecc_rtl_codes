`timescale 1ns/10ps
module tbec_full (
    input logic clk, rst,
    input logic [7:0] tbec_addr,
    input logic [15:0] data_in,
    input logic mem_we,
    output logic [15:0] data_out,
    output logic [1:0] out_error_code
);

    logic [31:0] tbec_enc_out_word;
    logic [31:0] tbec_dec_in_word;
    logic [31:0] mem_data [7:0];

    // Instantiate the Encoder
    tbec_encoder tbec_enc_inst (
        .in_word(data_in),
        .rst(rst),
        .encoded_word(tbec_enc_out_word)
    );

    // Instantiate the Decoder
    tbec_decoder tbec_dec_inst (
    .in_word(tbec_dec_in_word),
    .decoded_word(data_out),
    .error_code(out_error_code)
    );


    always_ff @(posedge clk) begin
        if (rst) begin
            // Reset memory data to zero when rst is high
            for (int i = 0; i < 8; i++) begin
                mem_data[i] <= 32'h00000000;
            end
        end else begin
            if (mem_we) begin
                mem_data[tbec_addr[7:0]] <= tbec_enc_out_word;
            end
        end
    end

    assign tbec_dec_in_word = mem_data[tbec_addr[7:0]];


endmodule