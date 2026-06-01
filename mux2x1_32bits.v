////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Multiplexador de 2 para 1 com 5 bits (mux2x1_5bits)
// DESCRIÇÃO: Implementa um multiplexador 2 para 1 de 32 bits. O sinal de seleção S determina qual das entradas (A ou B) será encaminhada para a saída Y.
////////////////////////////////////////////////////////////////////////////////////

module mux2x1_5bits(
   input [31:0]A,                  // primero barramento de entrada de 32 bits
   input [31:0]B,                  // segundo barramento de entrada de 32 bits
   input S,                        // sinal de seleção do multiplexador
   output [31:0]Y                  // barramento de saída de 32 bits
);
   assign Y = (S == 0) ?           // seleciona qual entrada será encaminhada para a saída
   A                               // quando S = 0, a saída recebe o valor da entrada A
   :
   B;                              // quando S = 1, a saída recebe o valor da entrada B
endmodule