# 🚀 Guia de Build do RustDesk

## Resumo Rápido

Para compilar o RustDesk em sua máquina:

```bash
# 1. Validar ambiente (detecta e instala dependências)
./preflight.sh

# 2. Compilar e gerar pacote .deb
./build-final.sh

# 3. Instalar
sudo dpkg -i ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

---

## Pré-requisitos

### Sistema Operacional

- **Ubuntu 20.04+** ou derivadas (Debian, Linux Mint, etc)
- **Arch Linux** (adaptações necessárias)

### Requisitos de Hardware

- **CPU**: 4+ cores (recomendado 8+)
- **RAM**: 8+ GB (16+ GB para builds mais rápidos)
- **Disco**: 50+ GB livres

### Requisitos de Software

- **Rust 1.70+**: Instalado via `rustup`
- **Build tools**: `gcc`, `make`, `pkg-config`
- **Bibliotecas dev**: GTK 3, OpenSSL, ALSA, XCB

---

## Passo 1: Validar Ambiente (`preflight.sh`)

Execute o script de pré-flight para verificar tudo automaticamente:

```bash
./preflight.sh
```

Este script:

- ✅ Verifica Rust instalado
- ✅ Verifica dependências do sistema
- ✅ Oferece instalar pacotes faltando automaticamente
- ✅ Valida permissões

### Se Rust não estiver instalado

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

### Se ainda houver dependências faltando

```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    pkg-config \
    libgtk-3-dev \
    libssl-dev \
    libxcb-randr0-dev \
    libxfixes-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libasound2-dev \
    wget
```

---

## Passo 2: Compilar (`build-final.sh`)

Após preflight bem-sucedido, execute o build:

```bash
./build-final.sh
```

Este script automaticamente:

- 📥 Baixa `libsciter-gtk.so` (se necessário)
- 🎨 Gera ícones PNG (se necessário)
- 🔨 Compila o binário em modo release
- 📦 Gera pacote `.deb` instalável

### Tempo esperado

- **Primeira build**: 15-30 minutos (depende de CPU/RAM)
- **Rebuilds**: 5-10 minutos (cache reutilizado)

### Otimizações

**Para builds mais rápidos** (menos otimização):

```bash
FAST_FINAL=1 ./build-final.sh
```

**Para usar mais cores** (se tiver 16+ cores):

```bash
BUILD_JOBS=16 ./build-final.sh
```

**Combinar otimizações**:

```bash
FAST_FINAL=1 BUILD_JOBS=16 ./build-final.sh
```

---

## Passo 3: Instalar

Após build bem-sucedido, o script mostrará o caminho do `.deb`:

```bash
sudo dpkg -i ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

---

## Solução de Problemas

### Build falha com erro de asset

Se receber erro como:

```
error: Can't resolve asset: res/128x128.png
```

O `build-final.sh` deveria ter criado automaticamente. Se não funcionou:

```bash
cd res/
# Gerar ícones com ImageMagick
convert -size 128x128 xc:blue 128x128.png
convert -size 256x256 xc:blue 128x128@2x.png
echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><circle cx="256" cy="256" r="256" fill="blue"/></svg>' > scalable.svg
```

### Compilação muito lenta

- Aumente `BUILD_JOBS` (mais paralelismo)
- Use `FAST_FINAL=1` (menos otimização)
- Instale `sccache` para cache de compilação

### Falta de espaço em disco

Limpe cache anterior:

```bash
rm -rf ~/.cache/rustdeskpv-target
```

---

## Estrutura de Build

```
projeto/
├── preflight.sh          ← Validar ambiente
├── build-final.sh        ← Compilar (auto-suficiente)
├── src/                  ← Código fonte Rust
├── res/                  ← Assets (ícones, libs, etc)
└── ~/.cache/rustdeskpv-target/
    └── debian/
        └── rustdesk_*.deb  ← Pacote final
```

---

## Variáveis de Ambiente

### `BUILD_JOBS`

Número de jobs paralelos (default: auto-calculado)

```bash
BUILD_JOBS=8 ./build-final.sh
```

### `BUILD_FEATURES`

Features para compilar (default: `linux-pkg-config`)

```bash
BUILD_FEATURES="linux-pkg-config" ./build-final.sh
```

### `FAST_FINAL`

Skip LTO e usar mais codegen units (default: 0)

```bash
FAST_FINAL=1 ./build-final.sh
```

### `CARGO_TARGET_DIR`

Diretório de output do Cargo (default: `~/.cache/rustdeskpv-target`)

```bash
CARGO_TARGET_DIR=/tmp/build ./build-final.sh
```

---

## Próximos Passos

### Depois de instalar

```bash
# Iniciar RustDesk
rustdesk

# Ver logs
journalctl -u rustdesk -f
```

### Para builds futuras

Os scripts reutilizarão cache de compilação anterior, então builds subsequentes são muito mais rápidas.

### Para contribuir com melhorias

1. Edite `build-final.sh` ou `preflight.sh`
2. Teste em sua máquina
3. Faça PR com melhorias

---

## Suporte

Se encontrar problemas:

1. Rode `./preflight.sh` novamente
2. Limpe cache: `rm -rf ~/.cache/rustdeskpv-target`
3. Tente novamente

---

**Última atualização**: Abril 2026  
**Scripts**: `preflight.sh`, `build-final.sh`  
**Objetivo**: Build auto-suficiente sem steps manuais
