////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Bando de Registradores (regfile)
// DESCRIÇÃO: Banco de 32 registradores de 32 bits com leitura dupla assíncrona e escrita síncrona. 
//            Garante o registrador $0 sempre igual a zero e possui reset global.        
////////////////////////////////////////////////////////////////////////////////////

module regfile (
    input         Clock,       // Sincroniza escritas (borda de subida)
    input         Reset,       // Zera todos os registradores sincronamente
    input  [4:0]  ReadAddr1,   // Endereço do registrador lido em ReadData1
    input  [4:0]  ReadAddr2,   // Endereço do registrador lido em ReadData2
    input  [4:0]  WriteAddr,   // Endereço do registrador a ser escrito
    input  [31:0] WriteData,   // Dado a ser escrito
    input         RegWrite,    // Habilita escrita (1 = escreve, 0 = não escreve)
    output [31:0] ReadData1,   // Dado lido assincronamente de ReadAddr1
    output [31:0] ReadData2    // Dado lido assincronamente de ReadAddr2
);

    reg [31:0] registers [31:0]; // 32 registradores de 32 bits

    integer i;

    // --- Escrita síncrona ---
    always @(posedge Clock) begin
        if (Reset) begin
            // Zera todos os registradores, incluindo $0
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (RegWrite && WriteAddr != 5'b0) begin
            // $0 nunca é sobrescrito (WriteAddr == 0 é ignorado)
            registers[WriteAddr] <= WriteData;
        end
    end

    // --- Leitura assíncrona ---
    // $0 sempre retorna 0, independente do conteúdo do array
    assign ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : registers[ReadAddr1];
    assign ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : registers[ReadAddr2];

endmodule