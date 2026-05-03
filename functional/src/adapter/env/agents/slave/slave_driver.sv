class slave_driver;

    int min_delay;
    int max_delay;

    //=============================================================================
    // Required external connection
    //============================================================================= 

    mailbox#(bit) mbx;
    virtual valid_credit_intf intf;

    //=============================================================================
    // Functions
    //============================================================================= 
    
    virtual function void configure(test_config cfg);
        intf      = cfg.slave_intf;
        min_delay = cfg.slave_driver_min_delay;
        max_delay = cfg.slave_driver_max_delay;
    endfunction

    //=============================================================================
    // Tasks
    //============================================================================= 

    virtual task run();
        forever begin
            wait(intf.rst_n);
            fork
                forever drive();
            join_none
            wait(!intf.rst_n);
            disable fork;
            reset();
        end
    endtask

    virtual task drive();
        bit credit = 0;
        mbx.get(credit);

        intf.credit <= credit;
        @(posedge intf.clk);
        intf.credit <= 1'b0;
    endtask

    virtual task reset();
        intf.credit <= 1'b0;
    endtask

endclass
