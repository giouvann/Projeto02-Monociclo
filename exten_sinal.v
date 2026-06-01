////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Extensor de sinal (exten_sinal)
// DESCRIÇÃO: Realiza a extensão de sinal de um valor de 16 bits para 32 bits, preservando o sinal do número representado em complemento de dois.
////////////////////////////////////////////////////////////////////////////////////

module exten_sinal(
	input  [15:0]A,		            // barramento de entrada de 16 bits
	output [31:0]Y		               // barramento de saída de 32 bits
);
   assign Y = (A[15] == 0) ?	      // verifica o bit de sinal da entrada 
   {16'b0000000000000000, A}	      // para números positivos, replica 0 nos 16 bits mais significativos
   :
   {16'b1111111111111111, A};	      // para números negativos, replica 1 nos 16 bits mais significativos
endmodule
