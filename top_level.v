////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Módulo top-level do processador MIPS monociclo.
// DESCRIÇÃO: Integra todos os módulos: PC, i_mem, regfile, ULA, ula_ctrl,
//            ctrl e d_mem. Implementa os multiplexadores e conexões
//            necessárias para executar as instruções do subconjunto              
////////////////////////////////////////////////////////////////////////////////////

module top_level (
    input  wire        clock,
    input  wire        reset
);
 
    // PC e memória de instruções
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] PCplus4;
    wire [31:0] instruction;
 
    pc PC_reg (
        .clock  (clock),
        .nextPC (nextPC),
        .PC     (PC)
    );
 
    assign PCplus4 = PC + 32'd4;
 
    i_mem #(.MEM_SIZE(256)) IMEM (
        .address (PC),
        .i_out   (instruction)
    );
 
    // Decodificação dos campos da instrução
    wire [5:0]  opcode = instruction[31:26];
    wire [4:0]  rs     = instruction[25:21];
    wire [4:0]  rt     = instruction[20:16];
    wire [4:0]  rd     = instruction[15:11];
    wire [4:0]  shamt  = instruction[10:6];
    wire [5:0]  funct  = instruction[5:0];
    wire [15:0] imm16  = instruction[15:0];
 
    // Unidade de Controle
    wire       RegDst, ALUSrc, MemtoReg, RegWrite;
    wire       MemRead, MemWrite, Branch, BranchNe, ShiftOp;
    wire [2:0] ALUOp;
 
    ctrl CTRL (
        .opcode   (opcode),
        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .MemtoReg (MemtoReg),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .Branch   (Branch),
        .BranchNe (BranchNe),
        .ALUOp    (ALUOp),
        .ShiftOp  (ShiftOp)
    );
 
    // Banco de Registradores
    wire [4:0]  WriteReg;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] WriteData;
 
    // RegDst: 0 = rt (tipo I), 1 = rd (tipo R)
    mux2x1_5bits MUX_REGDST (
        .A (rt),
        .B (rd),
        .S (RegDst),
        .Y (WriteReg)
    );
 
    regfile REGFILE (
        .Clock     (clock),
        .Reset     (reset),
        .ReadAddr1 (rs),
        .ReadAddr2 (rt),
        .WriteAddr (WriteReg),
        .WriteData (WriteData),
        .RegWrite  (RegWrite),
        .ReadData1 (ReadData1),
        .ReadData2 (ReadData2)
    );
 
    // Extensor de sinal do imediato
    wire [31:0] imm_ext;
 
    exten_sinal EXT (
        .A (imm16),
        .Y (imm_ext)
    );
 
    // Tratamento de deslocamento (sll, srl, sra, sllv, srlv, srav)
    // Para instruções tipo R com funct de shift, o segundo operando da
    // ULA é o valor de ReadData2 deslocado pela quantidade de bits
    // indicada em shamt (sll/srl/sra) ou pelos 5 bits menos
    // significativos de ReadData1 (sllv/srlv/srav).
    localparam F_SLL  = 6'b000000;
    localparam F_SRL  = 6'b000010;
    localparam F_SRA  = 6'b000011;
    localparam F_SLLV = 6'b000100;
    localparam F_SRLV = 6'b000110;
    localparam F_SRAV = 6'b000111;
 
    wire is_shift_imm = ShiftOp && ((funct == F_SLL)  || (funct == F_SRL)  || (funct == F_SRA));
    wire is_shift_var = ShiftOp && ((funct == F_SLLV) || (funct == F_SRLV) || (funct == F_SRAV));
    wire is_shift     = is_shift_imm || is_shift_var;
 
    wire [4:0] shift_amount = is_shift_var ? ReadData1[4:0] : shamt;
 
    reg [31:0] shift_result;
    always @(*) begin
        case (funct)
            F_SLL, F_SLLV : shift_result = ReadData2 << shift_amount;
            F_SRL, F_SRLV : shift_result = ReadData2 >> shift_amount;
            F_SRA, F_SRAV : shift_result = $signed(ReadData2) >>> shift_amount;
            default       : shift_result = ReadData2;
        endcase
    end
 
    // ULA
    wire [31:0] ALU_In2;
    wire [31:0] ALU_In2_pre;
    wire [31:0] ALU_result;
    wire        Zero_flag;
    wire [3:0]  ALU_OP;
 
    // Quando a instrução é de deslocamento, o segundo operando vem do
    // shifter; caso contrário, vem diretamente de ReadData2.
    assign ALU_In2_pre = is_shift ? shift_result : ReadData2;
 
    // ALUSrc: 0 = ReadData2 (ou resultado de shift), 1 = imediato estendido
    mux2x1_32bits MUX_ALUSRC (
        .A (ALU_In2_pre),
        .B (imm_ext),
        .S (ALUSrc),
        .Y (ALU_In2)
    );
 
    ula_ctrl ULA_CTRL (
        .ALUOp  (ALUOp),
        .funct  (funct),
        .opcode (opcode),
        .OP     (ALU_OP)
    );
 
    ula ULA (
        .In1       (ReadData1),
        .In2       (ALU_In2),
        .OP        (ALU_OP),
        .result    (ALU_result),
        .Zero_flag (Zero_flag)
    );
 
    // Memória de Dados
    wire [31:0] DMEM_ReadData;
 
    d_mem #(.MEM_SIZE(256)) DMEM (
        .Address   (ALU_result),
        .WriteData (ReadData2),
        .ReadData  (DMEM_ReadData),
        .MemWrite  (MemWrite),
        .MemRead   (MemRead)
    );
 
    // MemtoReg: 0 = resultado da ULA, 1 = dado lido da memória
    mux2x1_32bits MUX_MEMTOREG (
        .A (ALU_result),
        .B (DMEM_ReadData),
        .S (MemtoReg),
        .Y (WriteData)
    );
 
    // Lógica de desvio (beq / bne) e cálculo do próximo PC
    wire [31:0] branch_offset;
    wire [31:0] branch_target;
    wire        PCSrc;
 
    assign branch_offset = imm_ext << 2;
    assign branch_target = PCplus4 + branch_offset;
 
    // PCSrc = 1 quando o desvio deve ser tomado
    assign PCSrc = (Branch   && Zero_flag) ||
                   (BranchNe && ~Zero_flag);
 
    mux2x1_32bits MUX_PC (
        .A (PCplus4),
        .B (branch_target),
        .S (PCSrc),
        .Y (nextPC)
    );
 
endmodule