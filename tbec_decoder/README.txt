# Requisitos

Antes de continuar a leitura, certifique-se que os caminhos das bibliotecas gpdk estão configurados corretamente. Cada um dos polos possui configurações de caminho diferentes para esta mesma biblioteca, fazendo com que esse projeto não seja facilmente portável entre os polos. É necessário atualizar corretamente o caminho para as bibliotecas gpdk.

Para tal, consulte os comentários deixados no script `run_first.sh` relativos a configuração dos caminhos. Será necessário consultar não só esse script mas também os scripts contidos em `backend/synthesis/scripts/common/path.tcl`,  `backend/synthesis/scripts/multiplier32FP.tcl` e `backend/layout/scripts/common/layout.tcl`. 

Por favor, confira esses arquivos antes de continuar. Caso contrário, ao tentar executar o script `run_first`, erros ocorrerão.


# Script `run_first.sh`

Este script é utilizado para gerenciar e executar várias tarefas relacionadas à síntese e simulação do design `multiplier32FP`. Ele fornece opções para limpar diretórios de trabalho, criar arquivos de teste e executar simulações usando XCELIUM, além de rodar ferramentas de síntese e layout como Genus e Innovus.

## Uso

```sh
./run_first.sh <arg1>
```

### Argumentos

- `-xrun_raw`: Executa a simulação HDL bruta usando XCELIUM.
- `-xrun_compiled`: Executa a simulação do netlist compilado usando XCELIUM.
- `-xrun_sdf`: Executa a simulação com anotação SDF usando XCELIUM.
- `-xrun_sdf_min_max`: Executa a simulação com anotação SDF para condições mínimas e máximas usando XCELIUM.
- `-genus`: Executa a ferramenta de síntese Genus.
- `-innovus`: Executa a ferramenta de colocação e roteamento Innovus.
- `-clear_work`: Limpa os diretórios de trabalho.
- `-touch_work`: Cria arquivos de teste nos diretórios de trabalho.

### Exemplos de uso

#### Executar a síntese lógica
```sh
./run_first.sh -genus
```
#### Executar a síntese física
```sh
./run_first.sh -innovus
```
#### Executar a síntese lógica, utilizar os arquivos SDF para gerar novos VCDs com XCELIUM e executar a síntese física utilizando esses VCDs
```sh
./run_first.sh -genus && ./run_first.sh -xrun_sdf_min_max && ./run_first.sh -innovus
```



## Variáveis de Ambiente

- `DESIGNS`: O nome do design atual (padrão: `multiplier32FP`).
- `USER`: O nome do usuário nesta máquina.
- `PROJECT_DIR`: O diretório de trabalho atual.
- `BACKEND_DIR`: O diretório de backend (`${PROJECT_DIR}/backend`).
- `FRONTEND_DIR`: O diretório de frontend (`${PROJECT_DIR}/frontend`).
- `TECH_DIR`: O diretório de tecnologia (padrão: `/home/tools/cadence/gpdk`).
- `HDL_NAME`: O nome HDL (padrão: `${DESIGNS}`).
- `VLOG_LIST`: A lista de arquivos Verilog para o design.
- `LIB_DIR`: O diretório da biblioteca para arquivos de temporização.
- `LIB_VERILOG_FILES`: O diretório da biblioteca para arquivos Verilog.

## Detalhes do Script

### Limpando Diretórios de Trabalho

```sh
if [ $1 == "-clear_work" ]; então
    rm -r ${PROJECT_DIR}/frontend/work/*
    rm -r ${PROJECT_DIR}/backend/synthesis/work/*
    rm -r ${PROJECT_DIR}/backend/layout/work/*
    cp ${FRONTEND_DIR}/vetor.txt ${FRONTEND_DIR}/work/vetor.txt
fi
```

### Criando Arquivos de Teste

```sh
if [ $1 == "-touch_work" ]; então
    touch ${PROJECT_DIR}/frontend/work/teste.txt
    touch ${PROJECT_DIR}/backend/synthesis/work/teste.txt
    touch ${PROJECT_DIR}/backend/layout/work/teste.txt
fi
```

### Executando Simulação HDL Bruta

```sh
if [ $1 == "-xrun_raw" ]; então
    cd ${PROJECT_DIR}/frontend/work
    xrun -timescale 1ns/10ps -64bit ${FRONTEND_DIR}/${DESIGNS}.sv ${FRONTEND_DIR}/${DESIGNS}_tb.sv -top ${DESIGNS}_tb -access +rwc
fi
```

### Executando Simulação do Netlist Compilado

```sh
if [ $1 == "-xrun_compiled" ]; então
    cd ${PROJECT_DIR}/frontend/work
    xrun -timescale 1ns/10ps -64bit ${LIB_VERILOG_FILES}/slow_vdd1v0_basicCells.v ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}.v ${FRONTEND_DIR}/${DESIGNS}_tb.sv -top ${DESIGNS}_tb -access +rwc
fi
```

### Executando Simulação com Anotação SDF

```sh
if [ $1 == "-xrun_sdf" ]; então
    cd ${PROJECT_DIR}/frontend/work
    xmsdfc -iocondsort -compile ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}_worst.sdf && \
    xrun -timescale 1ns/10ps -mess -64bit -noneg_tchk ${LIB_VERILOG_FILES}/slow_vdd1v0_basicCells.v \
    ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}.v ${FRONTEND_DIR}/${DESIGNS}_tb.sv -top ${DESIGNS}_tb \
    -access +rwc -sdf_cmd_file ${PROJECT_DIR}/frontend/sdf_cmd_file.cmd 
fi
```

### Executando Simulação com Anotação SDF para Condições Mínimas e Máximas

```sh
if [ $1 == "-xrun_sdf_min_max" ]; então
    cd ${PROJECT_DIR}/frontend/work
    ### Executa a simulação com SDF compilado para MIN
    xmsdfc -iocondsort -compile ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}_worst.sdf && \
    xrun -timescale 1ns/10ps -mess -64bit -noneg_tchk ${LIB_VERILOG_FILES}/slow_vdd1v0_basicCells.v \
    ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}.v ${FRONTEND_DIR}/${DESIGNS}_MIN_tb.sv -top ${DESIGNS}_tb \
    -access +rwc -sdf_cmd_file ${PROJECT_DIR}/frontend/sdf_cmd_file.cmd

    sleep 1

    ### Executa a simulação com SDF compilado para MAX
    xmsdfc -iocondsort -compile ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}_worst.sdf && \
    xrun -timescale 1ns/10ps -mess -64bit -noneg_tchk ${LIB_VERILOG_FILES}/slow_vdd1v0_basicCells.v \
    ${PROJECT_DIR}/backend/synthesis/deliverables/${DESIGNS}.v ${FRONTEND_DIR}/${DESIGNS}_MAX_tb.sv -top ${DESIGNS}_tb \
    -access +rwc -sdf_cmd_file ${PROJECT_DIR}/frontend/sdf_cmd_file.cmd
fi
```

### Executando Síntese com Genus

```sh
if [ $1 == "-genus" ]; então
    cd ${PROJECT_DIR}/backend/synthesis/work
    genus -abort_on_error -lic_startup Genus_Synthesis -lic_startup_options Genus_Physical_Opt \
        -log ${BACKEND_DIR}/synthesis/work/genus/genus \
        -overwrite -files ${PROJECT_DIR}/backend/synthesis/scripts/${DESIGNS}.tcl
fi
```

### Executando Colocação e Roteamento com Innovus

```sh
if [ $1 == "-innovus" ]; então
    cd ${PROJECT_DIR}/backend/layout/work
    innovus -stylus -file ${PROJECT_DIR}/backend/layout/scripts/layout.tcl
fi
```

## Notas

- Certifique-se de que as ferramentas necessárias (XCELIUM, Genus, Innovus) estejam instaladas e acessíveis no seu ambiente.
- Modifique o script conforme necessário para atender aos requisitos específicos do seu projeto.
