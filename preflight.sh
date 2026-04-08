#!/bin/bash
# PREFLIGHT CHECK - Validar e preparar ambiente para build
# Execute este script ANTES de rodar build-final.sh
# ./preflight.sh

set -e

echo "🔍 PREFLIGHT CHECK - Validando ambiente para build do RustDesk..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
MISSING=0
WARNINGS=0

# ==============================================================================
# Função auxiliar para imprimir status
# ==============================================================================
check_status() {
    local name="$1"
    local status="$2"
    local detail="${3:-}"
    
    if [ "$status" = "OK" ]; then
        echo -e "  ${GREEN}✅${NC} $name"
    elif [ "$status" = "WARN" ]; then
        echo -e "  ${YELLOW}⚠️ ${NC} $name: $detail"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "  ${RED}❌${NC} $name: $detail"
        MISSING=$((MISSING + 1))
    fi
}

# ==============================================================================
# 1. VERIFICAR RUST
# ==============================================================================
echo "📦 Verificando Rust..."
if command -v rustc >/dev/null 2>&1; then
    RUST_VERSION=$(rustc --version)
    check_status "Rust" "OK" 
    echo "      $RUST_VERSION"
else
    check_status "Rust" "FAIL" "não instalado"
fi

if command -v cargo >/dev/null 2>&1; then
    check_status "Cargo" "OK"
else
    check_status "Cargo" "FAIL" "não instalado"
fi

echo ""

# ==============================================================================
# 2. VERIFICAR DEPENDÊNCIAS DO SISTEMA
# ==============================================================================
echo "🔧 Verificando dependências do sistema..."

DEPS_REQUIRED=(
    "build-essential:gcc"
    "pkg-config:pkg-config"
    "libgtk-3-dev:gtk-3"
    "libssl-dev:openssl"
    "libxcb-randr0-dev:xcb-randr"
    "libxfixes-dev:xfixes"
    "libxcb-shape0-dev:xcb-shape"
    "libxcb-xfixes0-dev:xcb-xfixes"
    "libasound2-dev:asound"
)

MISSING_PACKAGES=()

for dep_entry in "${DEPS_REQUIRED[@]}"; do
    IFS=':' read -r package binary <<< "$dep_entry"
    
    if command -v "$binary" >/dev/null 2>&1 || dpkg -l | grep -q "^ii  $package"; then
        check_status "$package" "OK"
    else
        check_status "$package" "FAIL" "não instalado"
        MISSING_PACKAGES+=("$package")
    fi
done

echo ""

# ==============================================================================
# 3. VERIFICAR FERRAMENTAS OPCIONAIS
# ==============================================================================
echo "🛠️  Verificando ferramentas opcionais..."

if command -v wget >/dev/null 2>&1; then
    check_status "wget" "OK"
else
    check_status "wget" "WARN" "necessário para baixar assets"
    MISSING_PACKAGES+=("wget")
fi

if command -v convert >/dev/null 2>&1; then
    check_status "ImageMagick" "OK"
else
    check_status "ImageMagick" "WARN" "opcional (gera ícones melhorados)"
fi

echo ""

# ==============================================================================
# 4. VERIFICAR PERMISSÕES E DIRETÓRIOS
# ==============================================================================
echo "📁 Verificando permissões e diretórios..."

if [ -w "$(pwd)" ]; then
    check_status "Permissão de escrita (repo)" "OK"
else
    check_status "Permissão de escrita (repo)" "FAIL" "sem permissão"
fi

if [ -d "$HOME/.cargo" ]; then
    check_status "Diretório Cargo" "OK"
else
    check_status "Diretório Cargo" "WARN" "será criado durante build"
fi

echo ""

# ==============================================================================
# 5. INSTALAR DEPENDÊNCIAS FALTANDO (se necessário)
# ==============================================================================
if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo "📥 Pacotes faltando: ${MISSING_PACKAGES[*]}"
    echo ""
    echo "Deseja instalar automaticamente? (requer sudo)"
    read -p "Instalar agora? (s/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "🔐 Instalando pacotes com apt-get..."
        echo ""
        sudo apt-get update
        sudo apt-get install -y "${MISSING_PACKAGES[@]}"
        echo ""
        echo "✅ Pacotes instalados com sucesso"
    else
        echo "⚠️  Pulando instalação. Você pode instalar manualmente depois com:"
        echo "   sudo apt-get install -y ${MISSING_PACKAGES[*]}"
        WARNINGS=$((WARNINGS + 1))
    fi
    echo ""
fi

# ==============================================================================
# 6. RESUMO FINAL
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMO DO PREFLIGHT CHECK"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$MISSING" -eq 0 ]; then
    echo -e "${GREEN}✅ AMBIENTE PRONTO PARA BUILD!${NC}"
    echo ""
    echo "Próximo passo:"
    echo "  ./build-final.sh"
    echo ""
    exit 0
else
    echo -e "${RED}❌ AMBIENTE COM PROBLEMAS${NC}"
    echo ""
    echo "Problemas encontrados: $MISSING"
    echo "Avisos: $WARNINGS"
    echo ""
    echo "Resolva os problemas acima e tente novamente."
    echo ""
    
    if [ "$MISSING" -gt 0 ]; then
        echo "PROBLEMAS CRÍTICOS (impedem build):"
        echo "  - Instale as dependências faltando com apt-get"
        echo "  - Ou instale Rust com: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        echo ""
    fi
    
    exit 1
fi
