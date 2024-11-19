module microc(
  output wire [5:0] Opcode,
  output wire z,
  input wire clk, reset, s_inc, s_inm, we3, wez,
  input wire [2:0] Op
);
  // Declaración de variables internas
  wire [9:0] PC_actual, PC_nuevo, PC_incrementado;
  wire [15:0] Instruccion;
  wire [7:0] RD1, RD2, WD3, Inmediato, salida_alu;
  wire [3:0] RA1, RA2, WA3;
  wire zero;
  wire [9:0] Dir_salto;
  // Program Counter
  registro #(10) registro_pc(PC_actual, clk, reset, PC_nuevo);

  // Memoria de programa
  memprog memoria_programa(Instruccion, clk, PC_actual);

  // Obtención del Opcode
  assign Opcode = Instruccion[15:10];

  // Dirección de salto
  assign Dir_salto = Instruccion[9:0];

  // Direcciones de registros
  assign RA1 = Instruccion[11:8];
  assign RA2 = Instruccion[7:4];
  assign WA3 = Instruccion[3:0];

  // Valor inmediato
  assign Inmediato = Instruccion[7:0];  // Ajustado a 8 bits

  // Sumador para PC
  sum sum_pc(PC_incrementado, PC_actual, 10'b0000000001);

  // Mux para actualizar PC
  mux2 #(10) mux_pc(PC_nuevo, Dir_salto, PC_incrementado, s_inc);

  // Banco de registros
  regfile banco_registros(RD1, RD2, clk, we3, RA1, RA2, WA3, WD3);

  // ALU
  alu alu_inst(salida_alu, zero, RD1, RD2, Op);

  // Mux para seleccionar entre salida de ALU e inmediato
  mux2 #(8) mux_alu(WD3, salida_alu, Inmediato, s_inm);

  // Flip-Flop Tipo D
  ffd registro_zero(clk, reset, zero, wez, z);

endmodule
