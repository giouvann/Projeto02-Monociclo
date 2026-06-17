`timescale 1ns/1ps
///////////////////////////////////////////////////////////////////////////////////
// GRUPO: David Fernando, Evelin Dionizio, Giovanna Costa, Miguel Monteiro
// ATIVIDADE: Projeto 02 - 2ª VA
// DISCIPLINA: Arquitetura e Organização de Computadores
// SEMESTRE: 2026.1
// ARQUIVO: Testbench (testbench.v)
// DESCRIÇÃO: Gera o clock, aplica reset inicial, executa o programa carregado em
//            instruction.list e imprime o estado do PC, da instrução, e do
//            banco de registradores a cada ciclo.
/////////////////////////////////////////////////////////////////////////////
module testbench;

    reg clock;
    reg reset;

    // Instancia o processador
    top_level UUT (
        .clock (clock),
        .reset (reset)
    );

    // Geração do clock: período de 10ns (5ns em cada nível)
    always #5 clock = ~clock;

    // Estímulo principal
    initial begin
        clock = 1'b0;
        reset = 1'b1;

        // Mantém reset ativo por um ciclo completo de clock
        @(negedge clock);
        @(posedge clock);
        @(negedge clock);
        reset = 1'b0;

        $display("\n========== EXECUÇÃO POR TESTE ==========\n");

        // ====== MAGIC NUMBER (3 instruções) ======
        repeat (3) @(negedge clock);
        $display("===== TESTE MAGIC_NUMBER (3 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024000)", UUT.REGFILE.registers[25]);
        $display("");

        // ====== TESTE 1 (10 instruções) ======
        repeat (10) @(negedge clock);
        $display("===== TESTE 1 - ADD, SUB, ADDI, AND, OR, XOR, NOR (10 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024001)", UUT.REGFILE.registers[25]);
        $display("$s0 ($16) = %0d (esperado 20)", UUT.REGFILE.registers[16]);
        $display("$s1 ($17) = %0d (esperado 15)", UUT.REGFILE.registers[17]);
        $display("$t0 ($8)  = %0d (esperado 35, add)", UUT.REGFILE.registers[8]);
        $display("$t1 ($9)  = %0d (esperado 5, sub)", UUT.REGFILE.registers[9]);
        $display("$t2 ($10) = %0d (esperado 40, addi)", UUT.REGFILE.registers[10]);
        $display("$t3 ($11) = %0d (esperado 4, and)", UUT.REGFILE.registers[11]);
        $display("$t4 ($12) = %0d (esperado 31, or)", UUT.REGFILE.registers[12]);
        $display("$t5 ($13) = %0d (esperado 27, xor)", UUT.REGFILE.registers[13]);
        $display("$t6 ($14) = %0d (esperado -32, nor signed)", $signed(UUT.REGFILE.registers[14]));
        $display("");

        // ====== TESTE 2 (5 instruções) ======
        repeat (7) @(negedge clock);
        $display("===== TESTE 2 - SLL e BEQ (7 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024002)", UUT.REGFILE.registers[25]);
        $display("$s0 ($16) = %0d (esperado 80, após 2 iterações do loop)", UUT.REGFILE.registers[16]);
        $display("$s1 ($17) = %0d (esperado 20)", UUT.REGFILE.registers[17]);
        $display("");

        // ====== TESTE 3 (6 instruções) ======
        repeat (8) @(negedge clock);
        $display("===== TESTE 3 - SLLV e BNE (8 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024003)", UUT.REGFILE.registers[25]);
        $display("$s0 ($16) = %0d (esperado 80, após 2 iterações do loop)", UUT.REGFILE.registers[16]);
        $display("$s1 ($17) = %0d (esperado 80)", UUT.REGFILE.registers[17]);
        $display("$t0 ($8)  = %0d (esperado 2)", UUT.REGFILE.registers[8]);
        $display("");

        // ====== TESTE 4 (6 instruções) ======
        repeat (6) @(negedge clock);
        $display("===== TESTE 4 - SRA e SLT (6 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024004)", UUT.REGFILE.registers[25]);
        $display("$s0 ($16) = %0d (esperado -2)", $signed(UUT.REGFILE.registers[16]));
        $display("$s1 ($17) = %0d (esperado -1, após 3 iterações)", $signed(UUT.REGFILE.registers[17]));
        $display("$t0 ($8)  = %0d (esperado 1, resultado do slt)", UUT.REGFILE.registers[8]);
        $display("");

        // ====== TESTE 5 (18 instruções) ======
        repeat (18) @(negedge clock);
        $display("===== TESTE 5 - LW e SW (18 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024005)", UUT.REGFILE.registers[25]);
        $display("$s6 ($22) = %0d (esperado 12, endereço base)", UUT.REGFILE.registers[22]);
        $display("$s7 ($23) = %0d (esperado 40, endereço base)", UUT.REGFILE.registers[23]);
        $display("$s0 ($16) = %0d (esperado 10)", UUT.REGFILE.registers[16]);
        $display("$s1 ($17) = %0d (esperado 20)", UUT.REGFILE.registers[17]);
        $display("$s2 ($18) = %0d (esperado 30)", UUT.REGFILE.registers[18]);
        $display("$s3 ($19) = %0d (esperado 40)", UUT.REGFILE.registers[19]);
        $display("$t0 ($8)  = %0d (esperado 100, soma final)", UUT.REGFILE.registers[8]);
        $display("$t1 ($9)  = %0d (esperado 40)", UUT.REGFILE.registers[9]);
        $display("$t3 ($11) = %0d (esperado 30, soma de 10+20)", UUT.REGFILE.registers[11]);
        $display("$t4 ($12) = %0d (esperado 70, soma de 30+40)", UUT.REGFILE.registers[12]);
        $display("mem[3]  (byte addr 12) = %0d (esperado 10)", UUT.DMEM.mem[3]);
        $display("mem[4]  (byte addr 16) = %0d (esperado 20)", UUT.DMEM.mem[4]);
        $display("mem[12] (byte addr 48) = %0d (esperado 30)", UUT.DMEM.mem[12]);
        $display("mem[13] (byte addr 52) = %0d (esperado 40)", UUT.DMEM.mem[13]);
        $display("");

        // ====== TESTE 6 (7 instruções) ======
        repeat (7) @(negedge clock);
        $display("===== TESTE 6 - JUMP (7 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024006)", UUT.REGFILE.registers[25]);
        $display("$t0 ($8)  = %0d (esperado 1, instrução após o jump)", UUT.REGFILE.registers[8]);
        $display("");

        // ====== TESTE 7 (9 instruções) ======
        repeat (9) @(negedge clock);
        $display("===== TESTE 7 - JAL e JR (9 ciclos) =====");
        $display("$t9 ($25) = %0d (esperado 1024007)", UUT.REGFILE.registers[25]);
        $display("$t0 ($8)  = %0d (esperado -4, última addi)", $signed(UUT.REGFILE.registers[8]));
        $display("$ra ($31) = %0d (endereço de retorno do jal)", UUT.REGFILE.registers[31]);
        $display("");

        $display("===== Simulacao finalizada com sucesso =====\n");
        $finish;
    end

    // Dump de ondas (VCD) para análise se necessário
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

endmodule