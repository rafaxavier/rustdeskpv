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
FEATURES="${BUILD_FEATURES:-linux-pkg-config}"

# Paralelismo explícito para acelerar em máquinas com muitos cores
JOBS="${BUILD_JOBS:-$(nproc)}"
export CARGO_BUILD_JOBS="$JOBS"

# Cache de compilação (opcional, acelera recompilações)
if command -v sccache >/dev/null 2>&1; then
    export RUSTC_WRAPPER="sccache"
fi

# Modo final rápido opcional (para testes internos de pacote)
# Use FAST_FINAL=1 para reduzir bastante o tempo de build do release.
if [ "${FAST_FINAL:-0}" = "1" ]; then
    export CARGO_PROFILE_RELEASE_LTO="off"
    export CARGO_PROFILE_RELEASE_CODEGEN_UNITS="${RELEASE_CODEGEN_UNITS:-32}"
fi

echo "⚙️ Jobs paralelos: $JOBS"
echo "⚙️ Features: ${FEATURES}"
if [ -n "$RUSTC_WRAPPER" ]; then
    echo "⚙️ Compiler cache: ${RUSTC_WRAPPER}"
fi
if [ "${FAST_FINAL:-0}" = "1" ]; then
    echo "⚙️ FAST_FINAL=1 (LTO=${CARGO_PROFILE_RELEASE_LTO}, codegen-units=${CARGO_PROFILE_RELEASE_CODEGEN_UNITS})"
fi

# Compilar binário primeiro
echo "📦 Compilando binário (modo release)..."
cargo build --release --bin rustdesk --features "$FEATURES" -j "$JOBS"

# Gerar pacote .deb
# NOTA: cargo-deb não aceita -j flag, usa CARGO_BUILD_JOBS já configurado
echo "📦 Gerando pacote .deb..."
cargo deb --profile release --features "$FEATURES"

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
