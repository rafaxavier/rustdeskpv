#!/bin/bash
# BUILD DEFINITIVO PARA DISTRIBUIÇÃO
# Compila o binário E gera pacote .deb instalável
# Resultado: /HOME/.cache/rustdeskpv-target/debian/rustdesk_*.deb (~40-50MB, ~15-25 min)
# 
# Este script é AUTO-SUFICIENTE: detecta e baixa assets faltantes automaticamente.

set -e

echo "🚀 Iniciando BUILD DEFINITIVO para distribuição..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Configurar ambiente
. "$HOME/.cargo/env"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$HOME/.cache/rustdeskpv-target}"
FEATURES="${BUILD_FEATURES:-linux-pkg-config}"

# ==============================================================================
# PRÉ-CHECAGEM: Validar e preparar assets exigidos pelo cargo-deb
# ==============================================================================
echo "📋 Validando assets necessários para empacotamento..."
echo ""

# 1. Verificar e baixar libsciter-gtk.so
SCITER_PATH="res/libsciter-gtk.so"
if [ ! -f "$SCITER_PATH" ]; then
    echo "⬇️  Baixando libsciter-gtk.so (necessário para empacotamento)..."
    mkdir -p res
    if wget -q -O "$SCITER_PATH" https://raw.githubusercontent.com/c-smile/sciter-sdk/master/bin.lnx/x64/libsciter-gtk.so; then
        chmod 755 "$SCITER_PATH"
        echo "✅ libsciter-gtk.so baixado com sucesso"
    else
        echo "❌ ERRO ao baixar libsciter-gtk.so"
        echo "   Tente manualmente:"
        echo "   wget -O res/libsciter-gtk.so https://raw.githubusercontent.com/c-smile/sciter-sdk/master/bin.lnx/x64/libsciter-gtk.so"
        exit 1
    fi
else
    echo "✅ libsciter-gtk.so já presente"
fi

# 2. Verificar e gerar ícones PNG se faltarem
ICON_128="res/128x128.png"
ICON_256="res/128x128@2x.png"
ICON_SVG="res/scalable.svg"

NEED_ICONS=0
for icon in "$ICON_128" "$ICON_256" "$ICON_SVG"; do
    if [ ! -f "$icon" ]; then
        NEED_ICONS=1
        break
    fi
done

if [ "$NEED_ICONS" = "1" ]; then
    if command -v convert >/dev/null 2>&1; then
        echo "🎨 Gerando ícones PNG (ImageMagick)..."
        convert -size 128x128 xc:blue "$ICON_128" 2>/dev/null || true
        convert -size 256x256 xc:blue "$ICON_256" 2>/dev/null || true
        echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><circle cx="256" cy="256" r="256" fill="blue"/></svg>' > "$ICON_SVG"
        echo "✅ Ícones PNG gerados"
    else
        echo "⚠️  ImageMagick não encontrado; criando ícones mínimos..."
        # Criar ícones PNG mínimos sem ImageMagick (base64 encoded single pixel PNGs)
        printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x80\x00\x00\x00\x80\x08\x02\x00\x00\x00\x19\xdd\xe8\x93\x00\x00\x00\x19tEXtSoftware\x00Adobe ImageReadyq\xc9e<\x00\x00\x00$IDATx\xdab\x00\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\xfb\xfa\x00\x01\x1e\x82\x14\x01\x00\x00\x00\x00IEND\xaeB`\x82' > "$ICON_128"
        printf '\x89PNG\r\n\x1a\n\x00\x00\x01\x00IHDR\x00\x00\x01\x00\x00\x00\x01\x00\x08\x02\x00\x00\x00\x19\xdd\xe8\x93\x00\x00\x00\x19tEXtSoftware\x00Adobe ImageReadyq\xc9e<\x00\x00\x00$IDATx\xdab\x00\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\xfb\xfa\x00\x01\x1e\x82\x14\x01\x00\x00\x00\x00IEND\xaeB`\x82' > "$ICON_256"
        echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><circle cx="256" cy="256" r="256" fill="blue"/></svg>' > "$ICON_SVG"
        echo "✅ Ícones mínimos criados"
    fi
else
    echo "✅ Ícones já presentes"
fi

# 3. Verificar Flutter (comentar asset se não existir)
FLUTTER_LIB_PATH="flutter/build/linux/x64/release/bundle/lib"
CARGO_TOML_FLUTTER_LINE='\["flutter/build/linux/x64/release/bundle/lib/\*\*/\*", "usr/share/rustdesk/lib/", "755"\]'

if [ ! -d "$FLUTTER_LIB_PATH" ]; then
    if grep -q 'flutter/build/linux/x64/release/bundle/lib' Cargo.toml; then
        echo "⚠️  Flutter não compilado para Linux; comentando asset no Cargo.toml..."
        sed -i.bak 's/^\s*\[\s*"flutter\/build\/linux\/x64\/release\/bundle\/lib\/\*\*\/\*"/#    ["flutter\/build\/linux\/x64\/release\/bundle\/lib\/**\/*"/' Cargo.toml
        echo "⚠️  (Descomente quando compilar Flutter)"
    fi
else
    echo "✅ Flutter já compilado"
fi

echo ""
echo "⚙️ Paralelismo explícito para acelerar em máquinas com muitos cores"
# Paralelismo explícito (CPU + RAM) para acelerar sem forçar swap.
CPU_CORES="$(nproc)"
RAM_PER_JOB_MB="${BUILD_RAM_PER_JOB_MB:-1200}"
RAM_RESERVE_MB="${BUILD_RAM_RESERVE_MB:-2048}"

MEM_TOTAL_KB="$(awk '/^MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
MEM_TOTAL_MB="$((MEM_TOTAL_KB / 1024))"
MEM_USABLE_MB="$((MEM_TOTAL_MB - RAM_RESERVE_MB))"
if [ "$MEM_USABLE_MB" -lt "$RAM_PER_JOB_MB" ]; then
    RAM_BASED_JOBS=1
else
    RAM_BASED_JOBS="$((MEM_USABLE_MB / RAM_PER_JOB_MB))"
fi

AUTO_JOBS="$CPU_CORES"
if [ "$RAM_BASED_JOBS" -lt "$AUTO_JOBS" ]; then
    AUTO_JOBS="$RAM_BASED_JOBS"
fi
if [ "$AUTO_JOBS" -lt 1 ]; then
    AUTO_JOBS=1
fi

JOBS="${BUILD_JOBS:-$AUTO_JOBS}"
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
echo "⚙️ RAM total: ${MEM_TOTAL_MB}MB (usando ${RAM_BASED_JOBS} jobs baseado em RAM)"
if [ -n "$RUSTC_WRAPPER" ]; then
    echo "⚙️ Compiler cache: ${RUSTC_WRAPPER}"
fi
if [ "${FAST_FINAL:-0}" = "1" ]; then
    echo "⚙️ FAST_FINAL=1 (LTO=${CARGO_PROFILE_RELEASE_LTO}, codegen-units=${CARGO_PROFILE_RELEASE_CODEGEN_UNITS})"
fi
echo ""

# Compilar binário primeiro
echo "📦 Compilando binário (modo release)..."
BUILD_START_EPOCH="$(date +%s)"
cargo build --release --bin rustdesk --features "$FEATURES" -j "$JOBS"
echo ""

# Segurança extra: só usa --no-build se o binário release estiver presente e atualizado
BIN_PATH="$CARGO_TARGET_DIR/release/rustdesk"
DEB_NO_BUILD="${DEB_NO_BUILD:-1}"
if [ "$DEB_NO_BUILD" = "1" ]; then
    if [ ! -x "$BIN_PATH" ]; then
        echo "⚠️ Binário release não encontrado; forçando rebuild no cargo-deb..."
        DEB_NO_BUILD=0
    else
        BIN_MTIME="$(stat -c %Y "$BIN_PATH" 2>/dev/null || echo 0)"
        if [ "$BIN_MTIME" -lt "$BUILD_START_EPOCH" ]; then
            echo "⚠️ Binário parece mais antigo; forçando rebuild no cargo-deb..."
            DEB_NO_BUILD=0
        fi
    fi
fi

# Gerar pacote .deb
echo "📦 Gerando pacote .deb..."
if [ "$DEB_NO_BUILD" = "1" ]; then
    cargo deb --profile release --features "$FEATURES" --no-build
else
    cargo deb --profile release --features "$FEATURES"
fi

# Verificar resultado
echo ""
DEB_FILE=$(ls -1t "$CARGO_TARGET_DIR/debian/rustdesk_"*.deb 2>/dev/null | head -1)
if [ -n "$DEB_FILE" ]; then
    echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
    echo ""
    echo "📍 Pacote .deb gerado:"
    ls -lh "$DEB_FILE"
    echo ""
    echo "🎯 Para instalar, execute:"
    echo "   sudo dpkg -i $DEB_FILE"
    echo ""
    echo "📌 Próximas vezes: O script já terá os assets; apenas rode o build novamente."
    echo ""
else
    echo "❌ ERRO: Pacote .deb não foi gerado!"
    echo "   Verifique os erros acima e tente novamente."
    exit 1
fi
