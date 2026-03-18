module sign_mag_adder_tb;

    parameter SIZE = 8;

    logic [SIZE-1:0] a, b;
    logic [SIZE-1:0] s;
    logic overflow;

    // подключаем DUT (device under test)
    sign_mag_adder #(.SIZE(SIZE)) dut (
        .a(a),
        .b(b),
        .s(s),
        .overflow(overflow)
    );

    // функция для удобства создания числа (знак + модуль)
    function automatic [SIZE-1:0] sm(input logic sign, input logic [SIZE-2:0] mag);
        return {sign, mag};
    endfunction

    task check(
        input [SIZE-1:0] exp_s,
        input exp_overflow
    );
        if (s !== exp_s || overflow !== exp_overflow) begin
            $display("ERROR: a=%b b=%b -> s=%b (exp %b), ovf=%b (exp %b)",
                     a, b, s, exp_s, overflow, exp_overflow);
        end else begin
            $display("OK: a=%b b=%b -> s=%b ovf=%b",
                     a, b, s, overflow);
        end
    endtask

    initial begin
        // 1. одинаковые знаки (плюс)
        a = sm(0, 5); b = sm(0, 3); #1;
        check(sm(0, 8), 0);

        // 2. одинаковые знаки (минус)
        a = sm(1, 4); b = sm(1, 2); #1;
        check(sm(1, 6), 0);

        // 3. разные знаки (a > b)
        a = sm(0, 7); b = sm(1, 3); #1;
        check(sm(0, 4), 0);

        // 4. разные знаки (b > a)
        a = sm(1, 2); b = sm(0, 5); #1;
        check(sm(0, 3), 0);

        // 5. результат = 0 → нормализация
        a = sm(0, 5); b = sm(1, 5); #1;
        check(sm(0, 0), 0);

        // 6. переполнение
        a = sm(0, 127); b = sm(0, 1); #1;
        check(sm(0, 0), 1); // зависит от реализации

        $finish;
    end

endmodule
