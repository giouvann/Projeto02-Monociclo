////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Unidade Lógica e Aritmética (ULA).
// DESCRIÇÃO: Recebe dois operandos de 32 bits e um código de operação de 4 bits
//            vindo da ula_ctrl. Realiza operações aritméticas, lógicas e de
//            deslocamento necessárias para executar todas as instruções do projeto.          
////////////////////////////////////////////////////////////////////////////////////

module ula (
    input  [31:0] In1,        // Operando 1
    input  [31:0] In2,        // Operando 2
    input  [ 3:0] OP,         // Código da operação (vindo da ula_ctrl)
    output reg [31:0] result, // Resultado da operação
    output Zero_flag          // 1 se result == 0
);

    // Códigos de operação definidos pelo projetista
    localparam OP_ADD  = 4'b0000; // add / addi / lw / sw / beq / bne
    localparam OP_SUB  = 4'b0001; // sub
    localparam OP_AND  = 4'b0010; // and / andi
    localparam OP_OR   = 4'b0011; // or  / ori
    localparam OP_XOR  = 4'b0100; // xor / xori
    localparam OP_NOR  = 4'b0101; // nor
    localparam OP_SLT  = 4'b0110; // slt / slti  (signed)
    localparam OP_SLTU = 4'b0111; // sltu / sltiu (unsigned)
    localparam OP_SLL  = 4'b1000; // sll (In2 já contém o valor deslocado via shamt)
    localparam OP_SRL  = 4'b1001; // srl (logical right shift)
    localparam OP_SRA  = 4'b1010; // sra (arithmetic right shift)
    localparam OP_LUI  = 4'b1011; // lui: {imm, 16'b0}

    assign Zero_flag = (result == 32'b0);

    always @(*) begin
        case (OP)
            OP_ADD  : result = In1 + In2;
            OP_SUB  : result = In1 - In2;
            OP_AND  : result = In1 & In2;
            OP_OR   : result = In1 | In2;
            OP_XOR  : result = In1 ^ In2;
            OP_NOR  : result = ~(In1 | In2);
            OP_SLT  : result = ($signed(In1) < $signed(In2)) ? 32'd1 : 32'd0;
            OP_SLTU : result = (In1 < In2)                   ? 32'd1 : 32'd0;
            OP_SLL  : result = In2;       // shamt aplicado externamente na ula_ctrl/top
            OP_SRL  : result = In2;       // idem
            OP_SRA  : result = In2;       // idem
            OP_LUI  : result = {In2[15:0], 16'b0};
            default : result = 32'bx;
        endcase
    end

endmodule