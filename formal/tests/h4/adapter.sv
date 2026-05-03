module adapter(
    input   logic   clk,
    input   logic   rst_n,

    input   logic   valid_i,
    input   logic   data_i,
    output  logic   ready_o,

    output  logic   valid_o,
    output  logic   data_o,
    input   logic   credit_i
);

localparam CRDT_NUM = 2;
localparam CRDT_PTR = $clog2(CRDT_NUM + 1);

logic [CRDT_PTR - 1:0] cntr_ff;
logic [CRDT_PTR - 1:0] cntr_next;
logic                  cntr_inc;
logic                  cntr_dec;
logic                  cntr_empty;

assign cntr_inc  = credit_i & (cntr_ff == CRDT_NUM);
assign cntr_dec  = valid_i & ~cntr_empty;
assign cntr_next = CRDT_PTR'(cntr_ff + cntr_inc - cntr_dec);

always_ff @(posedge clk or negedge rst_n)
    if (~rst_n)
        cntr_ff <= CRDT_NUM;
    else
        cntr_ff <= cntr_next;

assign cntr_empty = ~(|cntr_ff);


assign ready_o   = ~cntr_empty | credit_i;
assign valid_o   = valid_i & ready_o;
assign data_o    = data_i;

// verification

always_comb assume (rst_n == ~$initstate);
initial assume (~valid_i);

always_comb begin
    if (cntr_ff == CRDT_NUM)
        assume (~credit_i);
end

`include "adapter_sva.sv"

endmodule