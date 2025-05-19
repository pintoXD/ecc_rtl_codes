/*
    Implemntation of the TBEC encoder proposed by SILVA et al, 2017.
    DOI: 10.1109/TVLSI.2023.3273085
*/

module tbec_encoder(
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
    {A_BITS[3], A_BITS[2], A_BITS[1], A_BITS[0]} = in_word[15:12]; // A_BITS = in_word[15:12];
    {B_BITS[3], B_BITS[2], B_BITS[1], B_BITS[0]} = in_word[11:8];  // B_BITS = in_word[11:8];
    {C_BITS[3], C_BITS[2], C_BITS[1], C_BITS[0]} = in_word[7:4];   // C_BITS = in_word[7:4];
    {D_BITS[3], D_BITS[2], D_BITS[1], D_BITS[0]} = in_word[3:0];   // D_BITS = in_word[3:0];

    // Computing the TBEC's Diagonal bits
    DI_1 = A_BITS[3] ^ B_BITS[2] ^ C_BITS[3] ^ D_BITS[2]; // XORing the bits A1 ⊕ B2 ⊕ C1 ⊕ D2 to obtain DI_1
    DI_2 = A_BITS[2] ^ B_BITS[3] ^ C_BITS[2] ^ D_BITS[3]; // XORing the bits A2 ⊕ B1 ⊕ C2 ⊕ D1 to obtain DI_2
    DI_3 = A_BITS[1] ^ B_BITS[0] ^ C_BITS[1] ^ D_BITS[0]; // XORing the bits A3 ⊕ B4 ⊕ C3 ⊕ D4 to obtain DI_3
    DI_4 = A_BITS[0] ^ B_BITS[1] ^ C_BITS[0] ^ D_BITS[1]; // XORing the bits A4 ⊕ B3 ⊕ C4 ⊕ D3 to obtain DI_4

    // Computing the TBEC's Parity bits
    P1 = A_BITS[3] ^ A_BITS[2] ^ B_BITS[3] ^ B_BITS[2]; // XORing the bits A1 ⊕ A2 ⊕ B1 ⊕ B2 to obtain P1
    P2 = C_BITS[3] ^ C_BITS[2] ^ D_BITS[3] ^ D_BITS[2]; // XORing the bits C1 ⊕ C2 ⊕ D1 ⊕ D2 to obtain P2
    P3 = A_BITS[1] ^ A_BITS[0] ^ B_BITS[1] ^ B_BITS[0]; // XORing the bits A3 ⊕ A4 ⊕ B3 ⊕ B4 to obtain P3
    P4 = C_BITS[1] ^ C_BITS[0] ^ D_BITS[1] ^ D_BITS[0]; // XORing the bits C3 ⊕ C4 ⊕ D3 ⊕ D4 to obtain P4


    // Computing the TBEC's Check bits
    //       Bit A1       Bit A3   
    XA_1_3 = A_BITS[3] ^ A_BITS[1]; // XORing the bits A1 ⊕ A3 to obtain XA_1_3
    //       Bit A2       Bit A4
    XA_2_4 = A_BITS[2] ^ A_BITS[0]; // XORing the bits A2 ⊕ A4 to obtain XA_2_4

    //       Bit B1       Bit B3
    XB_1_3 = B_BITS[3] ^ B_BITS[1]; // XORing the bits B1 ⊕ B3 to obtain XB_1_3
    //       Bit B2       Bit B4
    XB_2_4 = B_BITS[2] ^ B_BITS[0]; // XORing the bits B2 ⊕ B4 to obtain XB_2_4

    //       Bit C1       Bit C3
    XC_1_3 = C_BITS[3] ^ C_BITS[1]; // XORing the bits C1 ⊕ C3 to obtain XC_1_3
    //       Bit C2       Bit C4
    XC_2_4 = C_BITS[2] ^ C_BITS[0]; // XORing the bits C2 ⊕ C4 to obtain XC_2_4

    //       Bit D1       Bit D3
    XD_1_3 = D_BITS[3] ^ D_BITS[1]; // XORing the bits D1 ⊕ D3 to obtain XD_1_3
    //       Bit D2       Bit D4
    XD_2_4 = D_BITS[2] ^ D_BITS[0]; // XORing the bits D2 ⊕ D4 to obtain XD_2_4
    

end


assign encoded_word = {A_BITS[3], B_BITS[3], C_BITS[3], D_BITS[3], // A1, B1, C1, D1
                        A_BITS[2], B_BITS[2], C_BITS[2], D_BITS[2], // A2, B2, C2, D2
                        A_BITS[1], B_BITS[1], C_BITS[1], D_BITS[1], // A3, B3, C3, D3
                        A_BITS[0], B_BITS[0], C_BITS[0], D_BITS[0], // A4, B4, C4, D4
                        DI_1, DI_4, DI_2, DI_3, P1, P4, P2, P3,
                        XA_1_3, XA_2_4, XB_1_3, XB_2_4,
                        XC_1_3, XC_2_4, XD_1_3, XD_2_4};



endmodule