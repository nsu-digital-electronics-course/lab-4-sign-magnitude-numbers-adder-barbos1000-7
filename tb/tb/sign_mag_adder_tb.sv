`timescale 1ns / 1ps

module sign_mag_adder_tb;
    parameter SIZE = 4; // Используем малую разрядность для наглядности
    
    logic [SIZE-1:0] a, b, s;
    logic overflow;

    // Экземпляр модуля
    sign_mag_adder #(SIZE) dut (.*);

    // Функция для вывода в консоль
    task check_result(input [SIZE-1:0] exp_s, input exp_ovf);
        #10;
        if (s !== exp_s || overflow !== exp_ovf) begin
            $display("ERROR: a=%b, b=%b | Result=%b (exp %b), OVF=%b (exp %b)", 
                      a, b, s, exp_s, overflow, exp_ovf);
        end else begin
            $display("OK: a=%b, b=%b | Result=%b, OVF=%b", a, b, s, overflow);
        end
    endtask

    initial begin
        $display("Starting tests...");

        // 1. Положительные без переполнения: 2 + 1 = 3
        a = 4'b0010; b = 4'b0001; check_result(4'b0011, 0);

        // 2. Отрицательные без переполнения: -2 + (-1) = -3
        a = 4'b1010; b = 4'b1001; check_result(4'b1011, 0);

        // 3. Разные знаки (результат полож): 7 + (-3) = 4
        a = 4'b0111; b = 4'b1011; check_result(4'b0100, 0);

        // 4. Разные знаки (результат отриц): -7 + 3 = -4
        a = 4'b1111; b = 4'b0011; check_result(4'b1100, 0);

        // 5. Получение нуля и нормализация: -5 + 5 = +0
        a = 4'b1101; b = 4'b0101; check_result(4'b0000, 0);

        // 6. Сложение двух -0 и +0: -0 + 0 = +0
        a = 4'b1000; b = 4'b0000; check_result(4'b0000, 0);

        // 7. Переполнение: 7 + 1 (в 4 битах макс модуль 7)
        a = 4'b0111; b = 4'b0001; check_result(4'b0000, 1); // Магнитyда зациклится или сбросится

        $display("Tests finished.");
        $finish;
    end
endmodule
