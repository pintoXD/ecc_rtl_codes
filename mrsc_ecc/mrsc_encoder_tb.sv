module mrsc_encoder_tb (
);
    logic [15:0] mock_in_word;
    logic [31:0] out_encoded_word;

    // Instantiate the DUT
    mrsc_encoder dut (
        .in_word(mock_in_word),
        .encoded_word(out_encoded_word)
    );

    initial begin
        mock_in_word = 16'b1000000011111010; // Example input
        #10; // Wait for 10 time units
        $display("Input: %b", mock_in_word);
        $display("Encoded Output: %b", out_encoded_word);
    end


endmodule