#!/bin/bash
# Script para compilar RustDesk com Feature "Trusted Technicians"

set -e

PROJECT_DIR="/home/dodo/Downloads/rustdesk"
INSTALL_DIR="$HOME/.local/bin"

echo "🔨 Iniciando compilação do RustDesk..."
echo "=================================="

# Configurar variáveis
export VCPKG_ROOT=/home/dodo/vcpkg
export PATH=/home/dodo/flutter/bin:$PATH

cd "$PROJECT_DIR"

# Verificar dependências
echo "✓ Verifying dependencies..."
if ! command -v cargo &> /dev/null; then
    echo "❌ Cargo não encontrado. Instale Rust."
    exit 1
fi

# Build release
echo ""
echo "🔨 Compilando binário (Release mode)..."
cargo build --release --bin rustdesk 2>&1 | grep -E "Compiling rustdesk|Finished|error" | head -20

# Verificar resultado
if [ -f "target/release/rustdesk" ]; then
    echo ""
    echo "✅ BUILD COMPLETO!"
    echo ""
    ls -lh target/release/rustdesk
    echo ""
    echo "📍 Localização: $PROJECT_DIR/target/release/rustdesk"
    echo ""
    echo "🚀 Para rodar:"
    echo "   $PROJECT_DIR/target/release/rustdesk"
    echo ""
    echo "📦 Para instalar no sistema:"
    echo "   mkdir -p $INSTALL_DIR"
    echo "   cp target/release/rustdesk $INSTALL_DIR/"
    echo "   rustdesk"
else
    echo "❌ Build falhou. Verificar erros acima."
    exit 1
fi
