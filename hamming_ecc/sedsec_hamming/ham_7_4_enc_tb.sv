module hamming_encode_tb();
    logic [4:1] data;
    logic [7:1] code;

    hamming_code_encoder DUT (
        .data_in(data),
        .code_out(code)
    );

    initial begin
        // Test case 1
        data = 4'b1100;  // Takes input as D4,D3,D2,D1
        #10;
        $display("[ P1 = %b | P2 = %b | P3 = %b ]", DUT.p1, DUT.p2, DUT.p3);
        $display("[ data_in = %b ]", DUT.data_in);
        $display("[ data_in[4] = %b ]", DUT.data_in[4]);
        $display("[ data_in[3] = %b ]", DUT.data_in[3]);
        $display("[ data_in[2] = %b ]", DUT.data_in[2]);
        $display("[ data_in[1] = %b ]", DUT.data_in[1]);
        $display("[ code_out = %b ]", DUT.code_out);
        $display("Data: %b, Encoded: %b", data, code);
        #10;
        // Test case 2
        data = 4'b1010;
        #10;
        $display("Data: %b, Encoded: %b", data, code);

        for(int i = 1; i <= 4; i++) begin
            data = i;
            #10;
            $display("Data: %b, Encoded: %b", data, code);
        end


        // End simulation
        $finish;
    end
endmodule