#!/bin/bash

# ============================================
# RustDesk Build Script - DEB Package Creator
# SEGURO: Não modifica o sistema operacional
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/target/release"
DEB_OUTPUT="$BUILD_DIR/rustdesk-*.deb"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RustDesk DEB Builder (SEGURO)        ║${NC}"
echo -e "${BLUE}║  Sem modificações ao SO               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# STEP 1: Carregar ambiente Rust
# ============================================
echo -e "${YELLOW}[1/4] Carregando Rust...${NC}"
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
else
    echo -e "${RED}✗ Rust não encontrado em $HOME/.cargo/env${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Rust: $(rustc --version)${NC}"

# ============================================
# STEP 2: Instalar cargo-deb (apenas na home do usuário)
# ============================================
echo -e "${YELLOW}[2/4] Verificando cargo-deb...${NC}"
if ! cargo deb --version &>/dev/null; then
    echo -e "${YELLOW}⚠ Instalando cargo-deb na sua home...${NC}"
    cargo install cargo-deb 2>&1 | tail -3
    echo -e "${GREEN}✓ cargo-deb instalado${NC}"
else
    echo -e "${GREEN}✓ cargo-deb já disponível${NC}"
fi

# ============================================
# STEP 3: Build Release
# ============================================
echo -e "${YELLOW}[3/4] Compilando RustDesk em Release...${NC}"
cd "$PROJECT_DIR"
cargo build --release --bin rustdesk 2>&1 | tail -10
echo -e "${GREEN}✓ Compilação concluída${NC}"

# ============================================
# STEP 4: Gerar DEB
# ============================================
echo -e "${YELLOW}[4/4] Gerando pacote .deb...${NC}"
cd "$PROJECT_DIR"

# Verificar se Cargo.toml tem config para deb
if ! grep -q "\[package.metadata.deb\]" Cargo.toml; then
    echo -e "${YELLOW}⚠ Adicionando configuração DEB ao Cargo.toml...${NC}"
    cat >> Cargo.toml << 'EOF'

[package.metadata.deb]
maintainer = "RustDesk Team <info@rustdesk.com>"
copyright = "2024, RustDesk"
license-file = ["LICENCE", "4"]
extended-description = "RustDesk - Remote desktop software"
EOF
fi

cargo deb --release 2>&1 | tail -5

# ============================================
# RESULT
# ============================================
if [ -f "$(ls $DEB_OUTPUT 2>/dev/null | head -1)" ]; then
    DEB_FILE=$(ls -1 $DEB_OUTPUT 2>/dev/null | head -1)
    DEB_SIZE=$(du -h "$DEB_FILE" | cut -f1)
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ DEB Criado com Sucesso!            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Arquivo: $(basename $DEB_FILE)${NC}"
    echo -e "${GREEN}Tamanho: $DEB_SIZE${NC}"
    echo -e "${GREEN}Localização: $DEB_FILE${NC}"
    echo ""
    echo -e "${BLUE}Como instalar em suas máquinas:${NC}"
    echo "  sudo apt install $DEB_FILE"
    echo ""
else
    echo -e "${RED}✗ Erro ao criar DEB. Verifique o build.${NC}"
    exit 1
fi
