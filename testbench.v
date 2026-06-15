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
 
        // Mantém reset ativo durante o primeiro ciclo de clock para zerar
        // o banco de registradores
        @(negedge clock);
        @(negedge clock);
        reset = 1'b0;
 
        // Executa por um número suficiente de ciclos para rodar o programa
        // carregado em instruction.list
        repeat (20) @(negedge clock);
 
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
        $display("$10 = %0d (esperado 0, pulado pelo beq)", UUT.REGFILE.registers[10]);
        $display("$11 = %0d", UUT.REGFILE.registers[11]);
        $display("$12 = %0d (esperado 0, pulado pelo bne)", UUT.REGFILE.registers[12]);
        $display("$13 = %0d", UUT.REGFILE.registers[13]);
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