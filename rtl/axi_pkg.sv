//-------------------------------------------------------------
// File : axi_pkg.sv
// Project : Parameterized AXI4 Crossbar
//
// Shared package containing AXI definitions, parameters,
// enumerations, helper functions and transaction structures.
//
// IEEE 1800-2017 SystemVerilog
//-------------------------------------------------------------

package axi_pkg;

    //---------------------------------------------------------
    // Global Parameters
    //---------------------------------------------------------

    parameter int ADDR_WIDTH = 32;
    parameter int DATA_WIDTH = 32;
    parameter int ID_WIDTH   = 4;

    parameter int USER_WIDTH = 1;

    parameter int STRB_WIDTH = DATA_WIDTH/8;

    parameter int NUM_MASTERS = 4;
    parameter int NUM_SLAVES  = 4;

    //---------------------------------------------------------
    // AXI Burst Types
    //---------------------------------------------------------

    typedef enum logic [1:0]
    {
        AXI_BURST_FIXED = 2'b00,
        AXI_BURST_INCR  = 2'b01,
        AXI_BURST_WRAP  = 2'b10
    } axi_burst_t;

    //---------------------------------------------------------
    // AXI Response Types
    //---------------------------------------------------------

    typedef enum logic [1:0]
    {
        AXI_RESP_OKAY   = 2'b00,
        AXI_RESP_EXOKAY = 2'b01,
        AXI_RESP_SLVERR = 2'b10,
        AXI_RESP_DECERR = 2'b11
    } axi_resp_t;

    //---------------------------------------------------------
    // AXI Lock Type
    //---------------------------------------------------------

    typedef enum logic
    {
        AXI_NORMAL_ACCESS = 1'b0,
        AXI_EXCLUSIVE     = 1'b1
    } axi_lock_t;

    //---------------------------------------------------------
    // AXI Cache
    //---------------------------------------------------------

    typedef logic [3:0] axi_cache_t;

    //---------------------------------------------------------
    // AXI Protection
    //---------------------------------------------------------

    typedef logic [2:0] axi_prot_t;

    //---------------------------------------------------------
    // AXI QoS
    //---------------------------------------------------------

    typedef logic [3:0] axi_qos_t;

    //---------------------------------------------------------
    // AXI Region
    //---------------------------------------------------------

    typedef logic [3:0] axi_region_t;

    //---------------------------------------------------------
    // Write Address Channel
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [ID_WIDTH-1:0]       id;
        logic [ADDR_WIDTH-1:0]     addr;
        logic [7:0]                len;
        logic [2:0]                size;
        axi_burst_t                burst;
        axi_lock_t                 lock;
        axi_cache_t                cache;
        axi_prot_t                 prot;
        axi_qos_t                  qos;
        axi_region_t               region;
        logic [USER_WIDTH-1:0]     user;

    } axi_aw_chan_t;

    //---------------------------------------------------------
    // Write Data Channel
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [DATA_WIDTH-1:0] data;
        logic [STRB_WIDTH-1:0] strb;
        logic                  last;
        logic [USER_WIDTH-1:0] user;

    } axi_w_chan_t;

    //---------------------------------------------------------
    // Write Response Channel
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [ID_WIDTH-1:0] id;
        axi_resp_t           resp;
        logic [USER_WIDTH-1:0] user;

    } axi_b_chan_t;

    //---------------------------------------------------------
    // Read Address Channel
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [ID_WIDTH-1:0] id;
        logic [ADDR_WIDTH-1:0] addr;
        logic [7:0] len;
        logic [2:0] size;
        axi_burst_t burst;
        axi_lock_t  lock;
        axi_cache_t cache;
        axi_prot_t  prot;
        axi_qos_t   qos;
        axi_region_t region;
        logic [USER_WIDTH-1:0] user;

    } axi_ar_chan_t;

    //---------------------------------------------------------
    // Read Data Channel
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [ID_WIDTH-1:0] id;
        logic [DATA_WIDTH-1:0] data;
        axi_resp_t            resp;
        logic                 last;
        logic [USER_WIDTH-1:0] user;

    } axi_r_chan_t;

    //---------------------------------------------------------
    // Outstanding Transaction Entry
    //---------------------------------------------------------

    typedef struct packed
    {
        logic [ID_WIDTH-1:0] id;
        logic [$clog2(NUM_MASTERS)-1:0] master;
        logic [$clog2(NUM_SLAVES)-1:0] slave;
    } outstanding_entry_t;

    //---------------------------------------------------------
    // Helper Function
    // Calculate Bytes per Beat
    //---------------------------------------------------------

    function automatic int bytes_per_beat
    (
        input logic [2:0] size
    );

        return (1 << size);

    endfunction

    //---------------------------------------------------------
    // Helper Function
    // Burst Length
    //---------------------------------------------------------

    function automatic int burst_length
    (
        input logic [7:0] len
    );

        return (len + 1);

    endfunction

    //---------------------------------------------------------
    // Address Alignment
    //---------------------------------------------------------

    function automatic logic [ADDR_WIDTH-1:0]
    align_address
    (
        input logic [ADDR_WIDTH-1:0] addr,
        input logic [2:0] size
    );

        logic [ADDR_WIDTH-1:0] mask;

        mask = (1 << size) - 1;

        return addr & ~mask;

    endfunction

endpackage