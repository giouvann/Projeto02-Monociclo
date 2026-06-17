////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Memória de Instruções ROM (i_mem.v)
// DESCRIÇÃO: Memória de instrução (ROM) assíncrona com tamanho parametrizável.
//            Carrega instruções a partir do arquivo "instructions.list" em
//            formato binário, uma instrução de 32 bits por linha.
////////////////////////////////////////////////////////////////////////////////////

module i_mem #(
    parameter MEM_SIZE = 256  // Número de palavras de 32 bits (parametrizável)
)(
    input  wire [31:0] address, // Endereço fornecido pelo PC
    output wire [31:0] i_out   // Instrução lida na posição address
);
 
    // Memória ROM: MEM_SIZE palavras de 32 bits
    reg [31:0] mem [0:MEM_SIZE-1];
 
    // Inicializa a memória a partir do arquivo externo "instructions.list" (fornecido pelo professor)
    // Cada linha do arquivo contém uma instrução em binário (32 bits)
    initial begin
        $readmemb("instructions.list", mem);
    end
 
    // Leitura assíncrona: endereço dividido por 4 (word-addressed)
    // O PC fornece endereço em bytes; convertemos para índice de palavra
    assign i_out = mem[address >> 2];
 
endmodule