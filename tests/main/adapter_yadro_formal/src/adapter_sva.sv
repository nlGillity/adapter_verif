// данный файл простым образом include-ится в код модуля
// был вынесен, чтобы воссоздать условия "черного ящика",
// когда верификация не видит RTL, а видит только спецификацию!
//
// спецификация лежит в doc/adapter.md

always_ff @(posedge clk) begin
    if (valid_o)
        h0: assert (valid_i);

    if (valid_o)
        h1: assert (data_o == data_i);

    if (valid_i & ready_o)
        h2: assert (valid_o);

    if (valid_i & credit_i)
        h3: assert (valid_o);

    if ($past(credit_i & ~valid_o) & valid_i)
        h4: assert (valid_o);

    if ($past(~credit_i, 2) & $past(~credit_i) & ~credit_i &
        $past(valid_i, 2) & $past(valid_i))
        h5: assert (~valid_o);
end
