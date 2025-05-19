/*
    Implemntation of the MRSC decoder proposed by SILVA et al, 2017.
    DOI: 10.1145/3109984.3110001
*/
module mrsc_decoder(
    input logic [31:0] in_word,
    output logic [15:0] decoded_word,
    output logic [1:0] error_code
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
logic [3:0] diagonal_parity_sum_1_2;
logic [3:0] diagonal_parity_sum_3_4;
logic [7:0] more_than_one_check_bit;
logic [7:0] region_1_2_SX_matrix;
logic [7:0] region_3_SX_matrix;
logic [7:0] region_1_corrected_bits;
logic [7:0] region_2_corrected_bits;
logic [7:0] region_3_corrected_bits;


always_comb begin

    rcvd_data_bits = in_word[31:16]; // Assigning the received data bits to the auxiliary variable
    rcvd_diagonal_bits = in_word[15:12]; // Assigning the received diagonal bits to the auxiliary variable
    rcvd_parity_bits = in_word[11:8]; // Assigning the received parity bits to the auxiliary variable
    rcvd_check_bits = in_word[7:0]; // Assigning the received check bits to the auxiliary variable

    // Assigning the input word to the data bits
    {A_BITS[3], A_BITS[2], A_BITS[1], A_BITS[0]} = rcvd_data_bits[15:12]; // A_BITS = rcvd_data_bits[15:12];
    {B_BITS[3], B_BITS[2], B_BITS[1], B_BITS[0]} = rcvd_data_bits[11:8];  // B_BITS = rcvd_data_bits[11:8];
    {C_BITS[3], C_BITS[2], C_BITS[1], C_BITS[0]} = rcvd_data_bits[7:4];   // C_BITS = rcvd_data_bits[7:4];
    {D_BITS[3], D_BITS[2], D_BITS[1], D_BITS[0]} = rcvd_data_bits[3:0];   // D_BITS = rcvd_data_bits[3:0];

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

    // XORing the locally computed check bits with received check bits to obtain the check bits syndrome bits
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
    more_than_one_check_bit = XA_1_3_SYNDROME + XA_2_4_SYNDROME + XB_1_3_SYNDROME + XB_2_4_SYNDROME +
                              XC_1_3_SYNDROME + XC_2_4_SYNDROME + XD_1_3_SYNDROME + XD_2_4_SYNDROME;
    
    region_1_2_SX_matrix = {XA_1_3_SYNDROME, XA_2_4_SYNDROME, XB_1_3_SYNDROME, XB_2_4_SYNDROME,
                              XC_1_3_SYNDROME, XC_2_4_SYNDROME, XD_1_3_SYNDROME, XD_2_4_SYNDROME};

    region_3_SX_matrix = {XA_2_4_SYNDROME, XA_1_3_SYNDROME, XB_2_4_SYNDROME, XB_1_3_SYNDROME,
                              XC_2_4_SYNDROME, XC_1_3_SYNDROME, XD_2_4_SYNDROME, XD_1_3_SYNDROME};

    diagonal_parity_sum_1_2 = DI_1_SYNDROME + DI_2_SYNDROME + P1_SYNDROME + P2_SYNDROME;
    diagonal_parity_sum_3_4 = DI_3_SYNDROME + DI_4_SYNDROME + P3_SYNDROME + P4_SYNDROME;

    if ((at_least_one_diagonal && at_least_one_parity) || (more_than_one_check_bit > 1))  begin
        // Condition Satisfied: At least one bit from diagon and parity bits is 1
        //      OR
        // Condition Satisfied: More than one check bit is 1
            if  ( diagonal_parity_sum_1_2 > diagonal_parity_sum_3_4 ) begin
                    //Condition Satisfied: Region 1 selected
                    /* To fix the bits on the Region 1, we need to XOR its bits with the 
                       bits from region_1_2_SX_matrix.
                       
                       I mean, taking the region 1 bit A1, it will be XORed with the Region 1 Matrix
                       correction bit XA_1_3_SYNDROME. The bit A2 from the same region, will
                       be XORed with the bit XA_2_4_SYNDROME. And so on.

                    */
                                                 
                    region_1_corrected_bits[7] = rcvd_data_bits[15] ^ region_1_2_SX_matrix[7]; //A1 ⊕ XA_1_3_SYNDROME
                    region_1_corrected_bits[6] = rcvd_data_bits[14] ^ region_1_2_SX_matrix[6]; //A2 ⊕ XA_2_4_SYNDROME
                    region_1_corrected_bits[5] = rcvd_data_bits[11] ^ region_1_2_SX_matrix[5]; //B1 ⊕ XB_1_3_SYNDROME
                    region_1_corrected_bits[4] = rcvd_data_bits[10] ^ region_1_2_SX_matrix[4]; //B2 ⊕ XB_2_4_SYNDROME
                    region_1_corrected_bits[3] = rcvd_data_bits[7] ^ region_1_2_SX_matrix[3]; //C1 ⊕ XC_1_3_SYNDROME
                    region_1_corrected_bits[2] = rcvd_data_bits[6] ^ region_1_2_SX_matrix[2]; //C2 ⊕ XC_2_4_SYNDROME
                    region_1_corrected_bits[1] = rcvd_data_bits[3] ^ region_1_2_SX_matrix[1]; //D1 ⊕ XD_1_3_SYNDROME
                    region_1_corrected_bits[0] = rcvd_data_bits[2] ^ region_1_2_SX_matrix[0]; //D2 ⊕ XD_2_4_SYNDROME

                    // To build the decoded corrected word, we replace the received data bits 
                    // from the region 1 with the corrected bits for this region.
                    decoded_word = {region_1_corrected_bits[7:6], rcvd_data_bits[13:12], 
                                    region_1_corrected_bits[5:4], rcvd_data_bits[9:8],
                                    region_1_corrected_bits[3:2], rcvd_data_bits[5:4],
                                    region_1_corrected_bits[1:0], rcvd_data_bits[1:0]};

                    error_code = 2'b01; //Error on Region 1 flag;
                end 
            else if ( diagonal_parity_sum_1_2 < diagonal_parity_sum_3_4 ) begin
                    //Condition Satisfied: Region 2 selected
                    /* To fix the bits on the Region 2, we need to XOR its bits with the 
                       bits from region_1_2_SX_matrix.
                    */
                    region_2_corrected_bits[7] = rcvd_data_bits[13] ^ region_1_2_SX_matrix[7];
                    region_2_corrected_bits[6] = rcvd_data_bits[12] ^ region_1_2_SX_matrix[6];
                    region_2_corrected_bits[5] = rcvd_data_bits[9] ^ region_1_2_SX_matrix[5];
                    region_2_corrected_bits[4] = rcvd_data_bits[8] ^ region_1_2_SX_matrix[4];
                    region_2_corrected_bits[3] = rcvd_data_bits[5] ^ region_1_2_SX_matrix[3];
                    region_2_corrected_bits[2] = rcvd_data_bits[4] ^ region_1_2_SX_matrix[2];
                    region_2_corrected_bits[1] = rcvd_data_bits[1] ^ region_1_2_SX_matrix[1];
                    region_2_corrected_bits[0] = rcvd_data_bits[0] ^ region_1_2_SX_matrix[0];

                    // To build the decoded corrected word, we replace the received data bits
                    // from the region 2 with the corrected bits for this region.
                    decoded_word = {rcvd_data_bits[15:14], region_2_corrected_bits[7:6], 
                                    rcvd_data_bits[11:10], region_2_corrected_bits[5:4],
                                    rcvd_data_bits[7:6], region_2_corrected_bits[3:2],
                                    rcvd_data_bits[3:2], region_2_corrected_bits[1:0]};

                    error_code = 2'b10; //Error on Region 2 flag;
            end
            else if ( diagonal_parity_sum_1_2 == diagonal_parity_sum_3_4 ) begin
                    //Condition Satisfied: Region 3 selected
                    /* To fix the bits on the Region 3, we need to XOR its bits with the 
                       bits from region_3_SX_matrix.
                    */

                    region_3_corrected_bits[7] = rcvd_data_bits[14] ^ region_3_SX_matrix[7];
                    region_3_corrected_bits[6] = rcvd_data_bits[13] ^ region_3_SX_matrix[6];
                    region_3_corrected_bits[5] = rcvd_data_bits[10] ^ region_3_SX_matrix[5];
                    region_3_corrected_bits[4] = rcvd_data_bits[9] ^ region_3_SX_matrix[4];
                    region_3_corrected_bits[3] = rcvd_data_bits[6] ^ region_3_SX_matrix[3];
                    region_3_corrected_bits[2] = rcvd_data_bits[5] ^ region_3_SX_matrix[2];
                    region_3_corrected_bits[1] = rcvd_data_bits[2] ^ region_3_SX_matrix[1];
                    region_3_corrected_bits[0] = rcvd_data_bits[1] ^ region_3_SX_matrix[0];

                    // To build the decoded corrected word, we replace the received data bits
                    // from the region 3 with the corrected bits for this region.
                    decoded_word = {rcvd_data_bits[15], region_3_corrected_bits[7:6], rcvd_data_bits[12],
                                    rcvd_data_bits[11], region_3_corrected_bits[5:4], rcvd_data_bits[8],
                                    rcvd_data_bits[7], region_3_corrected_bits[3:2], rcvd_data_bits[4],
                                    rcvd_data_bits[3], region_3_corrected_bits[1:0], rcvd_data_bits[0]};

                    error_code = 2'b11; //Error on Region 3 flag; 
            end
            
        
    end else begin
        //Condition not satisfied: No correction possible
        decoded_word = rcvd_data_bits; // No correction possible, so we keep the received data bits
        error_code = 2'b00; //No correction possible
    end
end
    


endmodule