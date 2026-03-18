module sign_mag_adder #(
    parameter SIZE = 8
)(
    input  logic [SIZE-1:0] a,
    input  logic [SIZE-1:0] b,
    output logic [SIZE-1:0] s,
    output logic overflow
);

    // Старший бит — знак, остальные — абсолютное значение
    logic sign_a = a[SIZE-1];
    logic sign_b = b[SIZE-1];

    logic [SIZE-2:0] mag_a = a[SIZE-2:0];
    logic [SIZE-2:0] mag_b = b[SIZE-2:0];

    // Внутренние переменные результата
    logic [SIZE-2:0] mag_res;
    logic sign_res;
    logic carry_out;

    always_comb begin
        // значения по умолчанию (чтобы не было latch)
        mag_res   = '0;
        sign_res  = 1'b0;
        overflow  = 1'b0;

        // одинаковые знаки → обычное сложение модулей
        if (sign_a == sign_b) begin
            {carry_out, mag_res} = mag_a + mag_b;
            sign_res = sign_a;
            overflow = carry_out;
        end
        // разные знаки → фактически вычитание
        else begin
            if (mag_a >= mag_b) begin
                mag_res  = mag_a - mag_b;
                sign_res = sign_a;
            end else begin
                mag_res  = mag_b - mag_a;
                sign_res = sign_b;
            end
        end

        // если результат равен нулю — делаем +0
        s = (mag_res == 0) ? '0 : {sign_res, mag_res};
    end

endmodule
