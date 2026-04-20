// данный файл простым образом include-ится в код модуля
// был вынесен, чтобы воссоздать условия "черного ящика",
// когда верификация не видит RTL, а видит только спецификацию!
//
// спецификация лежит в doc/adapter.md

/* Notes:
    Помимо описания формальных выражений через immediate assertions
    я решил попробовать решить задачи ещё и через concurrent assertions
    (для удобства я расположил их ниже immediate-ов, хотя, стоило бы 
    их вынести из блока always).
*/

always_ff @(posedge clk) begin
    if (rst_n) begin

        // ====================================================================
        
        // Преобразователь не может произвольно установить valid_o, 
        // если нет valid_i.

        if (valid_o)
            h0: assert (valid_i);

        /*
            h0: assert property (
                @(posedge clk) disable iff (!rst_n)
                valid_o |-> valid_i
            );
        */

        // ====================================================================

        // Преобразователь сохраняет корректность данных при передаче, 
        // если установлен valid_o.

        if (valid_o)
            h1: assert (data_o == data_i);

        /*
            h1: assert property (
                @(posedge clk) disable iff (!rst_n)
                valid_o |-> data_o == data_i
            );
        */

        // ====================================================================

        // Если преобразователь установил ready_o, то при наличии valid_i 
        // передача данных гарантировано происходит.

        if (ready_o)
            if (valid_i)
                h2: assert (valid_o);

        /*
            h2: assert property (
                @(posedge clk) disable iff (!rst_n)
                ready_o && valid_i |-> valid_o
            );
        */

        // ====================================================================

        // Если преобразователь получает кредит, то при наличии valid_i 
        // он обязан им воспользовать для передачи данных.

        if (credit_i)
            if (valid_i)
                h3: assert (ready_o && valid_o);

        /*
            h3: assert property (
                @(posedge clk) disable iff (!rst_n)
                (credit_i && valid_i) |-> (ready_o && valid_o)
            );
        */

        // ====================================================================

    end
end