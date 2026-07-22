//-------------------------------------------------------------
// File : axi_if.sv
// Project : Parameterized AXI4 Crossbar
//
// Parameterized AXI4 Interface
//
// IEEE 1800-2017
//-------------------------------------------------------------

interface axi_if #(

    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH   = 4,
    parameter USER_WIDTH = 1

)
(
    input logic ACLK,
    input logic ARESETn
);

    localparam STRB_WIDTH = DATA_WIDTH/8;

    //---------------------------------------------------------
    // Write Address Channel (AW)
    //---------------------------------------------------------

    logic [ID_WIDTH-1:0]     awid;
    logic [ADDR_WIDTH-1:0]   awaddr;
    logic [7:0]              awlen;
    logic [2:0]              awsize;
    logic [1:0]              awburst;
    logic                    awlock;
    logic [3:0]              awcache;
    logic [2:0]              awprot;
    logic [3:0]              awqos;
    logic [3:0]              awregion;
    logic [USER_WIDTH-1:0]   awuser;

    logic                    awvalid;
    logic                    awready;

    //---------------------------------------------------------
    // Write Data Channel (W)
    //---------------------------------------------------------

    logic [DATA_WIDTH-1:0]   wdata;
    logic [STRB_WIDTH-1:0]   wstrb;
    logic                    wlast;
    logic [USER_WIDTH-1:0]   wuser;

    logic                    wvalid;
    logic                    wready;

    //---------------------------------------------------------
    // Write Response Channel (B)
    //---------------------------------------------------------

    logic [ID_WIDTH-1:0]     bid;
    logic [1:0]              bresp;
    logic [USER_WIDTH-1:0]   buser;

    logic                    bvalid;
    logic                    bready;

    //---------------------------------------------------------
    // Read Address Channel (AR)
    //---------------------------------------------------------

    logic [ID_WIDTH-1:0]     arid;
    logic [ADDR_WIDTH-1:0]   araddr;
    logic [7:0]              arlen;
    logic [2:0]              arsize;
    logic [1:0]              arburst;
    logic                    arlock;
    logic [3:0]              arcache;
    logic [2:0]              arprot;
    logic [3:0]              arqos;
    logic [3:0]              arregion;
    logic [USER_WIDTH-1:0]   aruser;

    logic                    arvalid;
    logic                    arready;

    //---------------------------------------------------------
    // Read Data Channel (R)
    //---------------------------------------------------------

    logic [ID_WIDTH-1:0]     rid;
    logic [DATA_WIDTH-1:0]   rdata;
    logic [1:0]              rresp;
    logic                    rlast;
    logic [USER_WIDTH-1:0]   ruser;

    logic                    rvalid;
    logic                    rready;

    //---------------------------------------------------------
    // Master Clocking Block
    //---------------------------------------------------------

    clocking master_cb @(posedge ACLK);

        default input #1step output #1step;

        output awid;
        output awaddr;
        output awlen;
        output awsize;
        output awburst;
        output awlock;
        output awcache;
        output awprot;
        output awqos;
        output awregion;
        output awuser;
        output awvalid;
        input  awready;

        output wdata;
        output wstrb;
        output wlast;
        output wuser;
        output wvalid;
        input  wready;

        input  bid;
        input  bresp;
        input  buser;
        input  bvalid;
        output bready;

        output arid;
        output araddr;
        output arlen;
        output arsize;
        output arburst;
        output arlock;
        output arcache;
        output arprot;
        output arqos;
        output arregion;
        output aruser;
        output arvalid;
        input  arready;

        input  rid;
        input  rdata;
        input  rresp;
        input  rlast;
        input  ruser;
        input  rvalid;
        output rready;

    endclocking

    //---------------------------------------------------------
    // Slave Clocking Block
    //---------------------------------------------------------

    clocking slave_cb @(posedge ACLK);

        default input #1step output #1step;

        input awid;
        input awaddr;
        input awlen;
        input awsize;
        input awburst;
        input awlock;
        input awcache;
        input awprot;
        input awqos;
        input awregion;
        input awuser;
        input awvalid;
        output awready;

        input wdata;
        input wstrb;
        input wlast;
        input wuser;
        input wvalid;
        output wready;

        output bid;
        output bresp;
        output buser;
        output bvalid;
        input  bready;

        input arid;
        input araddr;
        input arlen;
        input arsize;
        input arburst;
        input arlock;
        input arcache;
        input arprot;
        input arqos;
        input arregion;
        input aruser;
        input arvalid;
        output arready;

        output rid;
        output rdata;
        output rresp;
        output rlast;
        output ruser;
        output rvalid;
        input  rready;

    endclocking

    //---------------------------------------------------------
    // Master Modport
    //---------------------------------------------------------

    modport master
    (
        clocking master_cb,
        input ACLK,
        input ARESETn
    );

    //---------------------------------------------------------
    // Slave Modport
    //---------------------------------------------------------

    modport slave
    (
        clocking slave_cb,
        input ACLK,
        input ARESETn
    );

    //---------------------------------------------------------
    // Monitor Modport
    //---------------------------------------------------------

    modport monitor
    (
        input ACLK,
        input ARESETn,

        input awid,
        input awaddr,
        input awlen,
        input awsize,
        input awburst,
        input awlock,
        input awcache,
        input awprot,
        input awqos,
        input awregion,
        input awuser,
        input awvalid,
        input awready,

        input wdata,
        input wstrb,
        input wlast,
        input wuser,
        input wvalid,
        input wready,

        input bid,
        input bresp,
        input buser,
        input bvalid,
        input bready,

        input arid,
        input araddr,
        input arlen,
        input arsize,
        input arburst,
        input arlock,
        input arcache,
        input arprot,
        input arqos,
        input arregion,
        input aruser,
        input arvalid,
        input arready,

        input rid,
        input rdata,
        input rresp,
        input rlast,
        input ruser,
        input rvalid,
        input rready
    );

endinterface