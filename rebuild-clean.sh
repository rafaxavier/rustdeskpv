#!/bin/bash
# 🔥 SCRIPT DE REBUILD COMPLETO - Limpa cache e recompila tudo

set -e

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║     🔧 REBUILD COMPLETO - Limpando Cache e Recompilando    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/home/rxn/projetos/rustdeskpv"
CACHE_DIR="$HOME/.cache/rustdeskpv-target"

# Passo 1: Verificar se estamos no diretório correto
echo "📁 Verificando diretório do projeto..."
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Erro: Diretório $PROJECT_DIR não encontrado"
    exit 1
fi
cd "$PROJECT_DIR"
echo "✅ Diretório correto: $(pwd)"
echo ""

# Passo 2: Limpar cargo cache
echo "🗑️  Passo 1: Limpando cargo cache..."
echo "   Comando: cargo clean"
cargo clean
echo "✅ Cargo cache limpo"
echo ""

# Passo 3: Limpar cache custom
echo "🗑️  Passo 2: Limpando cache customizado ($CACHE_DIR)..."
if [ -d "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"
    echo "✅ Cache customizado removido"
else
    echo "ℹ️  Cache customizado não existe (normal)"
fi
echo ""

# Passo 4: Atualizar Rust
echo "🔄 Passo 3: Atualizando Rust (recomendado)..."
rustup update stable 2>&1 | tail -3
echo "✅ Rust atualizado"
echo ""

# Passo 5: Executar build-final.sh
echo "🚀 Passo 4: Iniciando compilação completa..."
echo "   Tempo estimado: 15-35 minutos (depende do computador)"
echo ""
echo "⏱️  INICIANDO BUILD..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

./build-final.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ BUILD CONCLUÍDO COM SUCESSO!"
echo ""

# Passo 6: Informar próximos passos
DEB_FILE=$(ls -1t "$CACHE_DIR/debian/rustdesk_"*.deb 2>/dev/null | head -1)

if [ -n "$DEB_FILE" ]; then
    echo "📦 Arquivo .deb gerado:"
    ls -lh "$DEB_FILE"
    echo ""
    echo "🎯 Próximos passos:"
    echo "   1. Remover versão antiga:"
    echo "      sudo apt remove -y rustdesk"
    echo ""
    echo "   2. Instalar versão nova:"
    echo "      sudo dpkg -i $DEB_FILE"
    echo ""
    echo "   3. Testar:"
    echo "      rustdesk --listen"
    echo ""
    echo "   4. Marque: ☑ Ocultar diálogo de conexão"
    echo "   5. Técnico conecta → Sem diálogo! ✅"
else
    echo "❌ Erro: Arquivo .deb não foi gerado"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Tudo pronto! Execute os próximos passos acima. 🚀"
echo "═══════════════════════════════════════════════════════════════"
