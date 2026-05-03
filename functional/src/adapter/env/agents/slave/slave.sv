class slave;

    int credit_num;
    int credit_storage;

    int min_delay;
    int max_delay;

    slave_driver  driver;
    slave_monitor monitor;

    virtual valid_credit_intf intf;

    mailbox#(bit) work_mbx;
    mailbox#(bit) result_mbx;

    //=============================================================================
    // Functions
    //=============================================================================

    function new();
        work_mbx = new();
        result_mbx = new();
        driver   = new();
        monitor  = new();
    endfunction

    virtual function void configure(test_config cfg);
        intf        = cfg.slave_intf;
        credit_num  = cfg.credit_num;
        min_delay   = cfg.slave_driver_min_delay;
        max_delay   = cfg.slave_driver_max_delay;
        driver .configure(cfg);
        monitor.configure(cfg);
        driver.mbx  = result_mbx;
        monitor.mbx = work_mbx;
    endfunction

    // Inertial credit storage logic
    //-----------------------------------------------------------------------------

    virtual function void add_credit(input bit token);
        credit_storage += int'(token && credit_storage < credit_num);
    endfunction

    virtual function void remove_credit(input bit token);
        credit_storage -= int'(token && credit_storage > 0);
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        credit_storage = 0;
        fork
            driver .run();
            monitor.run();
            forever apply_work();
            forever do_work();
            // forever begin
            //     @(posedge intf.clk);
            //     $display("%d", credit_storage);
            // end
        join
    endtask

    // Imitation of work
    //-----------------------------------------------------------------------------

    virtual task apply_work();
        bit work_token = 0;
        work_mbx.get(work_token);
        add_credit(work_token);
    endtask

    virtual task do_work();
        @(posedge intf.clk);
        while (credit_storage > 0) begin
            delay();
            return_credit(1'b1);
        end
    endtask

    virtual task return_credit(input bit token);
        remove_credit(token);
        result_mbx.put(token);
    endtask

    virtual task delay();
        int delay = $urandom_range(min_delay, max_delay);
        repeat (delay) @(posedge intf.clk);
    endtask
    

endclass
