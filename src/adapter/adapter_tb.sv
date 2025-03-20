`timescale 1ns/1ps

module adapter_tb;

parameter CP = 10 ;
parameter MSG1 = 3'b011;
parameter MSG_LEN = $size(MSG1);

logic [MSG_LEN-1:0] tx_msg = MSG1;
logic [MSG_LEN-1:0] rx_msg = 'b0;


logic clk;
logic rst_n; 
logic valid_i = 1;
logic data_i = 0;
logic ready_o;
logic valid_o;
logic data_o;
logic credit_i = 0;

initial begin
    $display("%d %d %d",data_o,valid_o,ready_o);
end

initial begin
    clk = 0; 
    forever begin
        #(CP/2) clk = ~clk;
    end
end

initial begin
    rst_n = 1;
    #40 rst_n = 0;
    #40 rst_n = 1;

    #40 credit_i = 1;
    $display("credit_send");
    #10 credit_i = 0;


    #50 compare_rx_tx();
    $finish();

end

task automatic compare_rx_tx();
    logic[MSG_LEN-1:0] rez = rx_msg ^ MSG1;
    logic rez1 = (|rez);
    $display("%b, %b, %d",rx_msg,tx_msg,rez); 
    if (rez1 == 0)
        $display("PASSED");
    else
        $display("FAILED");
endtask 

always_ff @(posedge clk or negedge rst_n) begin : tx
    if(~rst_n)
        tx_msg <= MSG1;
    else if (valid_i & ready_o) begin
        tx_msg <= {tx_msg[0],tx_msg[MSG_LEN-1:1]};
        $display("tx: %g %b, %b, %b",$time,data_i, valid_i,ready_o);
    end
end

assign data_i = tx_msg[0];

    
always_ff @( posedge clk or negedge rst_n ) begin : rx
    if (~rst_n)
        credit_i <= 0;
    else if (valid_o) begin
        rx_msg <= {data_o,rx_msg[MSG_LEN-1:1]};
        $display("rx: %g %b, %b",$time,data_o, valid_o);
    end
end


adapter dut(
    .clk(clk),
    .rst_n(rst_n),

    .valid_i(valid_i),
    .data_i(data_i),
    .ready_o(ready_o),

    .valid_o(valid_o),
    .data_o(data_o),
    .credit_i(credit_i)
);


endmodule
