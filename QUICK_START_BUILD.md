# ⚡ Quick Start - Build RustDesk em 3 comandos

## Para quem tem pressa:

```bash
# 1. Preparar ambiente (resolve tudo automaticamente)
./preflight.sh

# 2. Compilar
./build-final.sh

# 3. Instalar
sudo dpkg -i ~/.cache/rustdeskpv-target/debian/rustdesk_*.deb
```

**Pronto!** RustDesk está instalado.

---

## Tempo estimado

- Primeira vez: **20-30 min**
- Rebuilds: **5-10 min**

---

## Se algo falhar

1. Rode `./preflight.sh` novamente
2. Resolva as dependências marcadas como ❌
3. Tente `./build-final.sh` novamente

---

Para documentação completa: veja `BUILD_GUIDE.md`
