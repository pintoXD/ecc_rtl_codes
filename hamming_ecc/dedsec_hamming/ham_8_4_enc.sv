module hamming_code_encoder(
    input [1:4] data_in,
    output [8:1] code_out  
    );
    
    // Calculate parity bits
    logic p1, p2, p3, pg;
    
    // Parity bit computing
    assign p1 = data_in[1] ^ data_in[2] ^ data_in[4];
    assign p2 = data_in[1] ^ data_in[3] ^ data_in[4];
    assign p3 = data_in[2] ^ data_in[3] ^ data_in[4];
    assign pg = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ p1 ^ p2 ^ p3; // General parity bit
    // assign p1 = data_in[4] ^ data_in[3] ^ data_in[1];
    // assign p2 = data_in[4] ^ data_in[2] ^ data_in[1];
    // assign p3 = data_in[3] ^ data_in[2] ^ data_in[1];
    


    // Assign the Hamming code output
    assign code_out = {p1, p2, data_in[1], p3, data_in[2], data_in[3], data_in[4], pg}; // Final code output
    // assign code_out = {p1, p2, data_in[4], p3, data_in[3], data_in[2], data_in[1]}; // Final code output

endmodule