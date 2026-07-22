//-------------------------------------------------------------
// File : addr_decoder.sv
// Project : Parameterized AXI4 Crossbar
//
// Parameterized Address Decoder
//
// Features:
// • Configurable address regions
// • Supports arbitrary slave count
// • Decode error generation
// • Synthesizable
//-------------------------------------------------------------

module addr_decoder #(

    parameter int ADDR_WIDTH = 32,
    parameter int NUM_SLAVES = 4,

    // Slave Address Map
    parameter logic [ADDR_WIDTH-1:0] BASE_ADDR [NUM_SLAVES] = '{
        32'h0000_0000,
        32'h1000_0000,
        32'h2000_0000,
        32'h3000_0000
    },

    parameter logic [ADDR_WIDTH-1:0] ADDR_MASK [NUM_SLAVES] = '{
        32'hF000_0000,
        32'hF000_0000,
        32'hF000_0000,
        32'hF000_0000
    }

)(

    input  logic [ADDR_WIDTH-1:0] addr,

    output logic [$clog2(NUM_SLAVES)-1:0] slave_select,
    output logic                          decode_valid,
    output logic                          decode_error

);

    integer i;

    always_comb begin

        slave_select = '0;
        decode_valid = 1'b0;
        decode_error = 1'b1;

        //-----------------------------------------------------
        // Address decode
        //-----------------------------------------------------

        for (i = 0; i < NUM_SLAVES; i++) begin

            if ((addr & ADDR_MASK[i]) == BASE_ADDR[i]) begin

                slave_select = i;
                decode_valid = 1'b1;
                decode_error = 1'b0;

            end

        end

    end

endmodule