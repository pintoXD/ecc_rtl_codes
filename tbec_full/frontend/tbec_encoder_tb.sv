module tbec_encoder_tb (
);
    logic [15:0] mock_in_word;
    logic [31:0] out_encoded_word;

    // Instantiate the DUT
    tbec_encoder dut (
        .in_word(mock_in_word),
        .encoded_word(out_encoded_word)
    );


    logic [3:0] test_vector;
    initial begin
        // 1110000111110000
        mock_in_word = 16'b1110000111110000; // Example input
        #10; // Wait for 10 time units
        $display("      Input: %b || Encoded Output: %b", mock_in_word, out_encoded_word);
        $display("      Matrix Format Output:");
        $display("      %b     %b     %b", {out_encoded_word[31], out_encoded_word[27], out_encoded_word[23], out_encoded_word[19]}, 
                                           {out_encoded_word[15], out_encoded_word[12]}, out_encoded_word[7:6]);

        $display("      %b     %b     %b", {out_encoded_word[30], out_encoded_word[26], out_encoded_word[22], out_encoded_word[18]}, 
                                           {out_encoded_word[13], out_encoded_word[14]}, out_encoded_word[5:4]);
        
        $display("      %b     %b     %b", {out_encoded_word[29], out_encoded_word[25], out_encoded_word[21], out_encoded_word[17]}, 
                                           {out_encoded_word[11], out_encoded_word[8]}, out_encoded_word[3:2]);
        
        $display("      %b     %b     %b", {out_encoded_word[28], out_encoded_word[24], out_encoded_word[20], out_encoded_word[16]}, 
                                           {out_encoded_word[9], out_encoded_word[10]}, out_encoded_word[1:0]);

        $display("      Line format output:");
        $display("      %b %b%b%b%b %b%b%b%b %b", out_encoded_word[31:16], out_encoded_word[15], out_encoded_word[12], out_encoded_word[13], out_encoded_word[14],
                                      out_encoded_word[11], out_encoded_word[8], out_encoded_word[9], out_encoded_word[10], out_encoded_word[7:0]
        );


        $display("DI_1 = %b | DI_2 = %b", dut.DI_1, dut.DI_2);
        $display("DI_3 = %b | DI_4 = %b", dut.DI_3, dut.DI_4);
        $display("P1 = %b | P2 = %b", dut.P1, dut.P2);
        $display("P3 = %b | P4 = %b", dut.P3, dut.P4);
        $display("XA_1_3 = %b | XA_2_4 = %b", dut.XA_1_3, dut.XA_2_4);
        $display("XB_1_3 = %b | XB_2_4 = %b", dut.XB_1_3, dut.XB_2_4);
        $display("XC_1_3 = %b | XC_2_4 = %b", dut.XC_1_3, dut.XC_2_4);
        $display("XD_1_3 = %b | XD_2_4 = %b", dut.XD_1_3, dut.XD_2_4);     
        /*
        mock_in_word = 16'b0; // Example input 2
        #10; // Wait for 10 time units
        $display("      Input: %b || Encoded Output: %b", mock_in_word, out_encoded_word);
        $display("      Matrix Format Output:");
        $display("      %b     %b     %b", out_encoded_word[31:28], out_encoded_word[15:14], out_encoded_word[7:6]);
        $display("      %b     %b     %b", out_encoded_word[27:24], out_encoded_word[13:12], out_encoded_word[5:4]);
        $display("      %b     %b     %b", out_encoded_word[23:20], out_encoded_word[11:10], out_encoded_word[3:2]);
        $display("      %b     %b     %b", out_encoded_word[19:16], out_encoded_word[9:8], out_encoded_word[1:0]);

         mock_in_word = 16'hFF; // Example input 3
        #10; // Wait for 10 time units
        $display("      Input: %b || Encoded Output: %b", mock_in_word, out_encoded_word);
        $display("      Matrix Format Output:");
        $display("      %b     %b     %b", out_encoded_word[31:28], out_encoded_word[15:14], out_encoded_word[7:6]);
        $display("      %b     %b     %b", out_encoded_word[27:24], out_encoded_word[13:12], out_encoded_word[5:4]);
        $display("      %b     %b     %b", out_encoded_word[23:20], out_encoded_word[11:10], out_encoded_word[3:2]);
        $display("      %b     %b     %b", out_encoded_word[19:16], out_encoded_word[9:8], out_encoded_word[1:0]);

        mock_in_word = 16'b0000010000000000; // Example input 4 - 1024 in decimal
        #10; // Wait for 10 time units
        $display("      Input: %b || Encoded Output: %b", mock_in_word, out_encoded_word);
        $display("      Matrix Format Output:");
        $display("      %b     %b     %b", out_encoded_word[31:28], out_encoded_word[15:14], out_encoded_word[7:6]);
        $display("      %b     %b     %b", out_encoded_word[27:24], out_encoded_word[13:12], out_encoded_word[5:4]);
        $display("      %b     %b     %b", out_encoded_word[23:20], out_encoded_word[11:10], out_encoded_word[3:2]);
        $display("      %b     %b     %b", out_encoded_word[19:16], out_encoded_word[9:8], out_encoded_word[1:0]);

        test_vector = {1'b1,1'b0,1'b1,1'b0};

        $display("      Test Vector: %b", test_vector[0]);
        */
    end


endmodule