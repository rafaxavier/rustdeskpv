# 📦 Como Gerar o Instalável DEB do RustDesk - Guia Seguro

## ⚠️ Importante: Seu SO está Protegido

Este guia evita qualquer mudança permanente no seu Ubuntu!

---

## 🚀 Método Recomendado: Build em 3 Passos

### Passo 1: Compilar o Binário (10-30 minutos)

```bash
cd /media/rxn/dados/workspace/rustdeskpv
. "$HOME/.cargo/env"
cargo build --release --bin rustdesk
```

✅ Resultado: Binário em `target/release/rustdesk`

### Passo 2: Instalar cargo-deb (na sua home, seguro)

```bash
cargo install cargo-deb
```

✅ Isso instala apenas na sua home (`~/.cargo/bin/`) - não afeta o SO

### Passo 3: Gerar o Arquivo DEB

```bash
cargo deb --release
```

✅ Resultado: Arquivo `.deb` em `target/debian/rustdesk-*.deb`

---

## 📥 Como Instalar em Suas Máquinas

Depois de gerar o `.deb`, você pode distribuir para suas máquinas:

```bash
# Em qualquer máquina Ubuntu:
sudo apt install /caminho/para/rustdesk-1.4.6-amd64.deb
```

Ou, se preferir, sem instalação permanente:

```bash
./target/release/rustdesk
```

---

## 📋 Verificação de Segurança

Nenhuma das operações acima vai:

- ❌ Modificar arquivos do sistema
- ❌ Instalar pacotes globalmente (exceto na hora que você escolher instalar o `.deb`)
- ❌ Alterar configurações
- ❌ Remover ou corromper dados

Tudo fica localizado em:

- Cargo build: `/media/rxn/dados/workspace/rustdeskpv/target/`
- cargo-deb: `~/.cargo/bin/cargo-deb`

---

## 🔄 Se der Erro

Se algo não funcionar:

1. O projeto pode ser deletado inteiro sem deixar rastros
2. Sua home (`~/.cargo/`) pode ser restaurada
3. Seu Ubuntu continua 100% intacto

Quer que eu execute o build agora? Avise!
