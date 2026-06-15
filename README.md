# Projeto 02 - Monociclo
**Disciplina:** Arquitetura e Organização de Computadores (2026.1) 

**Instituição:** Universidade Federal Rural de Pernambuco (UFRPE) 

**Professor:** Vítor A. Coutinho 

##  Integrantes do Grupo
* David Fernando de Melo - david.fmelo@ufrpe.br
* Evelin Paula Dionizio da Silva - evelin.dionizio@ufrpe.br
* Giovanna Costa da Silva - giovanna.costa@ufrpe.br
* Miguel Monteiro Alves Paes - miguel.alves@ufrpe.br

##  Descrição do Projeto
Este projeto consiste em implementar uma versão simplificada do núcleo do MIPS monociclo em hardware utilizando uma HDL (hardware description language). Implementado em verilog.

## Estrutura do Projeto

```
.
├── ctrl.v                # Unidade de controle principal do processador
├── d_mem.v               # Memória de dados
├── exten_sinal.v         # Extensor de sinal para instruções do tipo I
├── i_mem.v               # Memória de instruções
├── instruction.list      # Programa carregado na memória de instruções
├── mux2x1_32bits.v       # Multiplexador 2x1 para sinais de 32 bits
├── mux2x1_5bits.v        # Multiplexador 2x1 para sinais de 5 bits
├── pc.v                  # Contador de programa (Program Counter)
├── regfile.v             # Banco de registradores
├── testbench.v           # Ambiente de testes e simulação
├── top_level.v           # Integração de todos os módulos do processador
├── ula.v                 # Unidade Lógica e Aritmética (ULA)
├── ula_ctrl.v            # Unidade de controle da ULA
└── README.md             # Documentação do projeto
```
