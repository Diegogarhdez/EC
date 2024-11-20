// Diego García Hernández y Xuan Sun
// Escuela Superior de Ingeniería y Tecnología
// Curso 2024-2025
// 1er cuatrimestre
// Estructura de computadores
// Práctica 2: diseño de una CPU simple
// Fecha: 20/11/2024

`timescale 1ns / 10ps

module microc_tb;

  // declaración de variables
  reg clk, reset;
  reg s_inc, s_inm, we3, wez;
  reg [2:0] Op;
  wire z;
  wire [5:0] Opcode;

  microc microc1(Opcode, z, clk, reset, s_inc, s_inm , we3, wez, Op);

  // generación de reloj clk
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Periodo de 10 ns
  end

  // Reseteo y configuración de salidas del testbench
  initial begin
    $dumpfile("microc_tb.vcd");  // Archivo de salida para GTKWave
    $dumpvars;                   // Guardar todas las variables para visualización

    s_inc = 0;
    s_inm = 0;
    we3 = 0;
    wez = 0;
    Op = 3'b000;
    
  end

  initial begin 

    reset = 1;    // Reset inicial
    #10 reset = 0; // Desactivar reset después de 10 ns
  end

  // Bloque de simulación basado en Opcode
  initial begin
    #15; 
    // Simular instrucciones basadas en Opcode
    repeat (20) begin
      casez (Opcode)
        6'b1?????: begin  // Instrucción operación de la alu
          s_inc = 1; s_inm = 0; we3 = 1; wez = 1;
          Op = Opcode[4:2];  
        end

        6'b000000: begin  // Instrucción not
          s_inc = 1; s_inm = 0; we3 = 0; wez = 0;
          Op = 3'b0;  
        end

        6'b0001??: begin  // Instrucción li
          s_inc = 1; s_inm = 1; we3 = 1; wez = 1;
          Op = 3'b0;  
        end

        6'b010000: begin  // Instrucción j
          s_inc = 0; s_inm = 0; we3 = 0; wez = 0;
          Op = 3'b0;  
        end

        6'b010001: begin  // Instrucción jz
        if (z == 1'b1) begin
          s_inc = 0; s_inm = 0; we3 = 0; wez = 1;
        end
        else begin 
          s_inc = 1; s_inm = 0; we3 = 0; wez = 1;
        end
          Op = 3'b0; 
        end

        6'b010010: begin  // Instrucción jnz
          if (z == 1'b1) begin
          s_inc = 1; s_inm = 0; we3 = 0; wez = 1;
        end
        else begin 
          s_inc = 0; s_inm = 0; we3 = 0; wez = 1;
        end
          Op = 3'b0; 
        end

        6'b0011??: begin  // Instrución add
          s_inc = 0; s_inm = 1; we3 = 1; wez = 1; 
          Op = Opcode [4:2];
        end

        6'b0101??: begin  // Instrucción and
          s_inc = 0; s_inm = 0; we3 = 1; wez = 1; 
          Op = Opcode [4:2];
        end

        6'b0111??: begin // Instrucción or
          s_inc = 0; s_inm = 0; we3 = 1; wez = 1; 
          Op = Opcode [4:2];
        end

        default: begin  // Opcodes no definidos
          s_inc = 0; s_inm = 0; we3 = 0; wez = 0;
          Op = 3'b000;
        end
      endcase
      #10;  // Tiempo entre instrucciones
    end
    $finish;  // Termina la simulación
  end

  // Monitor para observar las señales
  initial begin
    $monitor("Time: %0dns | clk: %b | reset: %b | Opcode: %b | s_inc: %b | s_inm: %b | we3: %b | wez: %b | Op: %b | z: %b",
             $time, clk, reset, Opcode, s_inc, s_inm, we3, wez, Op, z);
  end

endmodule
