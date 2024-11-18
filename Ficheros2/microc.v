module microc(output wire [5:0] Opcode, output wire z, input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] Op);
//Microcontrolador sin memoria de datos de un solo ciclo
  //variables internas
  wire[9:0] PC_actual,PC_nuevo;
  wire [15:0] Instruccion;  
  // Declaración del Program Counter.
  registro #(10) registro_pc(PC_actual, clk, reset, PC_nuevo);
  // Declaración del Memoria de programa.
  memprog memoria_programa(Instruccion,clk,PC_actual);
  // Obtención del OpCode.
  assign Opcode = Instruccion[15:10];
  // Obtención de la dirección de salto.
  wire [9:0] Dir_salto = Instruccion[9:0];
  // Declaración de registros.
  wire [3:0] RA1, RA2, WA3; 
  // Asignación de los registros.
  assign RA1 = Instruccion[11:8];
  assign RA2 = Instruccion[7:4];
  assign WA3 = Instruccion[3:0];
  // Flag de zero.
  wire zero;
  // Conexión de salida de la ALU, del inmediato y de los registros.
  wire [7:0] RD1, RD2, WD3, Inmediato, salida_alu;
  // Obtención del inmediato.
  assign Inmediato = Instruccion[11:4];
  // Multiplexor 2 a 1 para la ALU.
  mux2 #(8) mux_alu(WD3, Inmediato, salida_alu, s_inm);
  // Sumador del Program Counter.
  sum suma1(PC_nuevo, PC_actual, 10'b0000000001);
  // Multiplexor 2 a 1 para el Program Counter.
  mux2 #(10) mux_pc(PC_nuevo, Dir_salto, PC_actual, s_inc);
  // Declaración del Banco de Registros.
  regfile bankanshat(RD1, RD2, clk, we3, RA1, RA2, WA3, WD3);
  // Declaración de la ALU.
  alu alu(salida_alu, zero, RD1, RD2, Op);
  // Declaración del Flip-Flop tipo D.
  ffd ffd1(clk, reset, zero, wez, zero);

endmodule
