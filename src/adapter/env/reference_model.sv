class reference_model;

    localparam int MAX_CREDITS = 2;

    bit [1:0] credit_storage;
    valid_credit_slice out;

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual valid_ready_intf  in_intf;
    virtual valid_credit_intf out_intf;

    mailbox#(valid_credit_slice) rfm2mnt;

    //=============================================================================
    // Functions
    //=============================================================================

    function new();
        out = new();
    endfunction

    function void configure(test_config cfg);
        in_intf  = cfg.master_intf;
        out_intf = cfg.slave_intf;
        rfm2mnt  = cfg.rfm2mnt;
    endfunction

    // Reference Model Logic
    //-----------------------------------------------------------------------------

    // Forming slice of the reference model output
    virtual function void calc_out();
        valid_credit_slice slcie = new();
        out.valid  = in_intf.valid && (credit_storage > 0 || out_intf.credit);
        out.data   = in_intf.data;
        out.credit = out_intf.credit;
    endfunction

    // Update intertial credit storage
    virtual function void upd_storage();
        bit inc = out_intf.credit && (int'(credit_storage) < MAX_CREDITS);
        bit dec = in_intf.valid   && (credit_storage >           0);

        /* Implementation in DUT (with this all tests will pass)
            bit inc = out_intf.credit;
            bit dec = in_intf.valid && (credit_storage > 0);
        */

        credit_storage += inc - dec;
    endfunction

    // Reset reference model
    virtual function void reset();
        credit_storage = 2'b10;
        out.valid  = 0;
        out.data   = 0;
        out.credit = 0;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            reset();
            wait(in_intf.rst_n);
            fork
                forever begin
                    @(posedge in_intf.clk);
                    calc_out   ();
                    upd_storage();
                    rfm2mnt.put(out);
                end
            join_none
            wait(!in_intf.rst_n);
            disable fork;
        end
    endtask

endclass
