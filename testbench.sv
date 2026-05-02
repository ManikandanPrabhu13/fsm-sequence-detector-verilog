// Testbench — 1011 Sequence Detector
// Sends bit stream and checks detection
// Author: Manikandan Prabhu B

`timescale 1ns/1ps

module tb_seq_detector;

    reg clk, rst, in;
    wire detected;

    // Instantiate DUT
    seq_detector_1011 DUT (
        .clk(clk),
        .rst(rst),
        .in(in),
        .detected(detected)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("seq_detector.vcd");
        $dumpvars(0, tb_seq_detector);

        // Initialise
        clk = 0; rst = 1; in = 0;
        #10 rst = 0;

        $display("=== 1011 Sequence Detector Verification ===");
        $display("Time | in | detected | State");

        // --- Test 1: Send 1011 — should detect ---
        $display("-- Sending: 1 0 1 1 --");
        in = 1; #10;
        $display("%0t  |  %b |    %b     | S1 (got 1)", $time, in, detected);
        in = 0; #10;
        $display("%0t  |  %b |    %b     | S2 (got 10)", $time, in, detected);
        in = 1; #10;
        $display("%0t  |  %b |    %b     | S3 (got 101)", $time, in, detected);
        in = 1; #10;
        $display("%0t  |  %b |    %b     | S4 — DETECTED!", $time, in, detected);

        // --- Test 2: Send 1101 — should NOT detect ---
        $display("-- Sending: 1 1 0 1 (no detection expected) --");
        rst = 1; #10; rst = 0;
        in = 1; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        $display("%0t  |  %b |    %b     | No detection", $time, in, detected);

        // --- Test 3: Send 11011 — detects embedded 1011 ---
        $display("-- Sending: 1 1 0 1 1 (embedded 1011) --");
        rst = 1; #10; rst = 0;
        in = 1; #10;
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 1; #10;
        $display("%0t  |  %b |    %b     | Detected embedded 1011!", $time, in, detected);

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
