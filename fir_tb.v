module tb_fir_filter;

    reg clk;
    reg rst_n;
    reg signed [15:0] x_in;
    wire signed [15:0] y_out;

    // Instantiate the FIR filter
    fir_filter uut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns period
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        x_in = 16'h0000;

        // Apply reset
        #10 rst_n = 1;

        // Apply input stimulus
        #10 x_in = 16'h0001;  // Sample input 1
        #10 x_in = 16'h0002;  // Sample input 2
        #10 x_in = 16'h0003;  // Sample input 3
        #10 x_in = 16'h0004;  // Sample input 4
        #10 x_in = 16'h0005;  // Sample input 5

        // Finish simulation
        #50 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t, Input: %h, Output: %h", $time, x_in, y_out);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

endmodule