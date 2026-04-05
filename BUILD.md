# 🏗️ COMO BUILDAR RUSTDESK COM TÉCNICOS DE CONFIANÇA

## 📋 Resumo

Existem **2 formas** de buildar:

|               | **RÁPIDO (Teste)**     | **DEFINITIVO (Distribuição)** |
| ------------- | ---------------------- | ----------------------------- |
| **Script**    | `./build-fast.sh`      | `./build-final.sh`            |
| **Resultado** | Binário executável     | Pacote .deb instalável        |
| **Tempo**     | 10-20 min              | 15-25 min                     |
| **Tamanho**   | ~30 MB                 | ~40-50 MB                     |
| **Uso**       | Testar funcionalidades | Instalar em máquinas          |
| **Uso**       | `./rustdesk` direto    | `sudo dpkg -i *.deb`          |

---

## ✅ OPÇÃO 1: BUILD RÁPIDO (para testes)

Compila **apenas o binário** sem empacotamento:

```bash
cd /home/rxn/projetos/rustdeskpv
./build-fast.sh
```

**Resultado:**

```
/home/rxn/.cache/rustdeskpv-target/release/rustdesk
```

**Para testar:**

```bash
/home/rxn/.cache/rustdeskpv-target/release/rustdesk
```

---

## ✅ OPÇÃO 2: BUILD DEFINITIVO (para distribuição)

Compila o binário **E** gera pacote `.deb` instalável:

```bash
cd /home/rxn/projetos/rustdeskpv
./build-final.sh
```

**Resultado:**

```
/home/rxn/.cache/rustdeskpv-target/debian/rustdesk_1.4.6-1_amd64.deb
```

**Para instalar:**

```bash
sudo dpkg -i /home/rxn/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

---

## 🧪 TESTE DA FEATURE "TÉCNICOS DE CONFIANÇA"

### Após Build Rápido:

1. **Desinstale versão antiga:**

   ```bash
   sudo dpkg -r rustdesk
   ```

2. **Execute novo binário:**

   ```bash
   /home/rxn/.cache/rustdeskpv-target/release/rustdesk
   ```

3. **Teste:**
   - ✅ Primeira conexão: Deve aparecer checkbox "Lembrar este técnico"
   - ✅ Marca o checkbox e aceita
   - ✅ Segunda conexão: Deve AUTO-APROVAR sem diálogo
   - ✅ Janela deve minimizar automaticamente

---

## 📝 RESUMO DOS COMANDOS

```bash
# Para testar (rápido)
cd /home/rxn/projetos/rustdeskpv
./build-fast.sh

# Para distribuir (completo)
cd /home/rxn/projetos/rustdeskpv
./build-final.sh
```

**Pronto!** Sem mais comandos confusos. Escolha um dos 2 scripts acima.

---

## ❓ DÚVIDAS FREQUENTES

**P: Qual script devo usar?**

- Use `build-fast.sh` para **testar** as funcionalidades
- Use `build-final.sh` para **instalar** em produção

**P: Quanto tempo leva?**

- Primeira compilação: 10-25 min (compila tudo)
- Compilações posteriores: 2-5 min (usa cache)

**P: Pode compilar em paralelo?**

- Não! Execute um script por vez. Aguarde terminar completamente.

**P: E se der erro?**

- Verifique: `pgrep -af "cargo|rustc"` - se houver processo, aguarde terminar
- Se não houver, limpe cache: `cargo clean` e tente novamente
