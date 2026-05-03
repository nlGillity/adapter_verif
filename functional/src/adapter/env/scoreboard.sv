class scoreboard;

    int packet_num;
    int successes;
    int score; // number of errors

    //=============================================================================
    // Required external connection
    //=============================================================================

    mailbox#(valid_ready_slice)  master_mbx;
    mailbox#(valid_credit_slice) slave_mbx;
    mailbox#(valid_credit_slice) rfm_mbx;

    //=============================================================================
    // Functions
    //=============================================================================

    virtual function void configure(test_config cfg);
        packet_num = cfg.packet_num;
        master_mbx = cfg.master_inf2mnt;
        slave_mbx  = cfg.slave_inf2mnt;
        rfm_mbx    = cfg.rfm2mnt;
    endfunction

    //-----------------------------------------------------------------------------

    virtual function void check (
        valid_ready_slice  in_pkt, 
        valid_credit_slice out_pkt,
        valid_credit_slice rfm_pkt
    );
        int error = 0;

        assert ((out_pkt.valid == rfm_pkt.valid) && (out_pkt.data == rfm_pkt.data)) else begin
            $display(
                "%0d Difference #%0d \n expected valid = %b data = %b \n real     valid = %b data = %b", 
                $time(), score + 1, rfm_pkt.valid, rfm_pkt.valid,
                out_pkt.valid, out_pkt.data
            );
            error = 1;
        end

        score += error;
        successes += error == 0 ? 1 : 0;
    endfunction

    function bit is_passed();
        return score == 0 && successes > 0;  
    endfunction

    //=============================================================================
    // Tasks
    //=============================================================================

    virtual task run();
        valid_ready_slice  in_pkt;
        valid_credit_slice out_pkt;
        valid_credit_slice rfm_pkt;

        successes = 0;

        repeat (packet_num) begin
            master_mbx.get(in_pkt);
            do begin
                slave_mbx .get(out_pkt);
                rfm_mbx   .get(rfm_pkt);
                check(in_pkt, out_pkt, rfm_pkt);
            end while(!out_pkt.valid);
        end
    endtask

endclass
