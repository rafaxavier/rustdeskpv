#!/bin/bash

# Script para instalar RustDesk com feature Técnicos de Confiança

set -e

echo "🚀 Instalando RustDesk com feature 'Técnicos de Confiança'..."
echo ""

# Remover versão anterior
echo "🔄 Removendo versão anterior (se houver)..."
sudo dpkg -r rustdesk 2>/dev/null || echo "   ✓ Nenhuma versão anterior"

echo ""

# Instalar nova versão
echo "📦 Instalando novo pacote..."
sudo dpkg -i /home/rxn/.cache/rustdeskpv-target/debian/rustdesk_1.4.6-1_amd64.deb

echo ""
echo "✅ INSTALAÇÃO CONCLUÍDA!"
echo ""
echo "🎯 Para iniciar o RustDesk, execute:"
echo "   rustdesk"
echo ""
echo "📝 Ou acesse via systemctl:"
echo "   sudo systemctl start rustdesk"
echo "   sudo systemctl status rustdesk"
echo ""
echo "🧪 Teste a Feature de 'Técnicos de Confiança':"
echo "   1. Conecte remotamente"
echo "   2. Você verá: ☐ Remember this technician"
echo "   3. Marque a checkbox"
echo "   4. Clique em 'Accept'"
echo "   5. Na próxima conexão: acesso automático!"
echo ""
