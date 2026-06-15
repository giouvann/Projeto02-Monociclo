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

        // Mantém reset ativo por um ciclo completo de clock (posedge + negedge)
        // e desativa em torno de um negedge, garantindo que, na próxima
        // borda de subida, tanto o PC quanto o regfile já estejam com
        // reset=0 de forma estável (sem corrida entre Reset e RegWrite
        // no mesmo always @(posedge Clock) do regfile).
        @(negedge clock); // t=5  : ainda em reset (PC e regfile zerados na borda t=10... )
        @(posedge clock); // t=10 : última borda com reset=1 (zera tudo)
        @(negedge clock); // t=15 : reset cai aqui, com folga antes da próxima posedge
        reset = 1'b0;

        // A partir da próxima posedge (t=20), PC=0 e reset=0:
        // a instrucao 0 (addi $1,$0,10) e buscada e executada normalmente.

        // Executa por um número suficiente de ciclos para rodar o programa
        // carregado em instruction.list
        repeat (40) @(negedge clock);

        $display("\n===== Estado final dos registradores =====");
        $display("$1  = %0d", UUT.REGFILE.registers[1]);
        $display("$2  = %0d", UUT.REGFILE.registers[2]);
        $display("$3  = %0d", UUT.REGFILE.registers[3]);
        $display("$4  = %0d", UUT.REGFILE.registers[4]);
        $display("$5  = %0d (bin: %b)", UUT.REGFILE.registers[5], UUT.REGFILE.registers[5]);
        $display("$6  = %0d (bin: %b)", UUT.REGFILE.registers[6], UUT.REGFILE.registers[6]);
        $display("$7  = %0d", UUT.REGFILE.registers[7]);
        $display("$8  = %0d", UUT.REGFILE.registers[8]);
        $display("$9  = %0d", UUT.REGFILE.registers[9]);
        $display("$10 = %0d (lw, esperado 30)", UUT.REGFILE.registers[10]);
        $display("$11 = %0d (esperado 0, pulado pelo beq)", UUT.REGFILE.registers[11]);
        $display("$12 = %0d (esperado 0, pulado pelo bne)", UUT.REGFILE.registers[12]);
        $display("$13 = %0d (destino do bne, esperado 55)", UUT.REGFILE.registers[13]);
        $display("$14 = %0d (sub, esperado 10)", UUT.REGFILE.registers[14]);
        $display("$15 = %0d (xor, esperado 30)", UUT.REGFILE.registers[15]);
        $display("$16 = %0d (nor, esperado -31 / bin %b)", $signed(UUT.REGFILE.registers[16]), UUT.REGFILE.registers[16]);
        $display("$17 = %0d (sltu, esperado 1)", UUT.REGFILE.registers[17]);
        $display("$18 = %0d (xori, esperado 245)", UUT.REGFILE.registers[18]);
        $display("$19 = %0d (slti, esperado 1)", UUT.REGFILE.registers[19]);
        $display("$20 = %0d (sltiu, esperado 0)", UUT.REGFILE.registers[20]);
        $display("$21 = %0d (srl, esperado 7)", UUT.REGFILE.registers[21]);
        $display("$22 = %0d (addi -8, esperado -8)", $signed(UUT.REGFILE.registers[22]));
        $display("$23 = %0d (sra, esperado -4)", $signed(UUT.REGFILE.registers[23]));
        $display("$24 = %0d (addi 2, esperado 2)", UUT.REGFILE.registers[24]);
        $display("$25 = %0d (sllv, esperado 120)", UUT.REGFILE.registers[25]);
        $display("$26 = %0d (srlv, esperado 7)", UUT.REGFILE.registers[26]);
        $display("$27 = %0d (srav, esperado -2)", $signed(UUT.REGFILE.registers[27]));
        $display("$28 = %0d (addi 140, esperado 140)", UUT.REGFILE.registers[28]);
        $display("$29 = %0d (esperado 44, via jal=33 depois j=44)", UUT.REGFILE.registers[29]);
        $display("$30 = %0d (destino do jr, esperado 77)", UUT.REGFILE.registers[30]);
        $display("$31 = %0d (jal: PC+8, esperado 152)", UUT.REGFILE.registers[31]);
        $display("mem[0] (resultado do sw) = %0d", UUT.DMEM.mem[0]);

        $display("\nSimulacao finalizada.");
        $finish;
    end

    // Monitoramento ciclo a ciclo
    initial begin
        $display("Tempo\tPC\t\tInstrucao\t\t\t\tRegWrite WriteReg WriteData");
        forever begin
            @(posedge clock);
            #1;
            $display("%0t\t%0d\t%b\t%b\t%0d\t%0d",
                $time, UUT.PC, UUT.instruction,
                UUT.RegWrite, UUT.WriteReg, $signed(UUT.WriteData));
        end
    end

    // Dump de ondas (VCD) para análise em GTKWave
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

endmodule