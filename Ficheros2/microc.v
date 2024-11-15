module microc(output wire [5:0] Opcode, output wire z, input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] Op);
//Microcontrolador sin memoria de datos de un solo ciclo
  //variables internas
  wire[9:0] PC_actual,PC_nuevo;
  wire [15:0] Instruccion;  

  registro #(10) registro_pc(PC_actual, clk, reset, PC_nuevo);
  memprog memoria_programa(Instruccion,clk,PC_actual);

  assign Opcode = Instruccion[15:10];
  wire [9:0] Dir_salto = Instruccion[9:0];
  wire [3:0] RA1; 
  wire [3:0] RA2; 
  wire [3:0] WA3;
  assign RA1 = Instruccion[11:8];
  assign RA2 = Instruccion[7:4];
  assign WA3 = Instruccion[3:0];
  wire zero;
  wire [7:0] salida_alu;
  wire [7:0] RD1, RD2, WD3, Inmediato;
  assign Inmediato = Instruccion[11:4];

  mux2 #(8) mux_alu(WD3, Inmediato, salida_alu, s_inm);
  sum suma1(PC_nuevo, PC_nuevo, 10'b0000000001);
  mux2 #(10) mux_pc(PC_nuevo, Dir_salto, PC_actual, s_inc);

  regfile bankanshat(RD1, RD2, clk, we3, RA1, RA2, WA3, WD3);
  alu alu(salida_alu, zero, RD1, RD2, Op);
  ffd ffd1(clk, reset, zero, wez, zero);

endmodule
