<p align="center">
  <img src="res/logo-header.svg" alt="RustDesk - Your remote desktop"><br>
  <strong>RustDesk PV — Private Version com "Trusted Technicians"</strong><br>
  <a href="#-início-rápido">Início Rápido</a> •
  <a href="#-compilação-passo-a-passo">Compilação</a> •
  <a href="#-feature-trusted-technicians">Recursos</a> •
  <a href="#-estrutura-do-projeto">Estrutura</a> •
  <a href="#-faq">FAQ</a>
</p>

---

# 🎯 RustDesk PV — Controle Remoto com Técnicos de Confiança

Uma **versão customizada do RustDesk** otimizada para ambientes de suporte técnico. Implementa a feature **"Trusted Technicians"** que permite que técnicos autorizados se conectem **automaticamente sem confirmação do usuário**, após uma primeira aprovação.

### 💼 Ideal para:

- ✅ Empresas de suporte técnico remoto
- ✅ Help desk corporativo
- ✅ Maintenance e troubleshooting
- ✅ Acesso remoto de TI interno
- ✅ Ambientes que exigem privacidade e controle total

## ✨ Características Principais

### 🔐 Feature "Trusted Technicians" (DESTAQUE)

- ✅ **Approve silencioso** — Técnicos de confiança conectam sem modais/diálogos
- ✅ **Checkbox na 1ª conexão** — "Lembrar deste técnico como confiável"
- ✅ **Auto-aprovação subsequentes** — Próximas conexões são imediatas e silenciosas
- ✅ **Suporte multilíngue** — PT-BR e EN 100% traduzido
- ✅ **Sem intervenção** — App continua em background, usuário não é interrompido
- ✅ **Lista de confiáveis** — Gerencie quem tem acesso automático
- ✅ **Revogação de acesso** — Remova técnicos da lista quando necessário

### 📱 Interface Moderna (Flutter)

- **UI nativa** — Interface moderna e responsiva usando Flutter
- **Multi-plataforma** — Desktop (Linux, Windows, macOS) e Mobile (Android, iOS)
- **Performance** — Melhor consumo de recursos vs. Sciter (deprecated)
- **Atualizações rápidas** — Deploy OTA possível

### 🔧 Build Robusto e Automatizado

- **Scripts otimizados** — `build-final.sh` (recomendado) pronto para uso
- **Pacotes .deb** — Instalação simples em Ubuntu/Debian
- **Multi-arquitetura** — x86_64, ARM64, ARM32 (conforme suporte)
- **CI/CD integrado** — GitHub Actions executa builds automáticos
- **Cache inteligente** — Reutiliza builds anteriores quando possível

### 🛡️ Segurança & Privacidade

- **Código aberto** — Auditável e confiável
- **Criptografia E2E** — Conexões sempre criptografadas
- **Controle total** — Seu próprio servidor (não obrigado usar cloud)
- **Sem telemetria** — Sem rastreamento de dados
- **Licença permissiva** — Uso comercial permitido

---

## 🚀 Início Rápido (5 minutos)

### ⚠️ Pré-requisitos Mínimos

- **Ubuntu 20.04+** (Debian 11+, Fedora, etc.)
- **Rust 1.60+** (instale via [rustup](https://rustup.rs/))
- **2 GB RAM** mínimo, **8 GB recomendado**
- **Git** com suporte a submodules

> 💡 **Dica:** Se você está em Windows/macOS, use Docker ou WSL2 para Linux

### 1️⃣ Preparar o Sistema (executar UMA VEZ)

```bash
sudo apt-get update && sudo apt-get install -y \
    build-essential git curl wget nasm yasm pkg-config \
    libx11-dev libgtk-3-dev libxcb-randr0-dev libxdo-dev \
    libxfixes-dev libxcb-shape0-dev libxcb-xfixes0-dev \
    libasound2-dev libpulse-dev cmake libclang-dev \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
    libopus-dev libssl-dev libxi-dev libxinerama-dev \
    libxcursor-dev libxtst-dev libxrender-dev libxext-dev
```

**Para outras distribuições:**

<details>
<summary><strong>Fedora / CentOS / RHEL</strong></summary>

```bash
sudo yum groupinstall -y "Development Tools" && sudo yum install -y \
    git curl wget nasm yasm pkg-config \
    libX11-devel gtk3-devel libxcb-devel libxdo-devel \
    libXfixes-devel pulseaudio-libs-devel cmake \
    gstreamer1-devel gstreamer1-plugins-base-devel openssl-devel
```

</details>

<details>
<summary><strong>openSUSE Tumbleweed</strong></summary>

```bash
sudo zypper install -y gcc-c++ git curl wget nasm yasm pkg-config \
    xorg-x11-devel gtk3-devel libxcb-devel libxdo-devel \
    libXfixes-devel cmake alsa-lib-devel gstreamer-devel \
    gstreamer-plugins-base-devel libopenssl-devel
```

</details>

<details>
<summary><strong>Arch / Manjaro</strong></summary>

```bash
sudo pacman -Syu --needed base-devel git cmake curl wget yasm nasm \
    xorg-server libx11 gtk3 libxcb libxdo libxfixes \
    alsa-lib pipewire gstreamer gst-plugins-base openssl
```

</details>

### 2️⃣ Clonar o Repositório

```bash
git clone --recurse-submodules https://github.com/rafaxavier/rustdeskpv
cd rustdeskpv
```

### 3️⃣ Compilar e Gerar Pacote

**Opção A: Build Automatizado (⭐ RECOMENDADO)**

O script abaixo compila TUDO e gera um `.deb` pronto para instalar:

```bash
./build-final.sh
```

✅ **Resultado:** `~/.cache/rustdeskpv-target/debian/rustdesk_*.deb` (~15-25 min)

**Opção B: Build Rápido (Debug)**

Para testes e desenvolvimento:

```bash
./build.sh
```

**Opção C: Build Customizado (Avançado)**

```bash
export CARGO_TARGET_DIR="$HOME/.cache/rustdeskpv-target"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Compilar
cargo build --release --bin rustdesk --features linux-pkg-config

# Gerar .deb
cargo deb --profile release --features linux-pkg-config

# Arquivo gerado em:
ls ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

### 4️⃣ Instalar

```bash
# Instalar o .deb
sudo dpkg -i ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb

# Se houver dependências faltantes:
sudo apt-get install -f

# Executar RustDesk
rustdesk
```

---

## 📖 Compilação: Passo a Passo

---

## 📚 Documentação Completa

| Documento                                                  | Descrição                          | Público         |
| ---------------------------------------------------------- | ---------------------------------- | --------------- |
| **[COMECE_AQUI.md](COMECE_AQUI.md)**                       | 👋 Guia para primeiro uso          | Iniciantes      |
| **[GUIA_COMPILACAO.md](GUIA_COMPILACAO.md)**               | 🔧 Compilação detalhada (3 opções) | Desenvolvedores |
| **[GUIA_TECNICO_CONFIANCA.md](GUIA_TECNICO_CONFIANCA.md)** | 🔐 Feature "Trusted Technicians"   | Suporte Técnico |
| **[BUILD.md](BUILD.md)**                                   | 📋 Informações técnicas de build   | DevOps/Infra    |
| **[REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md)**           | ⚡ Comandos essenciais             | Todos           |
| **[README_ORIGINAL_BACKUP.md](README_ORIGINAL_BACKUP.md)** | 📖 Docs do RustDesk original       | Referência      |

> 💡 **Recomendação:** Comece com [COMECE_AQUI.md](COMECE_AQUI.md) se é sua primeira vez!

---

## 🔐 Feature "Trusted Technicians" — Guia Prático

### O Problema que Resolvemos

**Cenário típico de suporte:**

```
❌ ANTES (sem feature):
  1. Usuário chama suporte com problema
  2. Técnico tenta conectar
  3. DIÁLOGO APARECE pedindo confirmação
  4. Usuário está ocupado, não vê, não clica
  5. Técnico não consegue acessar
  6. Problemas de comunicação... frustração

✅ DEPOIS (com Trusted Technicians):
  1. Usuário chama suporte
  2. Técnico conecta
  3. Sem diálogo! Auto-aprovado silenciosamente
  4. Acesso imediato e transparente
  5. Problema resolvido em minutos
```

### Fluxo Detalhado

**Primeira Conexão — Seu Técnico:**

```
┌──────────────────────────────────────────────────────┐
│ Técnico se conecta via ID/Código                     │
└──────────┬───────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────┐
│ 📬 DIÁLOGO APARECE NA TELA DO USUÁRIO:               │
│                                                       │
│   "Técnico João quer acessar seu computador"         │
│                                                       │
│   ☐ Lembrar deste técnico (auto-aprovar próxima)    │
│   ☐ Auto-minimizar aplicação                         │
│                                                       │
│   [Rejeitar]  [Aceitar]  [Aceitar & Elevar]         │
└──────────┬───────────────────────────────────────────┘
           │
           ▼ (Usuário marca checkbox e clica "Aceitar")
┌──────────────────────────────────────────────────────┐
│ ✅ Técnico SALVO como "Confiável"                    │
│ ✅ Acesso CONCEDIDO imediatamente                    │
│ 💤 Aplicação minimizada em background (se optado)   │
└──────────────────────────────────────────────────────┘
```

**Próximas Conexões — Silenciosas:**

```
┌──────────────────────────────────────────────────────┐
│ Técnico se conecta novamente (João)                  │
└──────────┬───────────────────────────────────────────┘
           │
           ▼
┌──────────────────────────────────────────────────────┐
│ Sistema verifica: "João é confiável?"                │
└──────────┬───────────────────────────────────────────┘
           │
           ▼ (Sim!)
┌──────────────────────────────────────────────────────┐
│ ✅ AUTO-APROVA (ZERO DIÁLOGOS)                       │
│ 🔗 Conexão estabelecida imediatamente                │
│ 💤 Usuário nem percebe! App em background            │
│                                                       │
│ ⏱️  Tempo de acesso: < 5 segundos                   │
└──────────────────────────────────────────────────────┘
```

### Uso Prático

**Passo 1: Executar RustDesk em modo "Listen"**

```bash
rustdesk  # Ou Menu > Listen
```

**Passo 2: Técnico se conecta**

- Técnico usa seu ID RustDesk
- Ou code de acesso único

**Passo 3: Marque o Checkbox (primeira vez)**

```
☑️ Lembrar João como técnico de confiança
```

**Passo 4: Próximas vezes = Automático!**

- Sem diálogos
- Sem confirmação
- Sem interrupção

> 📖 **Tutorial completo:** Veja [GUIA_TECNICO_CONFIANCA.md](GUIA_TECNICO_CONFIANCA.md)

---

## 📁 Estrutura do Projeto

```
rustdeskpv/
├── 🚀 Build Scripts (Executáveis)
│   ├── build-final.sh            ⭐ Build para distribuição (RECOMENDADO)
│   ├── build.sh                  ⚡ Build rápido (debug)
│   ├── build-fast.sh             🔥 Build ultra-rápido
│   ├── build-installer.sh        📦 Cria instalador
│   └── build.py                  🐍 Build em Python
│
├── 📚 Documentação
│   ├── README.md                 ← Você está aqui!
│   ├── COMECE_AQUI.md            Guia português para iniciantes
│   ├── GUIA_COMPILACAO.md        Compilação detalhada
│   ├── GUIA_TECNICO_CONFIANCA.md Feature "Trusted Technicians"
│   ├── BUILD.md                  Info técnica
│   ├── REFERENCIA_RAPIDA.md      Comandos essenciais
│   └── docs/                     Documentação original RustDesk
│
├── 🔧 Código-fonte Rust
│   ├── src/
│   │   ├── main.rs              Entry point principal
│   │   ├── server.rs            Servidor RustDesk (core)
│   │   ├── client.rs            Cliente RustDesk
│   │   ├── ui/                  UI Sciter (deprecated, apenas referência)
│   │   └── platform/            Código específico por SO
│   │       ├── mod.rs
│   │       ├── linux.rs         Linux-specific
│   │       ├── windows.rs       Windows-specific
│   │       └── macos.rs         macOS-specific
│   │
│   └── build.rs                 Build script Cargo
│
├── 🎨 UI Flutter (Moderna)
│   ├── flutter/
│   │   ├── lib/
│   │   │   ├── main.dart        Entry Flutter
│   │   │   ├── models/          Modelos de dados
│   │   │   ├── pages/           Telas da aplicação
│   │   │   │   ├── login.dart
│   │   │   │   ├── connection.dart
│   │   │   │   └── settings.dart
│   │   │   ├── widgets/         Componentes reutilizáveis
│   │   │   └── utils/           Funções auxiliares
│   │   ├── pubspec.yaml         Dependências Flutter
│   │   └── web/                 Versão web
│   │
│   └── flutter_rust_bridge.yaml  Bridge Rust ↔ Dart
│
├── 📦 Bibliotecas Rust (Shared)
│   ├── libs/
│   │   ├── hbb_common/          Código comum (codec, config, network)
│   │   ├── scrap/               Screen capture lib
│   │   ├── enigo/               Keyboard/mouse control
│   │   ├── clipboard/           Copy/paste implementation
│   │   └── [outras]/
│   │
│   └── libs/hbb_common/src/      ← Onde está Trusted Technicians!
│       ├── config.rs            ✅ Config do técnico confiável
│       ├── protocol.rs          Protocolo de comunicação
│       └── ...
│
├── 🔄 CI/CD (GitHub Actions)
│   ├── .github/
│   │   └── workflows/
│   │       ├── flutter-nightly.yml   Nightly build automático
│   │       ├── ci.yml                Testes Rust
│   │       ├── flutter-ci.yml        Testes Flutter
│   │       ├── flutter-tag.yml       Release builds
│   │       ├── flutter-build.yml     Build compartilhado
│   │       └── ...
│   │
│   └── .github/patches/         Patches para dependências
│
├── 🌍 Recursos & Assets
│   ├── res/
│   │   ├── logo-header.svg      Logo
│   │   ├── icon.svg             Ícone app
│   │   └── [outras imagens]
│   │
│   └── appimage/                Config para AppImage
│
├── 📋 Configuração
│   ├── Cargo.toml               Dependências e config Rust
│   ├── Cargo.lock               Lock de versões
│   ├── vcpkg.json               Dependências C++
│   ├── flutter_rust_bridge.yaml Bridge config
│   ├── Dockerfile               Para compilar em container
│   └── preflight.sh             Script de validação pré-build
│
└── 🔐 Segurança & Licença
    ├── LICENCE                  Licença (verificar tipo)
    ├── docs/CODE_OF_CONDUCT.md  Código de conduta
    └── docs/SECURITY.md         Política de segurança
```

### 📍 Onde está a Feature "Trusted Technicians"?

```
🔐 Implementação em:
├── libs/hbb_common/src/config.rs
│   └── Salva técnicos confiáveis (SQLite/JSON)
│
├── src/server.rs
│   └── Lógica de auto-aprovação
│
└── flutter/lib/widgets/
    └── Checkbox "Lembrar técnico"
```

---

## 🔄 Workflows Automatizados (GitHub Actions)

Este projeto usa **GitHub Actions** para automação contínua:

| Workflow               | Quando executa             | Resultado                              |
| ---------------------- | -------------------------- | -------------------------------------- |
| **Flutter Nightly** 🌙 | Toda noite (00:00 UTC)     | Build automático da versão nightly     |
| **CI** ✅              | A cada push/PR na `master` | Testes Rust + validações               |
| **Flutter CI** ✅      | A cada push/PR             | Testes Flutter + build apk/ios         |
| **Flutter Tag** 🏷️     | Ao criar release tag       | Binários prontos para distribuição     |
| **F-Droid** 🤖         | Conforme configuração      | Publica no F-Droid (app store Android) |
| **Clear Cache** 🗑️     | Manual                     | Limpa cache de build                   |
| **F-Droid**            | Automático                 | Publica no F-Droid                     |

Veja `.github/workflows/` para mais detalhes.

---

## 🛠️ Desenvolvimento

### Compilar em Debug

```bash
cargo build --features linux-pkg-config
./target/debug/rustdesk
```

### Compilar em Release

````bash
cargo build --release --features linux-pkg-config
## 🛠️ Desenvolvimento & Customização

### Setup para Desenvolvimento

```bash
# Clonar e entrar no projeto
git clone --recurse-submodules https://github.com/rafaxavier/rustdeskpv
cd rustdeskpv

# Instalar dependências
./preflight.sh  # Ou instale manualmente (veja acima)

# Build em debug (mais rápido)
cargo build --features linux-pkg-config
./target/debug/rustdesk
````

### Compilação Customizada

**Debug (desenvolvimento)**

```bash
cargo build --features linux-pkg-config
./target/debug/rustdesk
```

**Release (distribuição)**

```bash
cargo build --release --features linux-pkg-config
./target/release/rustdesk
```

**Com otimizações**

```bash
export CARGO_PROFILE_RELEASE_LTO="fat"
export CARGO_PROFILE_RELEASE_CODEGEN_UNITS="1"
cargo build --release --features linux-pkg-config
```

### Gerar Pacote .deb

```bash
# Opção 1: Automático (recomendado)
./build-final.sh

# Opção 2: Manual
cargo deb --profile release --features linux-pkg-config
ls ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

### Executar Testes

```bash
# Todos os testes
cargo test

# Teste específico
cargo test nome_do_teste

# Com output
cargo test -- --nocapture
```

### Limpar Build

```bash
# Cache completo
cargo clean
rm -rf ~/.cache/rustdeskpv-target/

# Apenas binários
rm -rf target/

# Apenas dependências cached
cargo clean --release
```

### Debugging

```bash
# Com RUST_LOG
RUST_LOG=debug cargo run --features linux-pkg-config

# Com debugger (gdb)
rust-gdb ./target/debug/rustdesk

# Com valgrind (memory leaks)
valgrind --leak-check=full ./target/debug/rustdesk
```

---

## 📊 Requisitos de Sistema

### Mínimos

| Componente | Requisito                               |
| ---------- | --------------------------------------- |
| **OS**     | Ubuntu 18.04+ / Debian 10+ / Fedora 28+ |
| **RAM**    | 4 GB                                    |
| **Disco**  | 5 GB livres                             |
| **Rust**   | 1.56+                                   |
| **CPU**    | 2 cores                                 |

### Recomendados (Build mais rápido)

| Componente   | Sugestão                |
| ------------ | ----------------------- |
| **OS**       | Ubuntu 22.04 LTS        |
| **RAM**      | 8 GB+                   |
| **Disco**    | 15 GB+ (cache de build) |
| **Rust**     | 1.70+                   |
| **CPU**      | 4+ cores                |
| **Internet** | Mínimo 5 Mbps           |

### Tempo de Compilação Esperado

| Tipo                       | Tempo     | Máquina              |
| -------------------------- | --------- | -------------------- |
| Debug (`build.sh`)         | 5-10 min  | 4 cores, 8GB RAM     |
| Release (`build-final.sh`) | 15-25 min | 4 cores, 8GB RAM     |
| Release com LTO            | 30-45 min | 4 cores, 8GB RAM     |
| NanoPC-T6 (ARM)            | 45-60 min | 6 cores ARM, 4GB RAM |

> 💡 Use `-j$(nproc)` para paralelismo automático

---

## 🤝 Como Contribuir

Adoramos contribuições! Aqui está como começar:

### 1️⃣ Fork e Clone

```bash
git clone https://github.com/SEU_USUARIO/rustdeskpv
cd rustdeskpv
git remote add upstream https://github.com/rafaxavier/rustdeskpv
```

### 2️⃣ Crie uma Branch

```bash
git checkout -b feat/sua-feature-incrivel
# ou
git checkout -b fix/nome-do-bug
```

### 3️⃣ Faça suas Mudanças

```bash
# Edite arquivos, compile, teste
cargo test
cargo fmt
cargo clippy
```

### 4️⃣ Commit & Push

```bash
git add .
git commit -m "feat: adicionar suporte para X"
git push origin feat/sua-feature-incrivel
```

### 5️⃣ Abra um Pull Request

- Vá a https://github.com/rafaxavier/rustdeskpv/pulls
- Clique "New Pull Request"
- Descreva suas mudanças

**Regras de contribuição:**

- ✅ Code deve seguir `cargo fmt`
- ✅ Sem warnings em `cargo clippy`
- ✅ Testes passando (`cargo test`)
- ✅ Commit messages claras e em PT-BR ou EN
- ❌ Não modifique Cargo.lock sem motivo

📖 Veja [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) para detalhes completos.

---

## 📝 Licença

Este projeto herda a licença do **RustDesk original**.

**Consulte [LICENCE](LICENCE)** para os termos completos.

> **Resumo:** Código aberto, uso comercial permitido, sem garantias.

---

## 🔒 Segurança & Responsabilidade Legal

### ⚠️ Disclaimer de Uso Responsável

Os desenvolvedores **NÃO condona ou apoia**:

- ✗ Acesso não autorizado a computadores
- ✗ Invasão de privacidade
- ✗ Atividades ilegais
- ✗ Spyware/malware

**Você é 100% responsável** pelo uso desta ferramenta.

### Relatando Vulnerabilidades

Se encontrar uma **vulnerabilidade de segurança**:

1. **NÃO** abra issue pública
2. Envie email para: `security@rustdesk.com` (RustDesk original)
3. Ou contate o mantenedor: seu email

---

## 📞 Suporte & Comunidade

### Obter Ajuda

| Canal                  | Link                                                                 | Uso                |
| ---------------------- | -------------------------------------------------------------------- | ------------------ |
| **GitHub Issues**      | [/issues](https://github.com/rafaxavier/rustdeskpv/issues)           | Bugs e features    |
| **GitHub Discussions** | [/discussions](https://github.com/rafaxavier/rustdeskpv/discussions) | Dúvidas gerais     |
| **Discord**            | [RustDesk Community](https://discord.gg/nDceKgxnkV)                  | Chat em tempo real |
| **Reddit**             | [r/rustdesk](https://www.reddit.com/r/rustdesk)                      | Comunidade         |

### Reportar Bug

```markdown
**Descrição:**
Quando eu [AÇÃO], esperava [ESPERADO] mas [O QUE ACONTECEU]

**Passos para reproduzir:**

1. ...
2. ...
3. ...

**Logs:**
[Cole saída de erro/log aqui]

**Sistema:**

- OS: [Ubuntu 22.04]
- Rust: [1.70.0]
- RustDesk: [v0.0.1]
```

---

## 🎓 Aprenda Mais

### Documentação Oficial

- **[Rust Book](https://doc.rust-lang.org/book/)** — Aprenda Rust do zero
- **[RustDesk Docs](https://docs.rustdesk.com/)** — Documentação oficial
- **[Flutter Docs](https://flutter.dev/docs)** — Desenvolvimento UI

### Recursos Adicionais

- **Cargo Guide** — https://doc.rust-lang.org/cargo/
- **Rust by Example** — https://doc.rust-lang.org/rust-by-example/
- **GitHub Actions Docs** — https://docs.github.com/en/actions

---

## 📊 Status do Projeto

```
✅ Feature "Trusted Technicians"    COMPLETO
✅ UI Flutter                        IMPLEMENTADO
✅ Build Linux (.deb)                PRONTO
✅ CI/CD Workflows                   CONFIGURADO
✅ Documentação PT-BR                CONCLUÍDO
✅ GitHub Actions                    OPERACIONAL
🟡 Testes Automatizados              EM PROGRESSO
🟡 Documentação EN (completa)        EM PROGRESSO
🟡 macOS/Windows Binários            PENDENTE
🟡 Docker Support                    EM PROGRESSO
```

## 💬 Comunidade & Suporte

- **GitHub Issues**: [Abrir issue](https://github.com/rafaxavier/rustdeskpv/issues)
- **Discussões**: [GitHub Discussions](https://github.com/rafaxavier/rustdeskpv/discussions)
- **Discord**: [RustDesk Community](https://discord.gg/nDceKgxnkV)
- **Reddit**: [r/rustdesk](https://www.reddit.com/r/rustdesk)

---

## 📊 Status do Projeto

```
✅ Feature "Trusted Technicians" - COMPLETO
✅ UI Flutter - IMPLEMENTADO
✅ Build Linux (.deb) - PRONTO
✅ CI/CD Workflows - CONFIGURADO
✅ Documentação PT-BR - CONCLUÍDO
🟡 Testes Automatizados - EM PROGRESSO
🟡 macOS/Windows - PENDENTE
```

---

## 🎓 Aprenda Mais

- **RustDesk Original**: https://github.com/rustdesk/rustdesk
- **Rust Book**: https://doc.rust-lang.org/book/
- **Flutter Docs**: https://flutter.dev/docs
- **GitHub Actions**: https://docs.github.com/en/actions

---

## ❓ FAQ — Perguntas Frequentes

### 🎯 Sobre Trusted Technicians

**P: Por que a feature "Trusted Technicians" é importante?**

> R: Em ambientes corporativos, técnicos precisam acessar máquinas rapidamente. Diálogos de confirmação causam delays. Com técnicos de confiança, acesso é automático = suporte mais rápido.

**P: É seguro marcar um técnico como confiável?**

> R: Sim! Você controla totalmente:
>
> - ✅ Você marca QUEM é confiável (nome/ID do técnico)
> - ✅ Você pode revogar acesso a qualquer momento
> - ✅ Conexão é criptografada E2E
> - ✅ Logs registram todos os acessos

---

### 🔧 Sobre Compilação

**P: Por quanto tempo leva compilar?**

> R: Depende do hardware:
>
> - 4 cores / 8GB RAM: **20-30 min**
> - 8 cores / 16GB RAM: **10-15 min**

**P: Erro de dependência?**

> R: Execute novamente:
>
> ```bash
> sudo apt-get install pkg-config libx11-dev libgtk-3-dev libxcb-randr0-dev
> cargo clean && cargo build --release
> ```

### 📦 Sobre Instalação

**P: Onde fica o binário?**

> R:
>
> - Release: `./target/release/rustdesk`
> - .deb: `~/.cache/rustdeskpv-target/debian/rustdesk_*.deb`

**P: Como desinstalar?**

> R: `sudo dpkg -r rustdesk`

### 🐛 Troubleshooting

**P: Build falha?**

> R: ```bash
> cargo clean
> rustup update
> cargo build --release --features linux-pkg-config
>
> ```
>
> ```

---

<p align="center">
  <strong>❓ Mais dúvidas?</strong><br>
  <a href="https://github.com/rafaxavier/rustdeskpv/issues">Abra uma Issue</a> • <a href="https://github.com/rafaxavier/rustdeskpv/discussions">Discussões</a>
</p>

---

<p align="center">
  <br>
  <strong>🚀 Feito com ❤️ para técnicos de confiança</strong><br>
  <sub><strong>RustDesk PV</strong> — Private Version com Trusted Technicians</sub><br>
  <sub>Baseado em <a href="https://github.com/rustdesk/rustdesk">RustDesk</a> • Licença <a href="LICENCE">Aberta</a></sub><br>
  <br>
  <a href="#-início-rápido">Voltar ao topo ⬆️</a>
</p>
