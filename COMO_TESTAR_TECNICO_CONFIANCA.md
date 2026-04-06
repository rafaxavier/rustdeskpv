# 🔧 Como Testar a Feature "Técnico de Confiança"

## 📍 Localização da Feature

A feature **"Técnico de Confiança"** não aparece na tela inicial do RustDesk. Ela aparece em um **diálogo especial** quando:

### ✅ Quando aparece o checkbox?

Quando **uma pessoa REMOTA tenta conectar a ESTE computador**, aparecerá um diálogo com:

- ☑️ Checkbox: "Remember this technician" (Lembrar este técnico)
- Descrição: "Auto-approve this technician on next connection"
- Botões: Accept / Decline / Accept and Elevate

## 🎯 Passo a Passo para Testar

### Pré-requisitos

- ✅ RustDesk instalado neste computador (o que você tem agora)
- ✅ RustDesk em outro computador/laptop/celular
- ✅ Ambos conectados à internet

### 1️⃣ Obter o ID deste computador

```bash
# No terminal, execute:
rustdesk --get-id
# OU abra o RustDesk e veja o ID na tela principal (ex: 123456789)
```

### 2️⃣ Testar de outro computador

- Abra RustDesk no outro computador
- Vá em "Connect" ou "Conexão"
- Digite o ID obtido no passo 1
- Clique em "Connect" / "Conectar"

### 3️⃣ Autorizar a conexão

- **Neste computador**, um diálogo aparecerá perguntando se quer permitir a conexão
- **NESTE DIÁLOGO**, você verá o checkbox:
  ```
  ☐ Remember this technician
    Auto-approve this technician on next connection
  ```

### 4️⃣ Testar a funcionalidade

```
A. Primeira conexão (SEM marcar):
   ✓ Conexão permitida
   ✓ Próxima conexão: mostrará diálogo novamente

B. Primeira conexão (MARCANDO o checkbox ☑️):
   ✓ Conexão permitida
   ✓ Próxima conexão: será AUTOMÁTICA (sem diálogo)
   ✓ Janela pode minimizar automaticamente
```

## 🔍 Verificação: Checkbox está compilado?

Se quiser confirmar que o checkbox está no código compilado:

```bash
# Procure por texto do checkbox no binário
strings /usr/bin/rustdesk | grep -i "remember"

# Se retornar algo como:
# Remember this technician
# Auto-approve this technician on next connection

# ✅ Está compilado corretamente!
```

## 📋 Localização no código-fonte

Para referência, o checkbox está definido em:

- **Arquivo**: `flutter/lib/desktop/pages/server_page.dart`
- **Linhas**: 1032-1065 (aprox)
- **Componente**: `CheckboxListTile` com lógica GetX (`Obx`)

## 🐛 Troubleshooting

### "Não vejo o diálogo de conexão"

- Certifique-se que:
  - [ ] O RustDesk neste computador está aberto/rodando
  - [ ] O outro computador tem o ID correto
  - [ ] Ambos estão na internet
  - [ ] Não há firewall bloqueando

### "Vejo o diálogo mas não vejo o checkbox"

- [ ] Atualize o RustDesk para a versão mais recente (que você tem agora)
- [ ] Feche e abra o RustDesk novamente
- [ ] Verifique se o binário foi recompilado com a feature

## 🚀 Próximos Passos

1. **Arrume um segundo computador** (colega, teste em VM, etc)
2. **Faça uma conexão de teste** de outro computador para este
3. **Marque o checkbox** no diálogo
4. **Reconecte** e confirme que foi automático

Pronto! 🎉

---

## 📝 Código da Feature (Referência)

```dart
// Em server_page.dart linha ~1032
final rememberTechnician = false.obs;

// Checkbox que aparece no diálogo
Obx(() => CheckboxListTile(
  value: rememberTechnician.value,
  onChanged: (value) {
    rememberTechnician.value = value ?? false;
  },
  title: Text(translate('Remember this technician')),
  subtitle: Text(translate('Auto-approve this technician on next connection')),
))

// Ao clicar em "Accept", salva a preferência
if (rememberTechnician.value) {
  model.setRememberTechnician(client.peerId, true);
}
handleAccept(context);
windowManager.minimize();
```

## ⚙️ Configuração do Modelo

Em `flutter/lib/models/server_model.dart`:

```dart
// Armazena quais técnicos foram marcados como "lembrados"
final Map<String, bool> _rememberTechnicianFlags = {};

// Na próxima conexão do mesmo técnico:
if (_rememberTechnicianFlags[client.peerId] == true) {
  // Auto-aprova sem mostrar diálogo
  handleAccept();
}
```

---

**Agora você sabe onde procurar! 🔍**

Teste fazendo uma conexão remota para ver o checkbox aparecer. 📞
