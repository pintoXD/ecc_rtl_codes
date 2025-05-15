module hamming_decode_tb();
    logic [8:1] code;
    logic [4:1] decoded_data;
    logic [2:1] error;
            
        hamming_code_decoder DUT (
        .code_in(code),
        .data_out(decoded_data),
        .error(error)
        );

    initial begin
        // Test case 1
        code = 8'b01111000;

        #10;
        $display("Test Case 1");
        $display("Code_in: %b", DUT.code_in[8:2]);
        $display("Corrected Code: %b", DUT.corrected_code);
        $display("Code: %b, Decoded: %b, Error: %b\n\n",code, decoded_data, error);

        // Test case 2
        // Data: 1010, Encoded: 10110100, Received: 10110100
        code = 8'b10110100;
        #10;
        $display("Test Case 2");
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        if (decoded_data != 4'b1010) begin
            $display("Error in decoding: expected 1010, got %b", decoded_data);
        end
        $display("\n\n");
        
        // Test case 3
        // Data: 0001, Encoded: 11010010, Received: 11010010
        code = 8'b11010010;
        #10;
        $display("Test Case 3");
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        if (decoded_data != 4'b0001) begin
            $display("Error in decoding: expected 0001, got %b", decoded_data);
        end
        $display("\n\n");
        // Data: 0010, Encoded: 0101010
        // Data: 0011, Encoded: 1000011
        // Data: 0100, Encoded: 1001100



        // Test case 4
        // Data: 1100, Encoded: 0111000, Received: 10110000
        $display("Test Case 4");
        code = 8'b10110000; //Word With error on the second data bit
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        $display("\n\n");

        // Test case 5
        // Data: 1100, Encoded: 0111000, Received: 10110000
        $display("Test Case 5");
        code = 8'b0111000; //Word With error on the second data bit
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        $display("\n\n");

        // Test case 6
        // Data: 1100, Encoded: 01111000, Received: 
        $display("Test Case 6");
        code = 8'b10011000; //Word With error on the second data bit
        #10;
        $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
        $display("\n\n");

        // // Test case 5

        // code = 7'b1010010;
        // #10;
        // $display("Code: %b, Decoded: %b, Error: %b",code, decoded_data, error);
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