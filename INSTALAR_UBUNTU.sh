#!/bin/bash
# Script para compilar e instalar RustDesk com Trusted Technicians no Ubuntu
# Uso: ./INSTALAR_UBUNTU.sh

set -e

echo "=============================================="
echo "RustDesk Build & Install Script"
echo "=============================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Instalar dependências do sistema
echo -e "${YELLOW}[1/4] Instalando dependências do sistema...${NC}"
sudo apt-get update
sudo apt-get install -y \
    libxcb-randr0-dev \
    libxcb-dev \
    libx11-dev \
    libxrandr-dev \
    libgtk-3-dev \
    libpulse-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev 2>&1 | tail -5

echo -e "${GREEN}✓ Dependências instaladas${NC}"
echo ""

# 2. Configurar variáveis de ambiente
echo -e "${YELLOW}[2/4] Configurando ambiente de build...${NC}"
export VCPKG_ROOT="/home/dodo/vcpkg"
export PATH="/home/dodo/flutter/bin:$PATH"
export RUSTFLAGS="-C link-arg=-fuse-ld=lld"
echo -e "${GREEN}✓ Variáveis configuradas${NC}"
echo ""

# 3. Compilar binário RustDesk
echo -e "${YELLOW}[3/4] Compilando RustDesk (isso pode levar 5-15 minutos)...${NC}"
cd /home/dodo/Downloads/rustdesk
cargo build --release --bin rustdesk 2>&1 | tail -20

if [ ! -f "target/release/rustdesk" ]; then
    echo -e "${RED}✗ Erro: Compilação falhou${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Compilação concluída${NC}"
echo ""

# 4. Criar AppImage ou instalar localmente
echo -e "${YELLOW}[4/4] Preparando instalável...${NC}"

BINARY="/home/dodo/Downloads/rustdesk/target/release/rustdesk"
SIZE=$(du -h "$BINARY" | cut -f1)

echo -e "${GREEN}✓ Binário pronto!${NC}"
echo ""
echo "=============================================="
echo "RESULTADO"
echo "=============================================="
echo ""
echo -e "Localização: ${GREEN}$BINARY${NC}"
echo "Tamanho: $SIZE"
echo ""
echo "Para executar:"
echo "  $BINARY"
echo ""
echo "Para instalar no sistema:"
echo "  sudo cp $BINARY /usr/local/bin/"
echo "  sudo chmod +x /usr/local/bin/rustdesk"
echo ""
echo "Depois execute:"
echo "  rustdesk"
echo ""
