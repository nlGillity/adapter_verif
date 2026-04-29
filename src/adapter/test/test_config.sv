class test_config;

    //=============================================================================
    // Info
    //=============================================================================

    string name        = "Test";
    string description = "Scenario with default configs";

    //=============================================================================
    // Required external connection
    //=============================================================================

    virtual valid_ready_intf     master_intf;
    virtual valid_credit_intf    slave_intf;

    // Test enviroment implementation specific:
    mailbox#(valid_ready_slice)  master_inf2mnt;
    mailbox#(packet)             master_gen2drv;
    mailbox#(valid_credit_slice) slave_inf2mnt;
    mailbox#(valid_credit_slice) rfm2mnt;

    //=============================================================================
    // Defaults
    //=============================================================================    

    int credit_num      = 2;      // number of credits in adapter
    int packet_num      = 300;    // number of requests to DUT
    int timeout         = 10000;
    
    //=============================================================================
    // Randomized
    //=============================================================================

    rand int master_driver_min_delay;
    rand int master_driver_max_delay;

    constraint master_driver_delay_c {
        master_driver_max_delay >= master_driver_min_delay;
    };

    rand int slave_driver_min_delay;
    rand int slave_driver_max_delay;

    constraint slave_driver_delay_c {
        slave_driver_max_delay >= slave_driver_min_delay;
    };

    //=============================================================================
    // Functions
    //=============================================================================

    function void print_general();
        $display("Name: %s", name);
        $display("Desc: %s", description);
    endfunction

    function void print_randomized();
        $display("Tests's enviroment configs:");
        $display("\tpacket_num              = %0d", packet_num);
        $display("\ttimeout                 = %0d", timeout);

        $display("\nMaster's driver configs:");
        $display("\tmaster_driver_min_delay = %0d", master_driver_min_delay);
        $display("\tmaster_driver_max_delay = %0d", master_driver_max_delay);

        $display("\nSlave's driver configs:");
        $display("\tslave_driver_min_delay  = %0d", slave_driver_min_delay);
        $display("\tslave_driver_max_delay  = %0d", slave_driver_max_delay);
    endfunction

endclass
