//-------------------------------------------------------------
// File : skid_buffer.sv
// Project : Parameterized AXI4 Crossbar
//
// Single-entry AXI Skid Buffer
//
// Features
// • Fully synthesizable
// • Parameterized width
// • Zero latency when downstream is ready
// • One-cycle buffering during backpressure
// • No combinational READY path
//-------------------------------------------------------------

module skid_buffer #(

    parameter int WIDTH = 32

)(

    input  logic             clk,
    input  logic             rst_n,

    // Upstream Interface
    input  logic             s_valid,
    output logic             s_ready,
    input  logic [WIDTH-1:0] s_data,

    // Downstream Interface
    output logic             m_valid,
    input  logic             m_ready,
    output logic [WIDTH-1:0] m_data

);

    //---------------------------------------------------------
    // Internal Storage
    //---------------------------------------------------------

    logic             buffer_valid;
    logic [WIDTH-1:0] buffer_data;

    //---------------------------------------------------------
    // Upstream Ready
    //---------------------------------------------------------

    assign s_ready = !buffer_valid;

    //---------------------------------------------------------
    // Downstream Signals
    //---------------------------------------------------------

    assign m_valid = buffer_valid;
    assign m_data  = buffer_data;

    //---------------------------------------------------------
    // Buffer Logic
    //---------------------------------------------------------

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            buffer_valid <= 1'b0;
            buffer_data  <= '0;

        end

        else begin

            //-------------------------------------------------
            // Capture incoming transaction
            //-------------------------------------------------

            if (s_valid && s_ready) begin

                buffer_data  <= s_data;
                buffer_valid <= 1'b1;

            end

            //-------------------------------------------------
            // Transaction accepted downstream
            //-------------------------------------------------

            if (m_valid && m_ready) begin

                buffer_valid <= 1'b0;

            end

        end

    end

endmodule