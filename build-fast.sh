#!/bin/bash
# BUILD RÁPIDO PARA TESTES
# Compila apenas o binário executável (sem empacotamento)
# Resultado: /home/rxn/.cache/rustdeskpv-target/release/rustdesk (~30MB, ~10-20 min)

set -e

echo "🚀 Iniciando BUILD RÁPIDO para testes..."
echo ""

cd /home/rxn/projetos/rustdeskpv

# Configurar ambiente
. "$HOME/.cargo/env"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
export CARGO_TARGET_DIR="$HOME/.cache/rustdeskpv-target"

# Compilar
echo "📦 Compilando binário (modo release)..."
cargo build --release --features flutter,linux-pkg-config

# Verificar resultado
if [ -f "$CARGO_TARGET_DIR/release/rustdesk" ]; then
    echo ""
    echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
    echo ""
    echo "📍 Binário disponível em:"
    ls -lh "$CARGO_TARGET_DIR/release/rustdesk"
    echo ""
    echo "🎯 Para testar, execute:"
    echo "   /home/rxn/.cache/rustdeskpv-target/release/rustdesk"
    echo ""
else
    echo "❌ ERRO: Binário não foi gerado!"
    exit 1
fi
