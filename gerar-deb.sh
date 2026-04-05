#!/usr/bin/env bash

# Gera .deb do RustDesk (Flutter UI) já com ícone e launcher.
# Uso:
#   ./gerar-deb.sh
#   ./gerar-deb.sh --skip-cargo

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_CARGO=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-cargo)
            SKIP_CARGO=true
            shift
            ;;
        *)
            echo "❌ Opção inválida: $1"
            echo "Uso: ./gerar-deb.sh [--skip-cargo]"
            exit 1
            ;;
    esac
done

cd "$PROJECT_DIR"

echo "� Gerando pacote Flutter do RustDesk (com ícone + atalho)..."

if [[ -f "$HOME/.cargo/env" ]]; then
    # shellcheck disable=SC1090
    . "$HOME/.cargo/env"
fi

resolve_flutter() {
    if command -v flutter >/dev/null 2>&1; then
        command -v flutter
        return 0
    fi

    if [[ -n "${FLUTTER_BIN:-}" && -x "${FLUTTER_BIN}" ]]; then
        echo "$FLUTTER_BIN"
        return 0
    fi

    if [[ -n "${FLUTTER_HOME:-}" && -x "${FLUTTER_HOME}/bin/flutter" ]]; then
        echo "${FLUTTER_HOME}/bin/flutter"
        return 0
    fi

    for candidate in "$HOME/flutter/bin/flutter" "/opt/flutter/bin/flutter"; do
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

for cmd in cargo python3 dpkg-deb; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Dependência não encontrada: $cmd"
        exit 1
    fi
done

if ! FLUTTER_CMD="$(resolve_flutter)"; then
    echo "❌ Flutter não encontrado."
    echo "   Dica: export FLUTTER_BIN=/caminho/para/flutter"
    echo "   ou    export FLUTTER_HOME=/caminho/para/flutter-sdk"
    exit 1
fi

echo "📦 Atualizando dependências Flutter..."
(cd flutter && "$FLUTTER_CMD" pub get)

BUILD_CMD=(python3 build.py --flutter)
if [[ "$SKIP_CARGO" == "true" ]]; then
    BUILD_CMD+=(--skip-cargo)
fi

echo "🔨 Build e empacotamento (.deb)..."
"${BUILD_CMD[@]}"

DEB_FILE="$(ls -1t "$PROJECT_DIR"/rustdesk-*.deb 2>/dev/null | head -1 || true)"

if [[ -z "${DEB_FILE}" ]]; then
    echo "❌ Erro: nenhum arquivo .deb foi criado"
    exit 1
fi

echo "🔍 Validando se o .deb contém ícone e launcher..."
if ! dpkg-deb -c "$DEB_FILE" | grep -q "usr/share/applications/rustdesk.desktop"; then
    echo "❌ Launcher não encontrado no pacote"
    exit 1
fi

if ! dpkg-deb -c "$DEB_FILE" | grep -q "usr/share/icons/hicolor/256x256/apps/rustdesk.png"; then
    echo "❌ Ícone PNG não encontrado no pacote"
    exit 1
fi

echo ""
echo "✅ DEB Flutter criado com sucesso!"
echo "📍 Arquivo: $DEB_FILE"
echo "📏 Tamanho: $(du -h "$DEB_FILE" | cut -f1)"
echo ""
echo "Instalação em outra máquina:"
echo "  sudo apt install ./$(basename "$DEB_FILE")"
