<p align="center">
  <img src="res/logo-header.svg" alt="RustDesk PV"><br>
  <strong>🔐 RustDesk PV — Técnicos de Confiança (Trusted Technicians)</strong><br>
  <a href="#-início-rápido">Início Rápido</a> •
  <a href="#-compilação">Compilação</a> •
  <a href="#-faq">FAQ</a>
</p>

---

# 🎯 RustDesk PV — Auto-Aprovação Silenciosa

Uma **versão otimizada do RustDesk** com feature **"Trusted Technicians"** que permite técnicos autorizados conectarem **sem diálogos de confirmação** após aprovação inicial.

## ✨ O que você ganha

- ✅ **Acesso silencioso** — Zero diálogos de confirmação para técnicos confiáveis
- ✅ **Auto-minimiza janela** — Interface desaparece automaticamente durante conexão
- ✅ **Sem `--cm-ui`** — Processo do CM inicia com `--cm-no-ui` quando `hide_cm()=true`
- ✅ **Configurável** — Controlado por `allow-hide-login-dialog='Y'` + `approve-mode='password'`
- ✅ **Rápido** — Build otimizado com `cargo deb` (15-25 min)

---

## 🚀 Início Rápido (5 min)

### Pré-requisitos

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y \
    build-essential git curl pkg-config libx11-dev libgtk-3-dev \
    libxcb-randr0-dev libxdo-dev libxfixes-dev libopus-dev \
    libssl-dev libxi-dev libxinerama-dev libxcursor-dev libxtst-dev

# Rust (se não tiver)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### 1. Clonar

```bash
git clone --recurse-submodules https://github.com/rafaxavier/rustdeskpv
cd rustdeskpv
```

### 2. Compilar

```bash
# Build automatizado (RECOMENDADO) — 15-25 min
./build-final.sh

# Resultado: ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

### 3. Instalar

```bash
sudo dpkg -i ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
rustdesk
```

---

## 🔐 Como Funciona

### Configuração Necessária

Para ativar o modo silencioso, defina no arquivo de config do RustDesk:

```
allow-hide-login-dialog = Y
approve-mode = password
```

### Fluxo de Autenticação

```
1ª CONEXÃO:
┌─────────────────────────────────────────┐
│ Técnico se conecta                      │
│ → Diálogo aparece para aprovação        │
│ → Usuário marca "Lembrar técnico"       │
│ → Clica "Aceitar"                       │
└────────┬────────────────────────────────┘
         │
         ▼
PRÓXIMAS CONEXÕES:
┌─────────────────────────────────────────┐
│ Técnico se conecta novamente            │
│ → Sistema checa: hide_cm() = true       │
│ → CM inicia com --cm-no-ui              │
│ → ZERO DIÁLOGOS                         │
│ → Acesso imediato (< 5 seg)             │
└─────────────────────────────────────────┘
```

---

## 🛠️ Compilação Avançada

### Opções de Build

```bash
# Debug (mais rápido)
./build.sh

# Release otimizado
./build-final.sh

# Custom com variáveis
export CARGO_TARGET_DIR="$HOME/.cache/rustdeskpv-target"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
cargo build --release --bin rustdesk --features linux-pkg-config
cargo deb --profile release --features linux-pkg-config
```

### Limpeza

```bash
cargo clean              # Remove tudo
rm -rf ~/.cache/rustdeskpv-target/  # Cache de build
```

---

## � Estrutura Principal

```
rustdeskpv/
├── build-final.sh              ⭐ Build completo (RECOMENDADO)
├── build.sh                    ⚡ Build rápido
├── src/
│   ├── server/connection.rs    🔐 Lógica hide_cm() aqui!
│   ├── ui/cm.tis              UI scripting (deprecated)
│   └── ...
├── libs/
│   └── hbb_common/
│       └── src/password_security.rs  ✅ hide_cm() logic
└── flutter/                    🎨 Nova UI (Flutter)
```

### Onde Está a Feature?

**Backend (Rust):**

- `src/server/connection.rs` — Linha ~4850: Checa `hide_cm()` e inicia com `--cm-no-ui`
- `libs/hbb_common/src/password_security.rs` — Função `hide_cm()` retorna `true` se:
  - `allow-hide-login-dialog = 'Y'` **OU**
  - `approve-mode = 'password'` + `verification-method = 'permanent-password'`

**UI (Sciter/TIS):**

- `src/ui/cm.tis` — Lógica adicional de bloqueio (render vazio, janela oculta)

---

## ❓ FAQ

**P: Como ativar a feature de auto-aprovação silenciosa?**

R: Defina no arquivo de config:

```
allow-hide-login-dialog = Y
approve-mode = password
```

**P: O processo CM inicia com `--cm-no-ui` ou `--cm`?**

R: Depende de `password::hide_cm()`:

- `--cm-no-ui` — Se `allow-hide-login-dialog=Y` (nenhuma janela é criada)
- `--cm` — Caso contrário

**P: Quanto tempo leva para compilar?**

R: Com 4 cores/8GB RAM: **15-25 minutos** com `build-final.sh`

**P: Posso desabilitar a feature silenciosa?**

R: Sim! Remova ou altere:

```
allow-hide-login-dialog = N  (ou remova a linha)
```

**P: Onde vejo os logs de conexão?**

R: Ative `RUST_LOG=debug` na compilação:

```bash
RUST_LOG=debug rustdesk
```

---

<p align="center">
  <strong>🚀 RustDesk PV — Técnicos de Confiança 2025</strong><br>
  <a href="https://github.com/rafaxavier/rustdeskpv">GitHub</a> •
  <a href="#-início-rápido">Quick Start</a> •
  <a href="#-faq">FAQ</a>
</p>
