//-------------------------------------------------------------
// File : demux.sv
// Project : Parameterized AXI4 Crossbar
//
// Parameterized One-Hot Demultiplexer
//
// Features:
// • Synthesizable
// • Parameterized width
// • Parameterized outputs
// • One-hot select
//-------------------------------------------------------------

module demux #(

    parameter int WIDTH   = 32,
    parameter int OUTPUTS = 4

)(

    input  logic [WIDTH-1:0]              data_i,
    input  logic [OUTPUTS-1:0]            sel_i,

    output logic [OUTPUTS-1:0][WIDTH-1:0] data_o

);

    integer i;

    always_comb begin

        //-----------------------------------------------------
        // Default
        //-----------------------------------------------------

        data_o = '{default:'0};

        //-----------------------------------------------------
        // Route to selected output
        //-----------------------------------------------------

        for(i = 0; i < OUTPUTS; i++) begin

            if(sel_i[i])
                data_o[i] = data_i;

        end

    end

endmodule