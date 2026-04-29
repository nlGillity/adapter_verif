`timescale 1ns/1ps

module adapter_tb;

    logic clk;
    logic rst_n; 

    import test_pkg::*;

    //=============================================================================
    // Parameters
    //=============================================================================

    localparam int TEST_NUM       = 5;
    localparam int CLOCK_PERIOD   = 10;
    localparam int RESET_DURATION = 20;

    //=============================================================================
    // Interfaces
    //=============================================================================

    valid_ready_intf  vrf (clk, rst_n);
    valid_credit_intf vcf (clk, rst_n);

    //=============================================================================
    // DUT
    //=============================================================================

    adapter DUT (
        .clk      ( clk        ),
        .rst_n    ( rst_n      ),

        .valid_i  ( vrf.valid  ),
        .data_i   ( vrf.data   ),
        .ready_o  ( vrf.ready  ),

        .valid_o  ( vcf.valid  ),
        .data_o   ( vcf.data   ),
        .credit_i ( vcf.credit )
    );

    //=============================================================================
    // General Tasks
    //=============================================================================

    // Clocking
    initial begin
        clk = 0; 
        forever begin
            #(CLOCK_PERIOD / 2) clk = ~clk;
        end
    end

    // Reseting
    task reset();
        rst_n = 1'b0;
        vrf.valid  = 1'b0;
        vrf.data   = 1'b0;
        vcf.credit = 1'b0;
        repeat (RESET_DURATION) @(posedge clk);
        rst_n = 1'b1;
    endtask

    //=============================================================================
    // Test Scenarios
    //=============================================================================

    int  passed_num;
    test test_scenarios [$];

    test_normal      scenario_normal      = new(vrf, vcf);
    test_exhaustion  scenario_exhaustion  = new(vrf, vcf);
    test_overwhelmed scenario_overwhelmed = new(vrf, vcf);
    test_overflow    scenario_overflow    = new(vrf, vcf);
    test_intensive   scenario_intensive   = new(vrf, vcf);

    //-----------------------------------------------------------------------------

    function void tests_randomize(output test tests []);
        tests = {
            scenario_normal,
            scenario_exhaustion,
            scenario_overwhelmed,
            scenario_overflow,
            scenario_intensive
        };
        test_scenarios.shuffle();
    endfunction

    task tests_run(test tests []);
        foreach (tests[i]) begin
            reset();
            repeat (2) @(posedge clk);
            tests[i].run();
            passed_num += int'(tests[i].passed);
        end
    endtask

    function void print_result();
        $display("\n=====================================================");
        if (passed_num == TEST_NUM) $display("All tests PASSED");
        else                        $display("Some tests FAILED");
        $display("=====================================================");
    endfunction

    //=============================================================================
    // Running Tests
    //=============================================================================

    initial begin
        tests_randomize(test_scenarios);
        tests_run(test_scenarios);
        print_result();
        $finish();
    end

    //=============================================================================
    // SVA
    //============================================================================= 

    /* verilator lint_off SYNCASYNCNET */
    property handshake_p;
        @(posedge clk) disable iff (!rst_n)
        vcf.valid |-> vrf.valid && vrf.ready
    endproperty
    /* verilator lint_on SYNCASYNCNET */

    handshake_a: assert property (handshake_p) else 
    $error(
        "%0d [vcf.valid = 1] |-> real {valid_i, ready_o} = {%b, %b}; expected {1 , 0}", 
        $time, vrf.valid, vrf.ready
    );

endmodule
