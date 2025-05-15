module hamming_code_decoder(
    input logic [8:1] code_in,   // 7-bit Hamming code input
    output logic [4:1] data_out, // 4-bit message bits data output
    output logic [2:1] error       // Error flag
    );

    // Calculate syndrome bits
    logic s1, s2, s3, sG;
    logic [7:1] word_payload;

    assign word_payload = code_in[8:2]; // Extracting the 7 bits of the received word from the 8th general parity bit

    assign s1 = word_payload[7] ^ word_payload[5] ^ word_payload[3] ^ word_payload[1];     //p1 checking d3,d5,d7 and the parity type 
    assign s2 = word_payload[6] ^ word_payload[5] ^ word_payload[2] ^ word_payload[1];     //p2 checking d3,d6,d7 and the parity type 
    assign s3 = word_payload[4] ^ word_payload[3] ^ word_payload[2] ^ word_payload[1];     //p4 checking d5,d6,d7 and the parity type
    //The following computes the parity for the parity general bit. this bit holds the parity for the rest of the 7 bits of the received word.
    assign sG = code_in[8] ^ code_in[7] ^ code_in[6] ^ code_in[5] ^ code_in[4] ^ code_in[3] ^ code_in[2] ^ code_in[1]; //pg checking d1,d2,d3,d4,d5,d6,d7 and the parity type

    // Determine the error position
    logic [2:0] error_pos;
    assign error_pos = {s3, s2, s1};   

    logic [7:1] corrected_code;  //taking a register corrected data to change the error positioned bit
    always_comb begin
        corrected_code = code_in[8:2];
        if (error_pos != 3'b000) begin
            corrected_code[8 - error_pos] = ~corrected_code[8 - error_pos];  //inverting the error positioned bit
            error = 1; // Error detected and corrected
        end else begin
            error = 0; // No error
        end

        if (sG != 0) begin
            error = 2; // Indicates the presence of two errors
        end              
    end

    // assign data_out = {corrected_code[7], corrected_code[6], corrected_code[5], corrected_code[3]};   //1,2,4 positions are for parity bits, extracting 3,5,6,7 message data bits
    assign data_out = {corrected_code[5], corrected_code[3], corrected_code[2], corrected_code[1]};   //1,2,4 positions are for parity bits, extracting 3,5,6,7 message data bits
    // assign data_out = {corrected_code[3], corrected_code[5], corrected_code[6], corrected_code[7]};   //1,2,4 positions are for parity bits, extracting 3,5,6,7 message data bits
    
endmodule