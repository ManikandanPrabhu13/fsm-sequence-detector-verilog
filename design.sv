// Moore FSM — 1011 Sequence Detector
// Detects pattern: 1011 in a serial input stream
// Author: Manikandan Prabhu B

module seq_detector_1011 (
    input  clk,        // Clock
    input  rst,        // Active-high synchronous reset
    input  in,         // Serial input bit
    output reg detected // HIGH when 1011 detected
);

    // State encoding
    parameter S0 = 3'b000; // Initial / Reset state
    parameter S1 = 3'b001; // Received: 1
    parameter S2 = 3'b010; // Received: 10
    parameter S3 = 3'b011; // Received: 101
    parameter S4 = 3'b100; // Received: 1011 — DETECTED

    reg [2:0] current_state, next_state;

    // State register — sequential block
    always @(posedge clk) begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic — combinational block
    always @(*) begin
        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S1 : S2;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S2;
            S4: next_state = in ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic — Moore (output based on state only)
    always @(*) begin
        detected = (current_state == S4) ? 1'b1 : 1'b0;
    end

endmodule
