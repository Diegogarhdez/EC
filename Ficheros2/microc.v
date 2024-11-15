module microc(output wire [5:0] Opcode, output wire z, input wire clk, reset, s_inc, s_inm, we3, wez, input wire [2:0] Op);
//Microcontrolador sin memoria de datos de un solo ciclo
  //variables internas
  wire[9:0] PC_actual,PC_nuevo;
  wire [15:0] Instruccion;  

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

  mux2_8 mux_alu(WD3, Inmediato, salida_alu, s_inm);
  sum1 suma1(PC_nuevo, PC_nuevo);
  mux2_10 mux_pc(PC_nuevo, Dir_salto, PC_actual, s_inc);

  regfile bankanshat(RD1, RD2, clk, we3, RA1, RA2, WA3, WD3);
  alu alu(salida_alu, zero, RD1, RD2, Op);
  ffd ffd1(clk, reset, zero, wez, zero);

endmodule


module mux2_10(output wire [9:0] PC_nuevo, input wire[9:0] Dir_salto, PC_actual, input wire s_inc);
  assign PC_nuevo = s_inc? PC_actual : Dir_salto;
endmodule

module mux2_8(output wire [7:0] WD3, input wire [7:0] Inmediato, salida_alu, input wire s_inm);
  assign WD3 = s_inm? Inmediato : salida_alu;
endmodule

module sum1(output wire [9:0] PC_mas_1, input wire [9:0] PC_actual);
  assign PC_mas_1 = PC_actual + 10'b0000000001;
endmodule