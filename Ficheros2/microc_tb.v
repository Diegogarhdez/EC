// Diego García Hernández y Xuan Sun
// Escuela Superior de Ingeniería y Tecnología
// Curso 2024-2025
// 1er cuatrimestre
// Estructura de computadores
// Práctica 2: diseño de una CPU simple

`timescale 1 ns / 10 ps
module microc_tb;
  // Declaración de variables
  wire [5:0] Opcode;
  wire zero;
  reg reset, s_inc, s_inm, we3, wez;
  reg [2:0] Op;
  reg [3:0] state, nextstate;  // Corregido el tamaño del registro
  reg clk;

  // Codificación de los estados
  parameter S0 = 4'b0000;  // Declaración de constantes que representan estados
  parameter S1 = 4'b0001;
  parameter S2 = 4'b0010;
  parameter S3 = 4'b0011;
  parameter S4 = 4'b0100;
  parameter S5 = 4'b0101;
  parameter S6 = 4'b0110;
  parameter S7 = 4'b0111;
  parameter S8 = 4'b1000;
  parameter S9 = 4'b1001;
  parameter S10 = 4'b1010;

  // Instanciación del microcontrolador
  microc microc2(
    .Opcode(Opcode),
    .z(zero),
    .clk(clk),
    .reset(reset),
    .s_inc(s_inc),
    .s_inm(s_inm),
    .we3(we3),
    .wez(wez),
    .Op(Op)
  );

  // Generación del reloj clk
  initial begin
    clk = 0;
    forever #10 clk = ~clk;  // Periodo de 20 ns (10 ns alto, 10 ns bajo)
  end

  // Bloque inicial para la simulación
  initial begin
    $dumpfile("microc_tb.vcd");
    $dumpvars(0, microc_tb);  
    reset = 1;
    s_inc = 0;
    s_inm = 0;
    we3 = 0;
    wez = 0;
    Op = 3'b000;
    state = S0;
    #20;
    reset = 0;
    #400;
    $finish;
  end 

  // Máquina de estados para controlar las señales
  always @(negedge clk) begin
    case (state)
      S0: begin
        s_inc = 1'b1;
        s_inm = 1'b1;
        we3 = 1'b1;
        Op = 3'b000;
        wez = 1'b0;
        nextstate = S1; 
      end
      S1: begin
        s_inc = 1'b1;
        s_inm = 1'b1;
        we3 = 1'b1;
        Op = 3'b000;
        wez = 1'b0;
        nextstate = S2;
      end
      S2: begin
        s_inc = 1'b1;
        s_inm = 1'b0;
        we3 = 1'b1;
        Op = 3'b100;
        wez = 1'b1;
        nextstate = S3; 
      end
      S3: begin
        s_inc = 1'b1;
        s_inm = 1'b0;
        we3 = 1'b1;
        Op = 3'b011;
        wez = 1'b1;
        nextstate = S4;
      end
      S4: begin
        s_inc = !zero;
        s_inm = 1'b0;
        we3 = 1'b0;
        wez = 1'b0; 
        if(zero)
          nextstate = S9;
        else 
          nextstate = S5;
      end
      S5: begin
        s_inc = 1'b1;
        s_inm = 1'b1;
        we3 = 1'b1;
        Op = 3'b010;
        wez = 1'b1;
        nextstate = S6; 
      end
      S6: begin
        s_inc = 1'b1;
        s_inm = 1'b1;
        we3 = 1'b1;
        Op = 3'b011;
        wez = 1'b1;
        nextstate = S7;
      end
      S7: begin
        s_inc = !zero;
        s_inm = 1'b0;
        we3 = 1'b0;
        wez = 1'b0; 
        if(zero)
          nextstate = S9;
        else 
          nextstate = S8;
      end
      S8: begin
        s_inc = 1'b0;
        s_inm = 1'b0;
        we3 = 1'b0;
        wez = 1'b0;
        nextstate = S4; 
      end
      S9: begin
        s_inc = 1'b1;
        s_inm = 1'b0;
        we3 = 1'b1;
        Op = 3'b010;
        wez = 1'b1;
        nextstate = S10; 
      end
      S10: begin
        s_inc = 1'b1;
        s_inm = 1'b0;
        we3 = 1'b1;
        Op = 3'b011;
        wez = 1'b1;
        nextstate = S10;
      end
      default: nextstate = S0;
    endcase

    state <= nextstate;
  end
  initial begin
    $monitor("Time=%0t ns | clk=%b | reset=%b | state=%b | s_inc=%b | s_inm=%b | we3=%b | wez=%b | Op=%b | Opcode=%b | zero=%b",
             $time, clk, reset, state, s_inc, s_inm, we3, wez, Op, Opcode, zero);
  end

endmodule