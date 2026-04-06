#!/bin/bash
# BUILD DEFINITIVO PARA DISTRIBUIÇÃO
# Compila o binário E gera pacote .deb instalável
# Resultado: /home/rxn/.cache/rustdeskpv-target/debian/rustdesk_*.deb (~40-50MB, ~15-25 min)

set -e

echo "🚀 Iniciando BUILD DEFINITIVO para distribuição..."
echo ""

cd /home/rxn/projetos/rustdeskpv

# Configurar ambiente
. "$HOME/.cargo/env"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
export CARGO_TARGET_DIR="$HOME/.cache/rustdeskpv-target"

# Compilar binário primeiro
echo "📦 Compilando binário (modo release)..."
cargo build --release --features linux-pkg-config

# Gerar pacote .deb
echo "📦 Gerando pacote .deb..."
cargo deb --profile release --features linux-pkg-config

# Verificar resultado
DEB_FILE=$(ls -1t "$CARGO_TARGET_DIR/debian/rustdesk_"*.deb 2>/dev/null | head -1)
if [ -n "$DEB_FILE" ]; then
    echo ""
    echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
    echo ""
    echo "📍 Pacote .deb disponível em:"
    ls -lh "$DEB_FILE"
    echo ""
    echo "🎯 Para instalar, execute:"
    echo "   sudo dpkg -i $DEB_FILE"
    echo ""
else
    echo "❌ ERRO: Pacote .deb não foi gerado!"
    exit 1
fi
