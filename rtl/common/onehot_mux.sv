//-------------------------------------------------------------
// File : mux.sv
//
// Parameterized One-Hot Multiplexer
//-------------------------------------------------------------

module mux #(

    parameter WIDTH = 32,
    parameter INPUTS = 4

)(

    input  logic [INPUTS-1:0][WIDTH-1:0] data_i,
    input  logic [INPUTS-1:0]            sel_i,

    output logic [WIDTH-1:0]            data_o

);

    integer i;

    always_comb begin

        data_o = '0;

        for(i=0;i<INPUTS;i++) begin

            if(sel_i[i])
                data_o = data_i[i];

        end

    end

endmodule