#!/bin/bash

# ============================================
# RustDesk DEB Package Builder - Simples
# Seguro para o seu Ubuntu
# ============================================

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🔨 Compilando RustDesk..."
echo "⏳ Isso vai levar 10-30 minutos na primeira vez..."
echo ""

# Carregar Rust
. "$HOME/.cargo/env"

# Build release
cargo build --release --bin rustdesk

echo ""
echo "✓ Build concluído!"
echo ""
echo "📦 Próximos passos:"
echo ""
echo "1. Para criar um DEB pacote, execute:"
echo "   cargo install cargo-deb"
echo "   cargo deb --release"
echo ""
echo "2. O binário compilado está em:"
echo "   target/release/rustdesk"
echo ""
echo "3. Para usar localmente:"
echo "   ./target/release/rustdesk"
echo ""
echo "4. Para instalar no sistema:"
echo "   sudo cp target/release/rustdesk /usr/local/bin/"
echo "   rustdesk"
