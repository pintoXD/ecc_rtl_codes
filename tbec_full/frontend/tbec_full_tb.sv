//Expected output: 16'b1110000111110000 == 16'hE1F0
module tbec_full_tb ();
    
    logic clk;
    logic [7:0] mock_addr;
    logic [15:0] mock_data_in;
    logic mem_we;
    logic [15:0] dut_data_out;
    logic [1:0] out_error_code;

    // Instantiate the DUT
    tbec_full dut (
        .clk(clk),
        .tbec_addr(mock_addr),
        .data_in(mock_data_in),
        .mem_we(mem_we),
        .data_out(dut_data_out),
        .out_error_code(out_error_code)
    );

    initial begin
        clk = 0;
        #5;
        forever begin
            #5 clk = ~clk; // Toggle clock every 5 time units
        end
    end

    initial begin
        // Initialize inputs
        mem_we = 0;
        mock_addr = 8'h00;
        mock_data_in = 16'h0000;

        // Wait for the clock to stabilize
        #10;

        // Write to memory
        mem_we = 1;
        mock_addr = 8'h01;
        mock_data_in = 16'hE1F0;
        #20;
        mem_we = 0; // Disable write after first write
        #100;

        /*
        // Write to memory
        mem_we = 1;
        mock_addr = 8'h02;
        mock_data_in = 16'hBBCC;
        #10;

        // Write to memory
        mem_we = 1;
        mock_addr = 8'h07;
        mock_data_in = 16'hFFA0;
        #10;

        // Read from memory
        mem_we = 0;
        mock_addr = 8'h01;
        #10;*/
        
        // Check output
        assert (dut_data_out == 16'hE1F0) else $fatal("Output mismatch: expected 16'b1110000111110000, got %b", dut_data_out);

        $finish; // End simulation
        
    end


endmodule