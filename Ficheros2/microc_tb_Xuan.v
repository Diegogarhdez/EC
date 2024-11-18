`timescale 1 ns / 10 ps
module microc_tb;

// declaración de variables
reg clk, reset;
reg s_inc, s_inm, we3, wez;
reg [2:0] Op;
wire [5:0] Opcode;
wire z;

// instanciación del camino de datos
microc microc1(Opcode, z, clk, reset, s_inc, s_inm , we3, wez, Op);

// generación de reloj clk
always #5 clk = ~clk;

// Reseteo y configuración de salidas del testbench
initial
begin
  $dumpfile("microc_tb.vcd");
  $dumpvars;
  // ... señal de reset
  clk = 0;
  reset = 1;
  s_inc = 0;
  s_inm = 0;
  we3 = 0;
  wez = 0;
  Op = 3'b000;

  //Mantener reset activo por unos ciclos
  #15;
  reset = 0;
end

// Bloque simulación señales control por ciclo
initial
begin
  // retardos y señales para ejecutar primera instrucción (ciclo 1)
  
  // retardos y señales para ejecutar segunda instrucción (ciclo 2)
  // ...
  $finish;
end

endmodule