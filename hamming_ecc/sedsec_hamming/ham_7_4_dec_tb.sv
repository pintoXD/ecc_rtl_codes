module hamming_decode_tb();
    logic [7:1] code;
    logic [4:1] decoded_data;
    logic error;
            
        hamming_code_decoder DUT (
        .code_in(code),
        .data_out(decoded_data),
        .error(error)
        );

    initial begin
        // Test case 1
        code = 7'b0111100;

        #10;
        $display("Code_in: %b", DUT.code_in);

        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);

        // Test case 2

        // Data: 1010, Encoded: 1011010
        code = 7'b1011010;
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        if (decoded_data != 4'b1010) begin
            $display("Error in decoding: expected 1010, got %b", decoded_data);
        end


        // Data: 0001, Encoded: 1101001
        code = 7'b1101001;
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        if (decoded_data != 4'b0001) begin
            $display("Error in decoding: expected 0001, got %b", decoded_data);
        end
        // Data: 0010, Encoded: 0101010
        // Data: 0011, Encoded: 1000011
        // Data: 0100, Encoded: 1001100



        // Test case 3
        code = 7'b0111000;
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);

        // Test case 4
        code = 7'b1010010;
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        // $display("[ code_in = %b ]", DUT.code_in);
        // for (int i = 7; i >= 1; i--) begin
        //     $display("[ code_in[%0d] = %0b ]", i, DUT.code_in[i]);
        // end

        // $display("[ s1 = %b ]", DUT.s1);
        // $display("[ s2 = %b ]", DUT.s2);
        // $display("[ s3 = %b ]", DUT.s3);

        // $display("[ corrected_code = %b ]", DUT.corrected_code);
        // for (int i = 7; i >= 1; i--) begin
        //     $display("[ corrected_code[%0d] = %0b ]", i, DUT.corrected_code[i]);
        // end
        $finish;
    end
endmodule