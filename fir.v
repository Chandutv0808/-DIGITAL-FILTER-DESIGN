module fir_filter (
    input clk,           // Clock signal
    input rst_n,         // Active low reset
    input signed [15:0] x_in,  // Input data (16-bit signed)
    output reg signed [15:0] y_out // Filtered output data (16-bit signed)
);

    // Define the filter coefficients (example with 4 taps)
    reg signed [15:0] coeffs [0:3]; // 4 taps
    reg signed [15:0] delay_line [0:3]; // Delay line to store previous inputs
    
    integer i;

    // Initializing filter coefficients
    initial begin
        coeffs[0] = 16'h0004;  // Coefficients for FIR filter
        coeffs[1] = 16'h0008;
        coeffs[2] = 16'h0008;
        coeffs[3] = 16'h0004;
    end

    // Process input on every clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset delay line and output
            for (i = 0; i < 4; i = i + 1) begin
                delay_line[i] <= 16'h0000;
            end
            y_out <= 16'h0000;
        end else begin
            // Shift the delay line
            for (i = 3; i > 0; i = i - 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            // Load new input into delay line
            delay_line[0] <= x_in;

            // FIR filter computation
            y_out <= (delay_line[0] * coeffs[0]) + 
                     (delay_line[1] * coeffs[1]) + 
                     (delay_line[2] * coeffs[2]) + 
                     (delay_line[3] * coeffs[3]);
        end
    end
endmodule
