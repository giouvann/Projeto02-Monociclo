////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Contador do Programa (pc.v)
// DESCRIÇÃO: Registrador síncrono que armazena o endereço da instrução atual.
//            Atualiza na borda de subida do clock. Enquanto reset=1, o PC
//            permanece fixo em 0, garantindo que a primeira instrução seja
//            buscada e executada somente após o término do reset.
////////////////////////////////////////////////////////////////////////////////////

module pc (
    input  wire        clock,    // Borda de subida atualiza o PC
    input  wire        reset,    // Enquanto = 1, mantém PC = 0
    input  wire [31:0] nextPC,   // Próximo valor do PC (entrada)
    output reg  [31:0] PC        // Valor atual do PC (saída para i_mem)
);

    // Inicializa PC em 0 (necessário para simuladores antes do 1o clock)
    initial begin
        PC = 32'h00000000;
    end

    // A cada borda de subida do clock:
    // - se reset=1, mantém PC = 0
    // - caso contrário, atualiza PC com nextPC
    always @(posedge clock) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= nextPC;
    end

endmodule