module mrsc_decoder_tb (
);

logic [31:0] mock_in_word;
logic [15:0] out_decoded_word;
logic [1:0] out_error_code;


// Instantiate the DUT
mrsc_decoder dut (
    .in_word(mock_in_word),
    .decoded_word(out_decoded_word),
    .error_code(out_error_code)
);


logic [3:0] auxiliary;

initial begin

    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 1:  Base Case, simple decoding");
    mock_in_word = 32'b10000000111110100100101110000000; // Example input.
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the computed bits from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 2: Bits 29 and 28 flipped from one to zero");
    mock_in_word = 32'b10110000111110100100101110000000; // Example input. Bits 29 and 28 flipped from zero to one.
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);
    
    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 3: Bit 31 flipped to 0 and 27 flipped to 1");
    mock_in_word = 32'b00001000111110100100101110000000; 
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);
    
    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 4: Bit 30 flipped to 1 and 25 flipped to 1");
    mock_in_word = 32'b11000010111110100100101110000000; 
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);
   
    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 5: Bit 28 flipped to 1 and 15 flipped to 1");
    mock_in_word = 32'b10010000111110101100101110000000; // Test Case 5: Bit 28 flipped to 1 and 15 flipped to 1
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);

    $display("Test Case 6: Bit 16 flipped to 0 and 7 flipped to 0");
    mock_in_word = 32'b10000000111110100000101100000000;
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);

    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 7: Bit 31 flipped to 0, Bit 30 to 1, Bit 29 to 1, Bit 27 to 1");
    mock_in_word = 32'b01100100111110100100101110000000;
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);
    
    
    //Expected output: 16'b1000000011111010 == 16'h80FA
    $display("Test Case 8: Bit 31 flipped to 0, Bit 27 to 1, Bit 26 to 1, Bit 20 to 0");
    mock_in_word = 32'b00001100011110100100101110000000;
    #10; // Wait for 10 time units
    $display("      Input: %b || Decoded Output: %b / %h", mock_in_word, out_decoded_word, out_decoded_word);
    $display("      Error Code: %b", out_error_code);
    $display("      Matrix Format Output with the diagonal, parity and check bits computed from the received word:");
    $display("      %b     %b     %b", {dut.A_BITS[3], dut.A_BITS[2], dut.A_BITS[1], dut.A_BITS[0]}, {dut.DI_1, dut.DI_3}, {dut.XA_1_3, dut.XA_2_4});
    $display("      %b     %b     %b", {dut.B_BITS[3], dut.B_BITS[2], dut.B_BITS[1], dut.B_BITS[0]}, {dut.DI_2, dut.DI_4}, {dut.XB_1_3, dut.XB_2_4});
    $display("      %b     %b     %b", {dut.C_BITS[3], dut.C_BITS[2], dut.C_BITS[1], dut.C_BITS[0]}, {dut.P1, dut.P3}, {dut.XC_1_3, dut.XC_2_4});
    $display("      %b     %b     %b", {dut.D_BITS[3], dut.D_BITS[2], dut.D_BITS[1], dut.D_BITS[0]}, {dut.P2, dut.P4}, {dut.XD_1_3, dut.XD_2_4});

    $display("\n      SDI_1234 => %b ⊕ %b = %b", {dut.rcvd_diagonal_bits[3], dut.rcvd_diagonal_bits[1], 
                                                dut.rcvd_diagonal_bits[2], dut.rcvd_diagonal_bits[0]}, 
                                                {dut.DI_1, dut.DI_2, dut.DI_3, dut.DI_4}, 
                                                {dut.DI_1_SYNDROME, dut.DI_2_SYNDROME, dut.DI_3_SYNDROME, dut.DI_4_SYNDROME});

    $display("\n      SP_1234 => %b ⊕ %b = %b", {dut.rcvd_parity_bits[3], dut.rcvd_parity_bits[1],
                                            dut.rcvd_parity_bits[2], dut.rcvd_parity_bits[0]},
                                            {dut.P1, dut.P2, dut.P3, dut.P4}, 
                                            {dut.P1_SYNDROME, dut.P2_SYNDROME, dut.P3_SYNDROME, dut.P4_SYNDROME});

    $display("\n       SX:");
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[7], dut.XA_1_3, dut.XA_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[6], dut.XA_2_4, dut.XA_2_4_SYNDROME);

    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[5], dut.XB_1_3, dut.XB_1_3_SYNDROME,
                                                     dut.rcvd_check_bits[4], dut.XB_2_4, dut.XB_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[3], dut.XC_1_3, dut.XC_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[2], dut.XC_2_4, dut.XC_2_4_SYNDROME);
    
    $display("      %b ⊕ %b  = %b | %b ⊕ %b  = %b ", dut.rcvd_check_bits[1], dut.XD_1_3, dut.XD_1_3_SYNDROME,
                                                        dut.rcvd_check_bits[0], dut.XD_2_4, dut.XD_2_4_SYNDROME);


    $display("\n      at_least_one_diagonal = %b", dut.at_least_one_diagonal);
    $display("      at_least_one_parity = %b", dut.at_least_one_parity);
    $display("      more_than_one_check_bit = %b", dut.more_than_one_check_bit);

    $display("\n      SD1 = %b | SD2 = %b", dut.DI_1_SYNDROME, dut.DI_2_SYNDROME);
    $display("      SP1 = %b | SP2 = %b", dut.P1_SYNDROME, dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum = %d", (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME));
    auxiliary = (dut.DI_1_SYNDROME + dut.DI_2_SYNDROME + dut.P1_SYNDROME + dut.P2_SYNDROME);
    $display("      1_2_diagonal_parity_sum_2 = %b", auxiliary);


    $display("\n      SD3 = %b | SD4 = %b", dut.DI_3_SYNDROME, dut.DI_4_SYNDROME);
    $display("      SP3 = %b | SP4 = %b", dut.P3_SYNDROME, dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum = %d", dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    auxiliary = (dut.DI_3_SYNDROME + dut.DI_4_SYNDROME + dut.P3_SYNDROME + dut.P4_SYNDROME);
    $display("      3_4_diagonal_parity_sum_2 = %b", auxiliary);








  end

    
endmodule