class slave_monitor;    

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual valid_credit_intf    intf;
    mailbox#(valid_credit_slice) inf2mnt;
    mailbox#(bit)                mbx;    
    
    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        intf    = cfg.slave_intf;
        inf2mnt = cfg.slave_inf2mnt;
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        forever begin
            wait(intf.rst_n);
            fork
                monitor();
            join_none
            wait(!intf.rst_n);
            disable fork;
        end
    endtask;

    virtual task monitor();
        valid_credit_slice slice;
        slice = new();
        forever begin
            @(posedge intf.clk)
            slice.valid  = intf.valid;
            slice.data   = intf.data;
            slice.credit = intf.credit;
            send_work(intf.valid && !intf.credit);
            inf2mnt.put(slice);
        end
    endtask

    virtual task send_work(input bit token);
        mbx.put(token);
    endtask

endclass
