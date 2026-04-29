interface valid_credit_intf #(
    parameter int MAX_CREDITS = 2
)(
    input logic clk,
    input logic rst_n
);

    //===========================================================================
    // Ports
    //===========================================================================

    /* verilator lint_off UNDRIVEN */
    logic valid; 
    logic credit;
    logic data;  
    /* verilator lint_on UNDRIVEN */
    
endinterface
