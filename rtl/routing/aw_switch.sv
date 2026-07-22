//-------------------------------------------------------------
// File : aw_switch.sv
//
// AXI4 Write Address Switch
//
// Part 1
// Address Decode + Request Matrix Generation
//-------------------------------------------------------------

`include "axi_pkg.sv"

module aw_switch #

(

parameter NUM_MASTERS = 4,
parameter NUM_SLAVES  = 4,
parameter ADDR_WIDTH  = 32

)

(

input logic clk,
input logic rst_n,

// Master Interfaces

axi_if.master masters[NUM_MASTERS],

axi_if.slave  slaves [NUM_SLAVES]

);

import axi_pkg::*;

localparam MASTER_BITS = $clog2(NUM_MASTERS);
localparam SLAVE_BITS  = $clog2(NUM_SLAVES);

///////////////////////////////////////////////////////////////
// Decoder Outputs
///////////////////////////////////////////////////////////////

logic [SLAVE_BITS-1:0] decode_slave
            [NUM_MASTERS];

logic decode_valid
            [NUM_MASTERS];

logic decode_error
            [NUM_MASTERS];

///////////////////////////////////////////////////////////////
// Internal AW Bus
///////////////////////////////////////////////////////////////

axi_aw_chan_t master_aw [NUM_MASTERS];
axi_aw_chan_t slave_aw  [NUM_SLAVES];

generate

for(genvar m=0; m<NUM_MASTERS; m++) begin : PACK_MASTER

    always_comb begin

        master_aw[m].id      = masters[m].awid;
        master_aw[m].addr    = masters[m].awaddr;
        master_aw[m].len     = masters[m].awlen;
        master_aw[m].size    = masters[m].awsize;
        master_aw[m].burst   = axi_burst_t'(masters[m].awburst);
        master_aw[m].lock    = axi_lock_t'(masters[m].awlock);
        master_aw[m].cache   = masters[m].awcache;
        master_aw[m].prot    = masters[m].awprot;
        master_aw[m].qos     = masters[m].awqos;
        master_aw[m].region  = masters[m].awregion;
        master_aw[m].user    = masters[m].awuser;

    end

end

endgenerate

///////////////////////////////////////////////////////////////
// Request Matrix
//
// request_matrix[slave][master]
///////////////////////////////////////////////////////////////

logic [NUM_MASTERS-1:0]
      request_matrix
      [NUM_SLAVES];

genvar m;

generate

for(m=0;m<NUM_MASTERS;m++) begin : DECODER_GEN

    addr_decoder decoder(

        .addr
        (
            masters[m].awaddr
        ),

        .slave_select
        (
            decode_slave[m]
        ),

        .decode_valid
        (
            decode_valid[m]
        ),

        .decode_error
        (
            decode_error[m]
        )

    );

end

endgenerate


integer i,j;

always_comb begin

    //---------------------------------------------------------
    // Clear Matrix
    //---------------------------------------------------------

    for(i=0;i<NUM_SLAVES;i++)
        request_matrix[i]='0;

    //---------------------------------------------------------
    // Populate Matrix
    //---------------------------------------------------------

    for(i=0;i<NUM_MASTERS;i++) begin

        if(masters[i].awvalid &&
           decode_valid[i])

        begin

            request_matrix
            [

                decode_slave[i]

            ]

            [

                i

            ]

            =1'b1;

        end

    end

end

///////////////////////////////////////////////////////////////
// Arbitration Signals
///////////////////////////////////////////////////////////////

logic [NUM_MASTERS-1:0]
      grant_matrix
      [NUM_SLAVES];

logic
      grant_valid
      [NUM_SLAVES];

logic [MASTER_BITS-1:0]
      grant_index
      [NUM_SLAVES];

logic
      grant_accept
      [NUM_SLAVES];

///////////////////////////////////////////////////////////////
// Round Robin Arbitration
///////////////////////////////////////////////////////////////

genvar s;

generate

for(s=0; s<NUM_SLAVES; s++) begin : ARBITERS

    arbiter_rr #(

        .NUM_REQ(NUM_MASTERS)

    )

    u_rr_arbiter(

        .clk(clk),

        .rst_n(rst_n),

        .request
        (
            request_matrix[s]
        ),

        .grant_accept
        (
            grant_accept[s]
        ),

        .grant
        (
            grant_matrix[s]
        ),

        .grant_idx
        (
            grant_index[s]
        ),

        .grant_valid
        (
            grant_valid[s]
        )

    );

end

endgenerate

///////////////////////////////////////////////////////////////
// Temporary Grant Acceptance
///////////////////////////////////////////////////////////////

generate

for(s=0; s<NUM_SLAVES; s++) begin

    assign grant_accept[s] =
            slaves[s].awvalid &&
            slaves[s].awready;

end

endgenerate