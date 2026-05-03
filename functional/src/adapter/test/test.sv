class test;

    bit              passed;
    rand test_config configs;
    env              env_obj;

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual valid_ready_intf     master_intf;
    virtual valid_credit_intf    slave_intf;

    mailbox#(packet)             master_gen2drv;        
    mailbox#(valid_ready_slice)  master_inf2mnt;
    mailbox#(valid_credit_slice) slave_inf2mnt;
    mailbox#(valid_credit_slice) rfm2mnt;
    
    //=============================================================================
    // Functions
    //============================================================================= 

    function new (
        virtual valid_ready_intf  mf,
        virtual valid_credit_intf sf
    );
        this.master_intf = mf;
        this.slave_intf  = sf;

        configs        = new();
        env_obj        = new();
        master_gen2drv = new();
        master_inf2mnt = new();
        slave_inf2mnt  = new();
        rfm2mnt        = new();

        configure();
    endfunction

    //------------------------------------------------------------------------------

    virtual function void configure();
        if ( config_gen() == 0 ) begin
            $error($time(), " Failed to generate test configs.");
            $finish();
        end else begin
            configs.master_intf    = master_intf;
            configs.slave_intf     = slave_intf;

            configs.master_gen2drv = master_gen2drv;
            configs.master_inf2mnt = master_inf2mnt;
            configs.slave_inf2mnt  = slave_inf2mnt;
            configs.rfm2mnt        = rfm2mnt;

            env_obj.configure(configs);
        end
    endfunction

    virtual function int config_gen();
        return configs.randomize();
    endfunction

    //------------------------------------------------------------------------------

    virtual function void completion_handle();
        passed = env_obj.scoreboard_obj.is_passed();
        if (passed) $display("PASSED");
        else        $display("FAILED");
    endfunction

    //------------------------------------------------------------------------------

    virtual function void print_info();
        $display("\n=====================================================");
        configs.print_general();
        $display("------------------ Configurations -------------------");
        configs.print_randomized();
    endfunction

    virtual function void print_sim();
        $display("-------------------- Simulation ---------------------");
        $display("Simulating...");
    endfunction

    virtual function void print_result();
        $display("---------------------- Result -----------------------");
    endfunction

    virtual function void print_end();
        $display("=====================================================");
    endfunction

    //=============================================================================
    // Tasks
    //============================================================================= 

    virtual task run();
        print_info();
        print_sim();

        passed = 0;
        fork
            env_obj.run();
            timeout();
        join_any
        disable fork;     
        completion_handle();

        print_end();   
    endtask

    virtual task timeout();
        repeat (configs.timeout) @(posedge master_intf.clk);
        $display("Timeout!");
    endtask

endclass
