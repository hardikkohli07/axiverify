//-------------------------------------------------------------
// File : arbiter_rr.sv
// Project : Parameterized AXI4 Crossbar
//
// Parameterized Round Robin Arbiter
//
// Features:
// • Fair arbitration
// • Starvation free
// • Rotating priority
// • One-hot grant
// • Synthesizable
//-------------------------------------------------------------

module arbiter_rr #(

    parameter int NUM_REQ = 4

)(

    input  logic clk,
    input  logic rst_n,

    // Request vector
    input  logic [NUM_REQ-1:0] request,

    // Grant acknowledge
    input  logic grant_accept,

    // One-hot grant
    output logic [NUM_REQ-1:0] grant,

    // Granted requester index
    output logic [$clog2(NUM_REQ)-1:0] grant_idx,

    // Indicates at least one requester
    output logic grant_valid

);

    //---------------------------------------------------------
    // Pointer
    //---------------------------------------------------------

    logic [$clog2(NUM_REQ)-1:0] rr_pointer;

    logic [$clog2(NUM_REQ)-1:0] next_pointer;

    //---------------------------------------------------------
    // Combinational Arbitration
    //---------------------------------------------------------

    integer i;

    always_comb begin

        grant       = '0;
        grant_valid = 1'b0;
        grant_idx   = '0;
        next_pointer = rr_pointer;

        //-----------------------------------------------------
        // Search beginning at RR pointer
        //-----------------------------------------------------

        for (i = 0; i < NUM_REQ; i++) begin

            int idx;

            idx = (rr_pointer + i) % NUM_REQ;

            if (!grant_valid && request[idx]) begin

                grant[idx]   = 1'b1;
                grant_valid  = 1'b1;
                grant_idx    = idx;

                next_pointer = idx + 1;

            end

        end

    end

    //---------------------------------------------------------
    // Update Pointer
    //---------------------------------------------------------

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)
            rr_pointer <= '0;

        else if (grant_valid && grant_accept)
            rr_pointer <= next_pointer;

    end

endmodule