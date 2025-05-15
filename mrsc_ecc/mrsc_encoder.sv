module mrsc_encoder(
    input logic [15:0] in_word,
    output logic [31:0] encoded_word
);

logic [3:0] A_BITS, B_BITS, C_BITS, D_BITS; //Data bits
logic DI_1, DI_2, DI_3, DI_4; //Diagonal bits
logic P1, P2, P3, P4; //Parity bits
logic XA_1_3, XA_2_4; //Check bits A
logic XB_1_3, XB_2_4; //Check bits B
logic XC_1_3, XC_2_4; //Check bits C
logic XD_1_3, XD_2_4; //Check bits D


always_comb begin

    // Assigning the input word to the data bits
    {A_BITS[3], A_BITS[2], A_BITS[1], A_BITS[0]} = in_word[3:0]; // A_BITS = in_word[3:0];
    {B_BITS[3], B_BITS[2], B_BITS[1], B_BITS[0]} = in_word[7:4]; // B_BITS = in_word[7:4];
    {C_BITS[3], C_BITS[2], C_BITS[1], C_BITS[0]} = in_word[11:8]; // C_BITS = in_word[11:8];
    {D_BITS[3], D_BITS[2], D_BITS[1], D_BITS[0]} = in_word[15:12]; // D_BITS = in_word[15:12];

    // Computing the MRSC's Diagonal bits
    DI_1 = A_BITS[0] ^ B_BITS[1] ^ C_BITS[0] ^ D_BITS[1]; // XORing the bits A1 ⊕ B2 ⊕ C1 ⊕ D2 to obtain DI_1
    DI_2 = A_BITS[1] ^ B_BITS[0] ^ C_BITS[1] ^ D_BITS[0]; // XORing the bits A2 ⊕ B1 ⊕ C2 ⊕ D1 to obtain DI_2
    DI_3 = A_BITS[2] ^ B_BITS[3] ^ C_BITS[2] ^ D_BITS[3]; // XORing the bits A3 ⊕ B4 ⊕ C3 ⊕ D4 to obtain DI_3
    DI_4 = A_BITS[3] ^ B_BITS[2] ^ C_BITS[3] ^ D_BITS[2]; // XORing the bits A4 ⊕ B3 ⊕ C4 ⊕ D3 to obtain DI_4

    // Computing the MRSC's Parity bits
    P1 = A_BITS[0] ^ B_BITS[0] ^ C_BITS[0] ^ D_BITS[0]; // XORing the bits A1 ⊕ B1 ⊕ C1 ⊕ D1 to obtain P1
    P2 = A_BITS[1] ^ B_BITS[1] ^ C_BITS[1] ^ D_BITS[1]; // XORing the bits A2 ⊕ B2 ⊕ C2 ⊕ D2 to obtain P2
    P3 = A_BITS[2] ^ B_BITS[2] ^ C_BITS[2] ^ D_BITS[2]; // XORing the bits A3 ⊕ B3 ⊕ C3 ⊕ D3 to obtain P3
    P4 = A_BITS[3] ^ B_BITS[3] ^ C_BITS[3] ^ D_BITS[3]; // XORing the bits A4 ⊕ B4 ⊕ C4 ⊕ D4 to obtain P4

    // Computing the MRSC's Check bits
    XA_1_3 = A_BITS[0] ^ A_BITS[2];
    XA_2_4 = A_BITS[1] ^ A_BITS[3];
    XB_1_3 = B_BITS[0] ^ B_BITS[2];
    XB_2_4 = B_BITS[1] ^ B_BITS[3];
    XC_1_3 = C_BITS[0] ^ C_BITS[2];
    XC_2_4 = C_BITS[1] ^ C_BITS[3];
    XD_1_3 = D_BITS[0] ^ D_BITS[2];
    XD_2_4 = D_BITS[1] ^ D_BITS[3];

end


assign encoded_word = {in_word, DI_1, DI_2, 
                        DI_3, DI_4, P1, P2, P3, P4,
                        XA_1_3, XA_2_4, XB_1_3, XB_2_4,
                        XC_1_3, XC_2_4, XD_1_3, XD_2_4};



endmodule