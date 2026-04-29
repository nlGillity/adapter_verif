interface valid_ready_intf (
    input logic clk,
    input logic rst_n
);
    
    //===========================================================================
    // Ports
    //===========================================================================

    /* verilator lint_off UNDRIVEN */
    logic valid;
    logic ready;
    logic data; 
    /* verilator lint_on UNDRIVEN */

    //===========================================================================
    // SVA
    //===========================================================================

    valid_stable_a: assert property (
        @(posedge clk) disable iff (~rst_n)
        valid && !ready |=> valid
    ) else $error(
        $time(), 
        " The valid signal have changed after being set without a handshake."
    );

    data_stable_a: assert property (
        @(posedge clk) disable iff (~rst_n)
        valid && !ready |=> $stable(data)
    ) else $error(
        $time(), 
        " The data have changed after valid being set without a handshake."
    );

endinterface
