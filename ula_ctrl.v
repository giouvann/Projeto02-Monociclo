////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Unidade de Controle da ULA (ula_ctrl)
// DESCRIÇÃO:           
////////////////////////////////////////////////////////////////////////////////////

module ula_ctrl (
    input  [2:0] ALUOp,  // Grupo da operação (vindo de ctrl.v)
    input  [5:0] funct,  // Bits [5:0] da instrução (tipo R)
    input  [5:0] opcode, // Bits [31:26] da instrução (tipo I)
    output reg [3:0] OP  // Operação para a ULA (ula.v)
);

    // ---------- ALUOp (definido em ctrl.v) ----------
    localparam ALUOP_ADD   = 3'b000; // addi, lw, sw
    localparam ALUOP_RTYPE = 3'b001; // tipo R → usa funct
    localparam ALUOP_LOGIC = 3'b010; // andi, ori, xori → usa opcode
    localparam ALUOP_SLT   = 3'b011; // slti, sltiu      → usa opcode
    localparam ALUOP_LUI   = 3'b100; // lui
    localparam ALUOP_SUB   = 3'b101; // beq, bne (subtrai para comparar)

    // ---------- Opcodes tipo I relevantes ----------
    localparam OPC_ANDI  = 6'b001100;
    localparam OPC_ORI   = 6'b001101;
    localparam OPC_XORI  = 6'b001110;
    localparam OPC_SLTI  = 6'b001010;
    localparam OPC_SLTIU = 6'b001011;

    // ---------- Funct tipo R ----------
    localparam F_ADD  = 6'b100000;
    localparam F_SUB  = 6'b100010;
    localparam F_AND  = 6'b100100;
    localparam F_OR   = 6'b100101;
    localparam F_XOR  = 6'b100110;
    localparam F_NOR  = 6'b100111;
    localparam F_SLT  = 6'b101010;
    localparam F_SLTU = 6'b101011;
    localparam F_SLL  = 6'b000000;
    localparam F_SRL  = 6'b000010;
    localparam F_SRA  = 6'b000011;
    localparam F_SLLV = 6'b000100;
    localparam F_SRLV = 6'b000110;
    localparam F_SRAV = 6'b000111;

    // ---------- OP da ULA (deve coincidir com ula.v) ----------
    localparam OP_ADD  = 4'b0000;
    localparam OP_SUB  = 4'b0001;
    localparam OP_AND  = 4'b0010;
    localparam OP_OR   = 4'b0011;
    localparam OP_XOR  = 4'b0100;
    localparam OP_NOR  = 4'b0101;
    localparam OP_SLT  = 4'b0110;
    localparam OP_SLTU = 4'b0111;
    localparam OP_SLL  = 4'b1000;
    localparam OP_SRL  = 4'b1001;
    localparam OP_SRA  = 4'b1010;
    localparam OP_LUI  = 4'b1011;

    always @(*) begin
        case (ALUOp)

            // lw, sw, addi: sempre soma
            ALUOP_ADD: OP = OP_ADD;

            // beq, bne: subtrai e verifica Zero_flag
            ALUOP_SUB: OP = OP_SUB;

            // lui: passa imediato deslocado 16 bits
            ALUOP_LUI: OP = OP_LUI;

            // slti / sltiu: opcode decide signed vs unsigned
            ALUOP_SLT: OP = (opcode == OPC_SLTIU) ? OP_SLTU : OP_SLT;

            // andi / ori / xori: opcode decide qual lógica
            ALUOP_LOGIC: begin
                case (opcode)
                    OPC_ANDI : OP = OP_AND;
                    OPC_ORI  : OP = OP_OR;
                    OPC_XORI : OP = OP_XOR;
                    default  : OP = OP_ADD;
                endcase
            end

            // tipo R: funct decide a operação
            ALUOP_RTYPE: begin
                case (funct)
                    F_ADD  : OP = OP_ADD;
                    F_SUB  : OP = OP_SUB;
                    F_AND  : OP = OP_AND;
                    F_OR   : OP = OP_OR;
                    F_XOR  : OP = OP_XOR;
                    F_NOR  : OP = OP_NOR;
                    F_SLT  : OP = OP_SLT;
                    F_SLTU : OP = OP_SLTU;
                    F_SLL  : OP = OP_SLL;
                    F_SRL  : OP = OP_SRL;
                    F_SRA  : OP = OP_SRA;
                    F_SLLV : OP = OP_SLL; // deslocamento variável, mesma operação
                    F_SRLV : OP = OP_SRL;
                    F_SRAV : OP = OP_SRA;
                    default: OP = OP_ADD;
                endcase
            end

            default: OP = OP_ADD;

        endcase
    end

endmodule