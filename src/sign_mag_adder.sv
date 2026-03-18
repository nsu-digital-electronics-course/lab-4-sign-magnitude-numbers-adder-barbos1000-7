module sign_mag_adder #(
    parameter SIZE = 8
)(
    input  logic [SIZE-1:0] a,
    input  logic [SIZE-1:0] b,
    output logic [SIZE-1:0] s,
    output logic overflow
);

    // Выделяем знаки и модули для удобства
    logic sign_a, sign_b;
    logic [SIZE-2:0] mag_a, mag_b;
    
    assign sign_a = a[SIZE-1];
    assign sign_b = b[SIZE-1];
    assign mag_a  = a[SIZE-2:0];
    assign mag_b  = b[SIZE-2:0];

    // Промежуточные сигналы для результата
    logic [SIZE-2:0] res_mag;
    logic res_sign;
    logic carry;

    always_comb begin
        // Значения по умолчанию
        overflow = 1'b0;
        res_mag  = 0;
        res_sign = 1'b0;

        if (sign_a == sign_b) begin
            // Сложение чисел с одинаковыми знаками
            {carry, res_mag} = mag_a + mag_b;
            res_sign = sign_a;
            overflow = carry;
        end else begin
            // Сложение чисел с разными знаками (вычитание модулей)
            if (mag_a > mag_b) begin
                res_mag = mag_a - mag_b;
                res_sign = sign_a;
            end else if (mag_b > mag_a) begin
                res_mag = mag_b - mag_a;
                res_sign = sign_b;
            end else begin
                // Числа равны по модулю, знаки разные -> +0
                res_mag = 0;
                res_sign = 1'b0; 
            end
        end

        // Финальная нормализация нуля: если модуль 0, знак всегда 0
        if (res_mag == 0) begin
            s = {1'b0, {(SIZE-1){1'b0}}};
        end else begin
            s = {res_sign, res_mag};
        end
    end

endmodule
