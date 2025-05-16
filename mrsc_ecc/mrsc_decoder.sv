/*
    Implemntation of the MRSC encoder proposed by SILVA et al, 2017.
    DOI: 10.1145/3109984.3110001
*/
module mrsc_decoder(
    input logic [31:0] in_word;
    output logic [15:0] decoded_word;
    output logic [1:0] error_code;
);

/*
    That's somewaht confusing, but the way bits are assigned and computed into new bits, in this implementation, differs from
    the presented in the paper by its indexes. I mean, what the paper calls A1 is not the same as A_BITS[1] here.    
    This happens because the indexing on real life implementation differs from the indexing used in the paper.
    In other words, this implementations uses a Little Endian approach, while the paper uses a Big Endian approach.

    So, whemever you see A1 it will be translated to the bit A_BITS[3]. Tha same applies to bit A2, that
    translates to the bit A_BITS[2]. It applies to all the other bits. 

    That's why we need to be careful while setting up the diagonal, parity and checking bits.

*/

// Like the encoder, we need to compute the diagonal, parity and check bits in order to
// compute the current syndrome bits, by comparing the received bits with the computed ones.
logic [3:0] A_BITS, B_BITS, C_BITS, D_BITS; //Data bits
logic DI_1, DI_2, DI_3, DI_4; //Diagonal bits
logic P1, P2, P3, P4; //Parity bits
logic XA_1_3, XA_2_4; //Check bits A
logic XB_1_3, XB_2_4; //Check bits B
logic XC_1_3, XC_2_4; //Check bits C
logic XD_1_3, XD_2_4; //Check bits D

logic DI_1_SYNDROME, DI_2_SYNDROME, DI_3_SYNDROME, DI_4_SYNDROME; //Data bits syndrome bits
logic P1_SYNDROME, P2_SYNDROME, P3_SYNDROME, P4_SYNDROME; //Parity bits syndrome bits
logic XA_1_3_SYNDROME, XA_2_4_SYNDROME; //Check bits A syndrome bits
logic XB_1_3_SYNDROME, XB_2_4_SYNDROME; //Check bits B syndrome bits
logic XC_1_3_SYNDROME, XC_2_4_SYNDROME; //Check bits C syndrome bits
logic XD_1_3_SYNDROME, XD_2_4_SYNDROME; //Check bits D syndrome bits

/* This axuiliary variable is used to hold the bits corresponding to the
   data bits present in the received in_word. */
logic [15:0] rcvd_data_bits;  

/* This axuiliary variable is used to hold the bits corresponding to the
   diagonal bits present in the received in_word.*/
logic [3:0] rcvd_diagonal_bits; 

/* This axuiliary variable is used to hold the bits corresponding to the
   parity bits present in the received in_word.*/
logic [3:0] rcvd_parity_bits; 

/* This axuiliary variable is used to hold the bits corresponding to the
   check bits present in the received in_word.*/
logic [7:0] rcvd_check_bits; 

logic at_least_one_diagonal, at_least_one_parity;
logic [7:0] at_least_two_check_bits;


always_comb begin

    rcvd_data_bits = in_word[31:16]; // Assigning the received data bits to the auxiliary variable
    rcvd_diagonal_bits = in_word[15:12]; // Assigning the received diagonal bits to the auxiliary variable
    rcvd_parity_bits = in_word[11:8]; // Assigning the received parity bits to the auxiliary variable
    rcvd_check_bits = in_word[7:0]; // Assigning the received check bits to the auxiliary variable

    // Assigning the input word to the data bits
    {A_BITS[3], A_BITS[2], A_BITS[1], A_BITS[0]} = in_word[15:12]; // A_BITS = in_word[15:12];
    {B_BITS[3], B_BITS[2], B_BITS[1], B_BITS[0]} = in_word[11:8];  // B_BITS = in_word[11:8];
    {C_BITS[3], C_BITS[2], C_BITS[1], C_BITS[0]} = in_word[7:4];   // C_BITS = in_word[7:4];
    {D_BITS[3], D_BITS[2], D_BITS[1], D_BITS[0]} = in_word[3:0];   // D_BITS = in_word[3:0];

    // Computing the MRSC's Diagonal bits from the received data bits
    DI_1 = A_BITS[3] ^ B_BITS[2] ^ C_BITS[3] ^ D_BITS[2]; // XORing the bits A1 ⊕ B2 ⊕ C1 ⊕ D2 to obtain DI_1
    DI_2 = A_BITS[2] ^ B_BITS[3] ^ C_BITS[2] ^ D_BITS[3]; // XORing the bits A2 ⊕ B1 ⊕ C2 ⊕ D1 to obtain DI_2
    DI_3 = A_BITS[1] ^ B_BITS[0] ^ C_BITS[1] ^ D_BITS[0]; // XORing the bits A3 ⊕ B4 ⊕ C3 ⊕ D4 to obtain DI_3
    DI_4 = A_BITS[0] ^ B_BITS[1] ^ C_BITS[0] ^ D_BITS[1]; // XORing the bits A4 ⊕ B3 ⊕ C4 ⊕ D3 to obtain DI_4

    // Computing the MRSC's Parity bits from the received parity bits
    P1 = A_BITS[3] ^ B_BITS[3] ^ C_BITS[3] ^ D_BITS[3]; // XORing the bits A1 ⊕ B1 ⊕ C1 ⊕ D1 to obtain P1
    P2 = A_BITS[2] ^ B_BITS[2] ^ C_BITS[2] ^ D_BITS[2]; // XORing the bits A2 ⊕ B2 ⊕ C2 ⊕ D2 to obtain P2
    P3 = A_BITS[1] ^ B_BITS[1] ^ C_BITS[1] ^ D_BITS[1]; // XORing the bits A3 ⊕ B3 ⊕ C3 ⊕ D3 to obtain P3
    P4 = A_BITS[0] ^ B_BITS[0] ^ C_BITS[0] ^ D_BITS[0]; // XORing the bits A4 ⊕ B4 ⊕ C4 ⊕ D4 to obtain P4

    // Computing the MRSC's Check bits
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
    


    /*
        Computing the syndrome bits
    */
    // XORing the bits DI_1-4(locally computed) ⊕ received DI_1-4(retrieved from received data) to obtain DI_1-4_SYNDROME
    DI_1_SYNDROME = DI_1 ^ rcvd_diagonal_bits[3]; 
    DI_2_SYNDROME = DI_2 ^ rcvd_diagonal_bits[1];
    DI_3_SYNDROME = DI_3 ^ rcvd_diagonal_bits[2];
    DI_4_SYNDROME = DI_4 ^ rcvd_diagonal_bits[0];

    // XORing the bits P1-4(locally computed) ⊕ received P1-4(retrieved from received data) to obtain P1-4_SYNDROME
    P1_SYNDROME = P1 ^ rcvd_parity_bits[3];
    P2_SYNDROME = P2 ^ rcvd_parity_bits[1];
    P3_SYNDROME = P3 ^ rcvd_parity_bits[2];
    P4_SYNDROME = P4 ^ rcvd_parity_bits[0];

    // XORing the locally computed check bits with received check bits to obtain the syndrome bits
    XA_1_3_SYNDROME = XA_1_3 ^ rcvd_check_bits[7];
    XA_2_4_SYNDROME = XA_2_4 ^ rcvd_check_bits[6];
    XB_1_3_SYNDROME = XB_1_3 ^ rcvd_check_bits[5];
    XB_2_4_SYNDROME = XB_2_4 ^ rcvd_check_bits[4];
    XC_1_3_SYNDROME = XC_1_3 ^ rcvd_check_bits[3];
    XC_2_4_SYNDROME = XC_2_4 ^ rcvd_check_bits[2];
    XD_1_3_SYNDROME = XD_1_3 ^ rcvd_check_bits[1];
    XD_2_4_SYNDROME = XD_2_4 ^ rcvd_check_bits[0];


    /*  
        Checking if the received word could be corrected or not. 
        
        For this, according to the paper, at least one of the DI_x_SYNDROME and 
        Px_SYNDROME must have values equal do 1.

        Alongisde it, more than one X_SYNDROME needs to have a value equal to 1 and syndromes DI and
        P must not be null.
    */
    
    at_least_one_diagonal = DI_1_SYNDROME | DI_2_SYNDROME | DI_3_SYNDROME | DI_4_SYNDROME;
    at_least_one_parity = P1_SYNDROME | P2_SYNDROME | P3_SYNDROME | P4_SYNDROME;
    at_least_two_check_bits = XA_1_3_SYNDROME + XA_2_4_SYNDROME + XB_1_3_SYNDROME + XB_2_4_SYNDROME +
                              XC_1_3_SYNDROME + XC_2_4_SYNDROME + XD_1_3_SYNDROME + XD_2_4_SYNDROME;
    

    if (at_least_one_diagonal && at_least_one_parity) begin
        // Condition Satisfied: At least one bit from diagon and parity bits is 1
        if (at_least_two_check_bits >= 2)begin
            //Condition Satisfied: At least two check bits are 1

            if()
            
        end
    end else begin

    end




end
    


endmodule