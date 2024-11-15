`timescale 1ns / 10ps

module microc_tb;

  // declaración de variables
  reg clk, reset;
  reg s_inc, s_inm, we3, wez;
  reg [2:0] Op;
  wire z;
  wire [5:0] Opcode;

  // instanciación del camino de datos
  microc uut (
    .Opcode(Opcode),
    .z(z),
    .clk(clk),
    .reset(reset),
    .s_inc(s_inc),
    .s_inm(s_inm),
    .we3(we3),
    .wez(wez),
    .Op(Op)
  );

  // generación de reloj clk
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Periodo de 10 ns
  end

  // Reseteo y configuración de salidas del testbench
  initial begin
    $dumpfile("microc_tb.vcd");  // Archivo de salida para GTKWave
    $dumpvars;                   // Guardar todas las variables para visualización

    // Reset inicial
    reset = 1;
    s_inc = 0;
    s_inm = 0;
    we3 = 0;
    wez = 0;
    Op = 3'b000;
    
    #10 reset = 0;  // Desactivar reset después de 10 ns
  end

  // Bloque simulación señales control por ciclo
  initial begin
    // retardos y señales para ejecutar primera instrucción (ciclo 1)
    #5;  // Esperar media señal de reloj para simular decodificación
    s_inc = 1;
    s_inm = 0;
    we3 = 1;
    wez = 0;
    Op = 3'b001;
    #5;  // Completar el ciclo

    // retardos y señales para ejecutar segunda instrucción (ciclo 2)
    #5;
    s_inc = 0;
    s_inm = 1;
    we3 = 1;
    wez = 1;
    Op = 3'b010;
    #5;

    // retardos y señales para ejecutar tercera instrucción (ciclo 3)
    #5;
    s_inc = 1;
    s_inm = 0;
    we3 = 0;
    wez = 1;
    Op = 3'b011;
    #5;

    // retardos y señales para ejecutar cuarta instrucción (inicio del bucle)
    #5;
    s_inc = 1;
    s_inm = 1;
    we3 = 1;
    wez = 0;
    Op = 3'b100;
    #5;

    // retardos y señales para la primera iteración del bucle (ciclo 5)
    #5;
    s_inc = 0;
    s_inm = 0;
    we3 = 1;
    wez = 0;
    Op = 3'b101;
    #5;

    // retardos y señales para la segunda iteración del bucle (ciclo 6)
    #5;
    s_inc = 1;
    s_inm = 1;
    we3 = 1;
    wez = 1;
    Op = 3'b110;
    #5;

    // retardos y señales para la tercera iteración del bucle (ciclo 7)
    #5;
    s_inc = 0;
    s_inm = 0;
    we3 = 1;
    wez = 0;
    Op = 3'b111;
    #5;

    // Se pueden agregar más ciclos según sea necesario

    $finish;  // Termina la simulación
  end

endmodule

