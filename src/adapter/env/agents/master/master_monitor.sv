class master_monitor;

    //=============================================================================
    // Required external connection
    //=============================================================================
    
    virtual valid_ready_intf    intf;
    mailbox#(valid_ready_slice) inf2mnt;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        intf    = cfg.master_intf;
        inf2mnt = cfg.master_inf2mnt;
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
        valid_ready_slice slice;
        slice = new();
        forever begin
            @(posedge intf.clk);
            slice.ready = intf.ready; 
            slice.data  = intf.data;
            slice.valid = intf.valid;
            inf2mnt.put(slice);
        end
    endtask

endclass
