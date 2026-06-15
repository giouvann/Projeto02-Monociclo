////////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Unidade de Controle (ctrl)
// DESCRIÇÃO: Decodifica o campo opcode (bits [31:26]) da instrução e gera os
//            sinais de controle para o datapath: RegDst, ALUSrc, MemtoReg,
//            RegWrite, MemRead, MemWrite, Branch, BranchNe, ALUOp e ShiftOp          
////////////////////////////////////////////////////////////////////////////////////

module ctrl (
    input  [5:0] opcode,     // Bits [31:26] da instrução
 
    output       RegDst,     
    output       ALUSrc,     
    output       MemtoReg,  
    output       RegWrite,   
    output       MemRead,    
    output       MemWrite,   
    output       Branch,     
    output       BranchNe,   
    output [2:0] ALUOp,      
    output       ShiftOp     
);
 
    // Opcodes 
    localparam OPC_RTYPE = 6'b000000; // add, sub, and, or, xor, nor, slt, sltu, sll, srl, sra, sllv, srlv, srav
    localparam OPC_ADDI  = 6'b001000;
    localparam OPC_ANDI  = 6'b001100;
    localparam OPC_ORI   = 6'b001101;
    localparam OPC_XORI  = 6'b001110;
    localparam OPC_SLTI  = 6'b001010;
    localparam OPC_SLTIU = 6'b001011;
    localparam OPC_LUI   = 6'b001111;
    localparam OPC_LW    = 6'b100011;
    localparam OPC_SW    = 6'b101011;
    localparam OPC_BEQ   = 6'b000100;
    localparam OPC_BNE   = 6'b000101;
 
    // ALUOp (definido em ula_ctrl.v) 
    localparam ALUOP_ADD   = 3'b000; // addi, lw, sw
    localparam ALUOP_RTYPE = 3'b001; // tipo R -> usa funct
    localparam ALUOP_LOGIC = 3'b010; // andi, ori, xori -> usa opcode
    localparam ALUOP_SLT   = 3'b011; // slti, sltiu -> usa opcode
    localparam ALUOP_LUI   = 3'b100; // lui
    localparam ALUOP_SUB   = 3'b101; // beq, bne (subtrai para comparar)
 
    reg       RegDst_r, ALUSrc_r, MemtoReg_r, RegWrite_r;
    reg       MemRead_r, MemWrite_r, Branch_r, BranchNe_r, ShiftOp_r;
    reg [2:0] ALUOp_r;
 
    always @(*) begin
        // Valores padrão (instrução não reconhecida = NOP seguro)
        RegDst_r   = 1'b0;
        ALUSrc_r   = 1'b0;
        MemtoReg_r = 1'b0;
        RegWrite_r = 1'b0;
        MemRead_r  = 1'b0;
        MemWrite_r = 1'b0;
        Branch_r   = 1'b0;
        BranchNe_r = 1'b0;
        ShiftOp_r  = 1'b0;
        ALUOp_r    = ALUOP_ADD;
 
        case (opcode)
 
            // Tipo R 
            OPC_RTYPE: begin
                RegDst_r   = 1'b1; // destino = rd
                ALUSrc_r   = 1'b0; // segundo operando = ReadData2
                MemtoReg_r = 1'b0; // escreve resultado da ULA
                RegWrite_r = 1'b1;
                ALUOp_r    = ALUOP_RTYPE;
                ShiftOp_r  = 1'b1; // habilita seleção de shamt para sll/srl/sra no top
            end
 
            // addi 
            OPC_ADDI: begin
                RegDst_r   = 1'b0; // destino = rt
                ALUSrc_r   = 1'b1; // segundo operando = imediato
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b1;
                ALUOp_r    = ALUOP_ADD;
            end
 
            // andi / ori / xori 
            OPC_ANDI, OPC_ORI, OPC_XORI: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b1;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b1;
                ALUOp_r    = ALUOP_LOGIC;
            end
 
            //  slti / sltiu 
            OPC_SLTI, OPC_SLTIU: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b1;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b1;
                ALUOp_r    = ALUOP_SLT;
            end
 
            //lui 
            OPC_LUI: begin
                RegDst_r   = 1'b0;
                ALUSrc_r   = 1'b1;
                MemtoReg_r = 1'b0;
                RegWrite_r = 1'b1;
                ALUOp_r    = ALUOP_LUI;
            end
 
            // lw 
            OPC_LW: begin
                RegDst_r   = 1'b0; // destino = rt
                ALUSrc_r   = 1'b1; // base + offset
                MemtoReg_r = 1'b1; // escreve dado da memória
                RegWrite_r = 1'b1;
                MemRead_r  = 1'b1;
                ALUOp_r    = ALUOP_ADD;
            end
 
            // sw 
            OPC_SW: begin
                ALUSrc_r   = 1'b1; // base + offset
                MemWrite_r = 1'b1;
                ALUOp_r    = ALUOP_ADD;
            end
 
            // beq 
            OPC_BEQ: begin
                ALUSrc_r = 1'b0; // compara ReadData1 e ReadData2
                Branch_r = 1'b1;
                ALUOp_r  = ALUOP_SUB;
            end
 
            // bne 
            OPC_BNE: begin
                ALUSrc_r   = 1'b0;
                BranchNe_r = 1'b1;
                ALUOp_r    = ALUOP_SUB;
            end
 
            default: begin
                // Mantém valores padrão (NOP)
            end
 
        endcase
    end
 
    assign RegDst   = RegDst_r;
    assign ALUSrc   = ALUSrc_r;
    assign MemtoReg = MemtoReg_r;
    assign RegWrite = RegWrite_r;
    assign MemRead  = MemRead_r;
    assign MemWrite = MemWrite_r;
    assign Branch   = Branch_r;
    assign BranchNe = BranchNe_r;
    assign ALUOp    = ALUOp_r;
    assign ShiftOp  = ShiftOp_r;
 
endmodule