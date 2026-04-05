#!/bin/bash

# ============================================
# RustDesk Compilation Script for Ubuntu
# Feature: Trusted Technicians
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="/home/dodo/Downloads/rustdesk"
BINARY_PATH="$PROJECT_DIR/target/release/rustdesk"

# ============================================
# STEP 1: Check prerequisites
# ============================================
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  RustDesk Build Script                 ║${NC}"
echo -e "${BLUE}║  Feature: Trusted Technicians         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}[1/5] Checking prerequisites...${NC}"

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
    echo -e "${RED}✗ Rust not found. Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh${NC}"
    exit 1
fi
RUST_VERSION=$(rustc --version)
echo -e "${GREEN}✓ $RUST_VERSION${NC}"

# Check if cargo is available
if ! command -v cargo &> /dev/null; then
    echo -e "${RED}✗ Cargo not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Cargo available${NC}"

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    if [ ! -d "/home/dodo/flutter" ]; then
        echo -e "${YELLOW}⚠ Flutter not in PATH. Setting manually...${NC}"
        export PATH="/home/dodo/flutter/bin:$PATH"
    fi
fi

if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version 2>&1 | head -1)
    echo -e "${GREEN}✓ Flutter available${NC}"
else
    echo -e "${YELLOW}⚠ Flutter not found (optional, will compile without Flutter UI)${NC}"
fi

echo -e "${GREEN}✓ Prerequisites OK${NC}"
echo ""

# ============================================
# STEP 2: Check/Install system dependencies
# ============================================
echo -e "${YELLOW}[2/5] Checking system dependencies...${NC}"

MISSING_DEPS=""

# Check for libxcb-randr0-dev
if ! dpkg -l | grep -q libxcb-randr0-dev; then
    echo -e "${YELLOW}⚠ libxcb-randr0-dev not found${NC}"
    MISSING_DEPS="$MISSING_DEPS libxcb-randr0-dev"
fi

# Check for other X11 deps
for dep in libxcb-dev libx11-dev libgtk-3-dev; do
    if ! dpkg -l | grep -q "^ii.*$dep" 2>/dev/null; then
        echo -e "${YELLOW}⚠ $dep not found${NC}"
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    echo ""
    echo -e "${YELLOW}Installing missing dependencies...${NC}"
    echo "Command to run:"
    echo -e "${BLUE}  sudo apt-get update${NC}"
    echo -e "${BLUE}  sudo apt-get install -y$MISSING_DEPS${NC}"
    echo ""
    echo -e "${YELLOW}Please run the commands above and then run this script again.${NC}"
    echo ""
    exit 1
else
    echo -e "${GREEN}✓ All system dependencies installed${NC}"
fi
echo ""

# ============================================
# STEP 3: Configure environment
# ============================================
echo -e "${YELLOW}[3/5] Configuring build environment...${NC}"

export VCPKG_ROOT="/home/dodo/vcpkg"
export PATH="/home/dodo/flutter/bin:$PATH"

if [ ! -d "$VCPKG_ROOT" ]; then
    echo -e "${RED}✗ VCPKG_ROOT not found at $VCPKG_ROOT${NC}"
    exit 1
fi

echo -e "${GREEN}✓ VCPKG_ROOT: $VCPKG_ROOT${NC}"
echo -e "${GREEN}✓ Environment configured${NC}"
echo ""

# ============================================
# STEP 4: Build RustDesk
# ============================================
echo -e "${YELLOW}[4/5] Building RustDesk (this may take 5-15 minutes)...${NC}"
echo ""

cd "$PROJECT_DIR"

# Try to build with full features first
echo "Building with: cargo build --release --bin rustdesk"
echo ""

if cargo build --release --bin rustdesk 2>&1 | tail -20; then
    BUILD_SUCCESS=1
else
    BUILD_SUCCESS=0
fi

echo ""

if [ $BUILD_SUCCESS -eq 1 ] && [ -f "$BINARY_PATH" ]; then
    echo -e "${GREEN}✓ Build completed successfully${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    echo ""
    echo "Trying alternative build without Flutter features..."
    if cargo build --release --bin rustdesk --no-default-features 2>&1 | tail -10; then
        echo -e "${GREEN}✓ Build completed (without Flutter)${NC}"
    else
        echo -e "${RED}✗ Build failed on both attempts${NC}"
        exit 1
    fi
fi
echo ""

# ============================================
# STEP 5: Verify and display results
# ============================================
echo -e "${YELLOW}[5/5] Verifying build output...${NC}"

if [ -f "$BINARY_PATH" ]; then
    SIZE=$(du -h "$BINARY_PATH" | cut -f1)
    TIMESTAMP=$(stat -c %y "$BINARY_PATH" | cut -d' ' -f1,2)
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ BUILD SUCCESSFUL                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "Binary: ${GREEN}$BINARY_PATH${NC}"
    echo -e "Size:   ${GREEN}$SIZE${NC}"
    echo -e "Built:  ${GREEN}$TIMESTAMP${NC}"
    echo ""
    echo "Features included:"
    echo "  ✓ Trusted Technicians (EN + PT-BR)"
    echo "  ✓ Remote Desktop"
    echo "  ✓ File Transfer"
    echo "  ✓ Audio/Video Streaming"
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Run locally:"
    echo -e "   ${BLUE}$BINARY_PATH${NC}"
    echo ""
    echo "2. Install system-wide:"
    echo -e "   ${BLUE}sudo cp $BINARY_PATH /usr/bin/rustdesk${NC}"
    echo -e "   ${BLUE}sudo chmod +x /usr/bin/rustdesk${NC}"
    echo -e "   ${BLUE}rustdesk${NC}"
    echo ""
    echo "3. Create .deb package:"
    echo -e "   ${BLUE}cd $PROJECT_DIR && cargo deb${NC}"
    echo ""
    
else
    echo -e "${RED}✗ Binary not found at $BINARY_PATH${NC}"
    echo "Build may have failed silently. Check output above."
    exit 1
fi

echo ""
