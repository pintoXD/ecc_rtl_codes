`timescale 1ns/10ps
module tbec_memory_tb (
);

    logic clk;
    logic mock_we;
    logic [7:0] mock_addr;
    logic [31:0] mock_data_in;
    logic [31:0] dut_data_out;    


    tbec_memory dut (
        .clk(clk),
        .we(mock_we),
        .addr(mock_addr),
        .data_in(mock_data_in),
        .data_out(dut_data_out)
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
        mock_we = 0;
        mock_addr = 8'h00;
        mock_data_in = 32'h00000000;

        // Wait for the clock to stabilize
        #10;

        // Write to memory
        mock_we = 1;
        mock_addr = 8'h01;
        mock_data_in = 32'hAABBCCDD;
        #10;

        // Write to memory
        mock_we = 1;
        mock_addr = 8'h02;
        mock_data_in = 32'hBBCCDDEE;
        #10;

        // Write to memory
        mock_we = 1;
        mock_addr = 8'h07;
        mock_data_in = 32'hFFAABBCC;
        #10;

        // Read from memory
        mock_we = 0;
        mock_addr = 8'h01;
        #10;

        // Check output
        if (dut_data_out !== 32'hAABBCCDD) begin
            $display("Test failed: Expected 0xAABBCCDD, got %h", dut_data_out);
        end else begin
            $display("Test passed: Memory read correct value %h", dut_data_out);
        end

        // Finish simulation
        $finish;
    end



endmodule