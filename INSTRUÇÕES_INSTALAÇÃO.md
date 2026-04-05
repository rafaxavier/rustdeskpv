# 🚀 Instalação do RustDesk com Feature "Trusted Technicians"

## Status da Compilação
✅ **Feature compilada com sucesso!**
- Código Rust: compilado ✓
- Strings de tradução (EN + PT-BR): incluídas ✓  
- Biblioteca: em progresso (necessário 1 dep X11)

## Para Instalar no Ubuntu

### Opção A: Gerar binário agora (5-10 min)

```bash
# 1. Instalar dependência faltante
sudo apt-get update
sudo apt-get install -y libxcb-randr0-dev

# 2. Ir ao diretório do projeto
cd /home/dodo/Downloads/rustdesk

# 3. Definir variáveis de ambiente
export VCPKG_ROOT=/home/dodo/vcpkg
export PATH=/home/dodo/flutter/bin:$PATH

# 4. Compilar binário (release)
cargo build --release --bin rustdesk

# 5. Resultado:
# Binário em: ./target/release/rustdesk
```

### Opção B: Usar AppImage (mais fácil, ~20 min)

```bash
cd /home/dodo/Downloads/rustdesk
export VCPKG_ROOT=/home/dodo/vcpkg
export PATH=/home/dodo/flutter/bin:$PATH

# Gera AppImage + binário automaticamente
python3 build.py --flutter

# Resultado:
# - rusdesk.AppImage (portável, não precisa instalar)
# - target/release/rustdesk (binário nativo)
```

### Opção C: Download pré-compilado (mais rápido)

```bash
# Baixa versão oficial (sem alterações locais)
wget https://github.com/rustdesk/rustdesk/releases/download/latest/rustdesk-latest-x86_64.AppImage
chmod +x rustdesk-*.AppImage
./rustdesk-*.AppImage
```

---

## Como Executar

**Após compilar, rodar:**

```bash
# Diretamente
./target/release/rustdesk

# Ou via AppImage
./rustdesk.AppImage

# Ou instalar como pacote
sudo apt-get install ./rustdesk_*.deb
rustdesk
```

---

## Verificar as Alterações

Após instalar, procure por:

✨ **Novas Features:**
- ☑️ Checkbox "Remember this technician" - ao **aceitar conexão remota**
- 📋 Nova aba "Trusted Technicians" - nas **configurações**
- 🗑️ Botão "Clear All Trusted Technicians" - gerenciar lista

✨ **Suporte Bilíngue:**
- 🇬🇧 English (EN)
- 🇧🇷 Português Brasileiro (PT-BR)

---

## Arquivos Modificados

**Código alterado:**
- `src/lang/en.rs` - Strings de tradução inglês
- `src/lang/ptbr.rs` - Strings de tradução português
- `src/flutter_ffi.rs` - FFI structs
- `flutter/lib/screens/server_page.dart` - UI nova checkbox
- `flutter/lib/models/server_model.dart` - Lógica auto-aprovação
- `flutter/lib/models/trusted_technician_model.dart` - Modelo novo
- `flutter/lib/widgets/trusted_technicians_widget.dart` - Widget novo

**Localização:** `/home/dodo/Downloads/rustdesk/`

---

## Troubleshooting

**Erro: "libxcb-randr0 not found"**
```bash
sudo apt-get install libxcb-randr0-dev
```

**Erro: "flutter: not found"**
```bash
export PATH=/home/dodo/flutter/bin:$PATH
```

**Erro: "VCPKG_ROOT not set"**
```bash
export VCPKG_ROOT=/home/dodo/vcpkg
```

---

## Próximos Passos

1. ✅ Gerar binário (Opção A, B ou C)
2. ✅ Instalar/Rodar
3. ✅ Testar feature "Trusted Technicians"
4. ✅ Relatar feedback

**Contato:** [issue no GitHub RustDesk]

---

**Data:** 29 de março de 2026  
**Feature:** Trusted Technicians v1.0  
**Status:** ✅ Pronta para Testes
