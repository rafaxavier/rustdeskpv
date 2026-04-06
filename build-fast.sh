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
FEATURES="${BUILD_FEATURES:-linux-pkg-config}"
PROFILE="${BUILD_PROFILE:-local-fast}"

# Paralelismo e otimizações para teste local (Xeon/muitos cores)
JOBS="${BUILD_JOBS:-$(nproc)}"
export CARGO_BUILD_JOBS="$JOBS"

# Para build local rápido: mais codegen-units e sem LTO
export CARGO_PROFILE_RELEASE_CODEGEN_UNITS="${CODEGEN_UNITS:-32}"
export CARGO_PROFILE_RELEASE_LTO="off"

# Linker mais rápido (se disponível)
if command -v mold >/dev/null 2>&1; then
    export RUSTFLAGS="${RUSTFLAGS} -C link-arg=-fuse-ld=mold"
elif command -v ld.lld >/dev/null 2>&1; then
    export RUSTFLAGS="${RUSTFLAGS} -C link-arg=-fuse-ld=lld"
fi

# Cache de compilação (opcional, acelera recompilações)
if command -v sccache >/dev/null 2>&1; then
    export RUSTC_WRAPPER="sccache"
fi

echo "⚙️ Jobs paralelos: $JOBS"
echo "⚙️ Codegen units: ${CARGO_PROFILE_RELEASE_CODEGEN_UNITS}"
echo "⚙️ LTO: ${CARGO_PROFILE_RELEASE_LTO}"
echo "⚙️ Features: ${FEATURES}"
echo "⚙️ Profile: ${PROFILE}"
if [ -n "$RUSTC_WRAPPER" ]; then
    echo "⚙️ Compiler cache: ${RUSTC_WRAPPER}"
fi

# Compilar
echo "📦 Compilando binário (modo release)..."
cargo build --profile "$PROFILE" --bin rustdesk --features "$FEATURES" -j "$JOBS"

# Verificar resultado
BIN_PATH="$CARGO_TARGET_DIR/$PROFILE/rustdesk"
if [ -f "$BIN_PATH" ]; then
    echo ""
    echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
    echo ""
    echo "📍 Binário disponível em:"
    ls -lh "$BIN_PATH"
    echo ""
    echo "🎯 Para testar, execute:"
    echo "   $BIN_PATH"
    echo ""
else
    echo "❌ ERRO: Binário não foi gerado!"
    exit 1
fi
