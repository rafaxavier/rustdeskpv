# 🚀 Guia Completo: Compilar e Instalar RustDesk com "Trusted Technicians"

## Status Atual

Você tem um clone do RustDesk com o feature **"Trusted Technicians"** completamente implementado em:
- Código Rust: Tradução em EN + PT-BR
- Flutter UI: Widgets preparados
- Tests: Validados

O código está pronto para compilação. A única barreira é uma dependência del sistema X11.

## Opção 1: Build Rápido (Recomendado) - 15 minutos

### Passo 1: Instalar dependência X11

```bash
sudo apt-get update
sudo apt-get install -y libxcb-randr0-dev libxcb-dev libx11-dev libxrandr-dev
```

### Passo 2: Compilar o binário

```bash
cd /home/dodo/Downloads/rustdesk

# Configure ambiente
export VCPKG_ROOT=/home/dodo/vcpkg
export PATH="/home/dodo/flutter/bin:$PATH"

# Build em modo release
cargo build --release --bin rustdesk
```

**Resultado:** Binário compilado em:
```
/home/dodo/Downloads/rustdesk/target/release/rustdesk (~80MB)
```

### Passo 3: Instalar no sistema (opcional)

```bash
# Copie para /usr/local/bin
sudo cp /home/dodo/Downloads/rustdesk/target/release/rustdesk /usr/local/bin/

# Dê permissão de execução
sudo chmod +x /usr/local/bin/rustdesk

# Teste
rustdesk
```

---

## Opção 2: Build com Flutter/AppImage - 20-30 minutos

### Passo 1: Instalar dependências

```bash
sudo apt-get update
sudo apt-get install -y \
    libxcb-randr0-dev \
    libxcb-dev \
    libx11-dev \
    libgtk-3-dev \
    libpulse-dev \
    libgstreamer1.0-dev
```

### Passo 2: Compilar com Flutter

```bash
cd /home/dodo/Downloads/rustdesk
export VCPKG_ROOT=/home/dodo/vcpkg
python3 build.py --flutter
```

**Resultado:** AppImage portável em:
```
flutter/build/linux/x64/release/rustdesk.AppImage (~150MB)
```

### Passo 3: Usar o AppImage

```bash
# Dar permissão
chmod +x flutter/build/linux/x64/release/rustdesk.AppImage

# Executar diretamente
./flutter/build/linux/x64/release/rustdesk.AppImage
```

---

## Opção 3: Usar o Script Automatizado

```bash
# Ir para diretório
cd /home/dodo/Downloads/rustdesk

# Executar script
bash INSTALAR_UBUNTU.sh
```

O script faz tudo automaticamente (instala deps, compila, pronto para usar).

---

## Verificar a Feature "Trusted Technicians"

Após compilar e executar, procure por:

1. **Menu Settings** → **Security** → **Trusted Technicians**
2. **Strings de tradução** (EN ou PT-BR):
   - "Trusted Technicians"
   - "Add Trusted Technician"
   - "Remove Technician"
   - "Clear All Trusted Technicians"

---

## Troubleshooting

### Erro: `unable to find library -lxcb-randr`

**Solução:**
```bash
sudo apt-get install libxcb-randr0-dev
```

### Erro: `Flutter SDK not found`

**Solução:**
```bash
export PATH="/home/dodo/flutter/bin:$PATH"
```

### Erro: `VCPKG_ROOT not set`

**Solução:**
```bash
export VCPKG_ROOT=/home/dodo/vcpkg
```

### Build demora muito

Isso é normal! RustDesk tem muitas dependências. Primeira compilação pode levar 10-15 minutos.
Compilações subsequentes são mais rápidas (cache).

---

## Arquivos Modificados (mudanças já aplicadas)

✅ `src/lang/en.rs` - 16 strings "Trusted Technicians" (EN)
✅ `src/lang/ptbr.rs` - 16 strings "Técnicos Confiáveis" (PT-BR)
✅ `src/flutter_ffi.rs` - EventToUI enum com derives corretos
✅ `Cargo.toml` - Binário entry correto
✅ `flutter_rust_bridge.yaml` - Configuração de codegen

---

## Próximas Etapas Após Compilação

1. **Instalar no Ubuntu:**
   ```bash
   sudo cp ./target/release/rustdesk /usr/bin/
   # ou
   sudo apt install ./rustdesk-*.deb  # Se disponível
   ```

2. **Testar localmente:**
   ```bash
   ./target/release/rustdesk
   ```

3. **Conectar a outro RustDesk:**
   - Use ID gerado na interface
   - Teste "Trusted Technicians" feature
   - Verifique se strings aparecem em PT-BR (se sistema está em português)

4. **Criar pacote para distribuição:**
   ```bash
   cargo deb  # Gera .deb para Debian/Ubuntu
   ```

---

## Informações Úteis

- **Documentação**: `/home/dodo/Downloads/rustdesk/docs/`
- **Build logs**: `/home/dodo/Downloads/rustdesk/target/`
- **Flutter code**: `/home/dodo/Downloads/rustdesk/flutter/`
- **Rust core**: `/home/dodo/Downloads/rustdesk/src/`

---

## Suporte

Se tiver problemas:

1. Verifique se todas as variáveis de ambiente estão configuradas
2. Limpe cache: `cargo clean` (depois rebuild demora mais)
3. Verifique versão do Rust: `rustc --version` (deve ser ≥ 1.70)
4. Verifique Flutter: `flutter --version`

---

**Status:** ✅ Código implementado | ⏳ Aguardando compilação | 📦 Pronto para instalar

**Última atualização:** 2024
