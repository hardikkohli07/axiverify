//-------------------------------------------------------------
// File : priority_encoder.sv
// Project : AXI4 Crossbar
//
// Parameterized Priority Encoder
//
// Features
// --------
// • Parameterized width
// • One-hot input
// • Binary output
// • Valid output
// • Synthesizable
//-------------------------------------------------------------

module priority_encoder #(

    parameter int WIDTH = 4

)(
    input  logic [WIDTH-1:0] onehot_i,

    output logic [$clog2(WIDTH)-1:0] index_o,

    output logic valid_o
);

    integer i;

    always_comb begin

        index_o = '0;
        valid_o = 1'b0;

        //-----------------------------------------------------
        // Convert One-Hot → Binary
        //-----------------------------------------------------

        for(i=0;i<WIDTH;i++) begin

            if(onehot_i[i]) begin
                index_o = i[$clog2(WIDTH)-1:0];
                valid_o = 1'b1;
            end

        end

    end

endmodule