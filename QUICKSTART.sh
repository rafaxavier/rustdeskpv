#!/bin/bash
# Quick Start - Execute isto agora para compilar RustDesk com Trusted Technicians
# 
# Uso: bash QUICKSTART.sh
# 
# Este script:
# 1. Verifica pré-requisitos
# 2. Instala dependências faltantes (com sua aprovação)
# 3. Compila o binário
# 4. Mostra como instalar

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$PWD"

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║     RustDesk with Trusted Technicians QUICK START    ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Preflight checks
echo -e "${YELLOW}[STEP 1] Running preflight checks...${NC}"
echo ""

if ! bash preflight.sh; then
    echo ""
    echo -e "${YELLOW}Some prerequisites missing. Installing...${NC}"
    echo ""
    
    echo -e "${BLUE}Installing system dependencies...${NC}"
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y \
        libxcb-randr0-dev \
        libxcb-dev \
        libx11-dev \
        libgtk-3-dev \
        libpulse-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev > /dev/null 2>&1
    
    echo -e "${GREEN}✓ Dependencies installed${NC}"
    echo ""
fi

# Step 2: Build
echo -e "${YELLOW}[STEP 2] Building RustDesk...${NC}"
echo "This may take 10-15 minutes. Grab a coffee ☕"
echo ""

bash build.sh

if [ ! -f "$PROJECT_DIR/target/release/rustdesk" ]; then
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           ✓ BUILD SUCCESSFUL                         ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

BINARY_PATH="$PROJECT_DIR/target/release/rustdesk"
SIZE=$(du -h "$BINARY_PATH" | cut -f1)

echo "Binary created:"
echo -e "  Location: ${CYAN}$BINARY_PATH${NC}"
echo -e "  Size: ${CYAN}$SIZE${NC}"
echo ""

# Step 3: Installation options
echo -e "${YELLOW}[STEP 3] Installation Options${NC}"
echo ""
echo "Choose how to install:"
echo ""
echo "  ${BLUE}1)${NC} Run immediately (no installation):"
echo "     ${CYAN}$BINARY_PATH${NC}"
echo ""
echo "  ${BLUE}2)${NC} Install to /usr/bin (system-wide):"
echo "     ${CYAN}sudo cp $BINARY_PATH /usr/bin/rustdesk${NC}"
echo "     ${CYAN}sudo chmod +x /usr/bin/rustdesk${NC}"
echo "     ${CYAN}rustdesk${NC}"
echo ""
echo "  ${BLUE}3)${NC} Create .deb package (for distribution):"
echo "     ${CYAN}cd $PROJECT_DIR${NC}"
echo "     ${CYAN}cargo deb${NC}"
echo ""

# Step 4: Verify feature
echo ""
echo -e "${YELLOW}[STEP 4] Verifying Feature${NC}"
echo ""
echo "After running RustDesk, check for 'Trusted Technicians':"
echo "  Settings → Security → Trusted Technicians"
echo ""
echo "You should see:"
echo "  ✓ Add Trusted Technician"
echo "  ✓ Remove Technician"
echo "  ✓ Clear All Trusted Technicians"
echo ""

# Step 5: Display quick commands
echo -e "${YELLOW}[STEP 5] Quick Reference${NC}"
echo ""
echo "Start RustDesk now:"
echo -e "  ${CYAN}$BINARY_PATH${NC}"
echo ""
echo "Install for all users:"
echo -e "  ${CYAN}sudo cp $BINARY_PATH /usr/bin/rustdesk && rustdesk${NC}"
echo ""
echo "View build logs:"
echo -e "  ${CYAN}cargo build --release --bin rustdesk 2>&1 | tail -50${NC}"
echo ""
echo "Clean rebuild (fresh):"
echo -e "  ${CYAN}cargo clean && bash build.sh${NC}"
echo ""

echo -e "${GREEN}✓ Complete!${NC}"
echo ""
echo "Documentation: Read COMECE_AQUI.md for more details"
echo ""
