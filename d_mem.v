////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Memória de Dados (d_mem.v)
// DESCRIÇÃO: Memória de dados (RAM) assíncrona com tamanho parametrizável.
//            Suporta leitura e escrita de palavras de 32 bits.
//            Leitura assíncrona; escrita assíncrona controlada por MemWrite.
//            Quando MemRead=0, a saída ReadData fica em alta impedância.
////////////////////////////////////////////////////////////////////////////////////

 
module d_mem #(
    parameter MEM_SIZE = 256  // Número de palavras de 32 bits (parametrizável)
)(
    input  wire [31:0] Address,   // Endereço de acesso (vindo da ULA)
    input  wire [31:0] WriteData, // Dado a ser escrito (vindo do regfile)
    output wire [31:0] ReadData,  // Dado lido da memória
    input  wire        MemWrite,  // Habilita escrita na memória
    input  wire        MemRead    // Habilita leitura (ReadData em Z quando 0)
);
 
    // RAM: MEM_SIZE palavras de 32 bits
    reg [31:0] mem [0:MEM_SIZE-1];
 
    integer i;
 
    // Inicializa memória com zeros
    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1)
            mem[i] = 32'h00000000;
    end
 
    // Escrita assíncrona: quando MemWrite=1, escreve imediatamente
    always @(*) begin
        if (MemWrite)
            mem[Address >> 2] = WriteData;
    end
 
    // Leitura assíncrona: quando MemRead=0, saída em alta impedância
    assign ReadData = MemRead ? mem[Address >> 2] : 32'bz;
 
endmodule