#!/bin/bash
# Script de build com incremento automático de versão

set -e

PROJECT_DIR="/home/rxn/projetos/rustdeskpv"
cd "$PROJECT_DIR"

# Incrementar versão
CURRENT_VERSION=$(grep '^version = ' Cargo.toml | sed 's/version = "\(.*\)"/\1/')
MAJOR_MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f1-2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR_MINOR.$NEW_PATCH"

echo "========================================="
echo "📦 Build RustDesk PV"
echo "========================================="
echo "Versão atual: $CURRENT_VERSION"
echo "Nova versão: $NEW_VERSION"
echo "========================================="

# Atualizar Cargo.toml
sed -i "s/^version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" Cargo.toml

# Git commit
git add Cargo.toml
git commit -m "chore: versão $NEW_VERSION"

# Compilar
echo ""
echo "🔨 Compilando..."
. "$HOME/.cargo/env"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
export CARGO_TARGET_DIR="$HOME/.cache/rustdeskpv-target"

cargo build --release --bin rustdesk --features linux-pkg-config

# Gerar .deb
echo ""
echo "📦 Gerando pacote .deb..."
rm -rf "$CARGO_TARGET_DIR/debian"
cargo deb --profile release --features linux-pkg-config

DEB=$(ls -1t "$CARGO_TARGET_DIR/debian/rustdesk_*.deb" | head -1)

echo ""
echo "========================================="
echo "✅ Build concluído com sucesso!"
echo "========================================="
echo "Versão: $NEW_VERSION"
echo "Pacote: $DEB"
echo "Tamanho: $(ls -lh "$DEB" | awk '{print $5}')"
echo "========================================="
echo ""
echo "Para instalar, execute:"
echo "sudo dpkg -i $DEB"
