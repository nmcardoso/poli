#!/bin/bash

# Configurações do projeto
source_folder="src"
source_files="$source_folder/*.cpp"
header_files="$source_folder/*.h"

# Compilação
echo "Compilando projeto..."
g++ $source_files $header_files -I $source_folder -o run
# Para salvar o log: 2> error.log

#Execução
echo "Executando projeto..."
chmod +x run
./run
