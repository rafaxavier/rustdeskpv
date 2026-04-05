# 🔍 Guia de Localização de Código - Técnicos de Confiança

**Para desenvolvedores que querem entender ou modificar a funcionalidade**

---

## 📍 Onde Está Cada Componente

### 1. Modelo de Dados (Gerenciador de Técnicos)

**Arquivo:** `flutter/lib/models/trusted_technician_model.dart`

```dart
class TrustedTechnicianModel {
  // 📌 Constantes de armazenamento
  static const String kTrustedTechniciansListKey = 'trusted_technicians_list';
  static const String kTrustedTechNamePrefix = 'trusted_tech_';

  // 📌 Funções principais
  void loadTrustedTechnicians()                    // Carregar do storage
  Future<void> addTrustedTechnician(...)           // Adicionar à lista
  Future<void> removeTrustedTechnician(...)        // Remover da lista
  bool isTrustedTechnician(String peerId)          // Verificar se é confiável
  String getTechnicianName(String peerId)          // Obter nome do técnico
  String getTechnicianTimestamp(String peerId)     // Obter data de auth
  List<Map<String, String>> getAllTrustedTechnicians()  // Listar todos
}
```

**Linha chave:**

- Linha 32-52: Carregamento de dados
- Linha 69-80: Adicionar técnico
- Linha 111: Verificação de técnico confiável

---

### 2. Integração no Servidor (Lógica Principal)

**Arquivo:** `flutter/lib/models/server_model.dart`

#### Inicialização (Linha 53)

```dart
final _trustedTechnicianModel = TrustedTechnicianModel();
```

#### Getter (Linha 92)

```dart
TrustedTechnicianModel get trustedTechnicianModel => _trustedTechnicianModel;
```

#### Carregamento (Linha 147)

```dart
_trustedTechnicianModel.loadTrustedTechnicians();
```

#### 🔑 FUNÇÃO CRÍTICA: Auto-Aprovação (Linha ~615)

```dart
void showLoginDialog(Client client) {
  // ⭐ VERIFICAÇÃO DO TÉCNICO CONFIÁVEL
  if (_trustedTechnicianModel.isTrustedTechnician(client.peerId)) {
    debugPrint('Auto-aprovando técnico confiável: ${client.name} (${client.peerId})');
    // ⭐ AUTO-APROVA SILENCIOSAMENTE
    sendLoginResponse(client, true);
    return;  // ⭐ NÃO MOSTRA DIÁLOGO
  }

  // Caso contrário, mostra diálogo normal
  showClientDialog(...);
}
```

#### Salvar Técnico Confiável (Linha ~717)

```dart
void sendLoginResponse(Client client, bool res) async {
  if (res) {
    // ... código ...

    // Se usuário marcou checkbox para lembrar
    if (_rememberTechnicianFlags[client.peerId] == true) {
      await _trustedTechnicianModel.addTrustedTechnician(
        peerId: client.peerId,
        technicianName: client.name,
      );
      _rememberTechnicianFlags.remove(client.peerId);
    }
    // ... mais código ...
  }
}
```

#### Helper Functions (Linha ~737)

```dart
void setRememberTechnician(String peerId, bool remember) {
  _rememberTechnicianFlags[peerId] = remember;  // Marca intenção
}

bool shouldRememberTechnician(String peerId) {
  return _rememberTechnicianFlags[peerId] ?? false;
}
```

---

### 3. Interface de Diálogo (UI com Checkbox)

**Arquivo:** `flutter/lib/desktop/pages/server_page.dart`

#### Função de Construção (Linha 1023)

```dart
buildUnAuthorized(BuildContext context) {
```

#### Checkbox "Lembrar Técnico" (Linha ~1056-1077)

```dart
Obx(() => Padding(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: CheckboxListTile(
    value: rememberTechnician.value,
    onChanged: (value) {
      rememberTechnician.value = value ?? false;
    },
    title: Text(
      translate('Remember this technician'),
      style: TextStyle(fontSize: 13),
    ),
    subtitle: Text(
      translate('Auto-approve this technician on next connection'),
      style: TextStyle(fontSize: 11, color: Colors.grey),
    ),
  ),
))
```

#### Botão "Accept" com Integração (Linha ~1082-1095)

```dart
buildButton(
  context,
  color: MyTheme.accent,
  onClick: () {
    if (rememberTechnician.value) {
      // ⭐ QUANDO USUÁRIO MARCAR E CLICAR ACCEPT
      model.setRememberTechnician(client.peerId, true);
    }
    handleAccept(context);
    windowManager.minimize();  // ⭐ MINIMIZA APP
  },
  text: 'Accept',
  textColor: Colors.white,
)
```

---

### 4. Widget de Gerenciamento Visual

**Arquivo:** `flutter/lib/desktop/widgets/trusted_technicians_widget.dart`

#### Classe Widget (Linha 12)

```dart
class TrustedTechniciansWidget extends StatefulWidget {
  const TrustedTechniciansWidget({Key? key, this.onTechniciansChanged});
}
```

#### Renderização de Lista (Linha ~70+)

```dart
Obx(() {
  final technicians = _model.trustedPeerIds;

  if (technicians.isEmpty) {
    // Mostra mensagem "Nenhum técnico ainda"
    return /* empty state widget */;
  }

  return ListView.builder(
    itemCount: technicians.length,
    itemBuilder: (context, index) {
      final peerId = technicians[index];
      return ListTile(
        title: Text(_model.getTechnicianName(peerId)),
        subtitle: Text(_model.getTechnicianTimestamp(peerId)),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _removeTechnician(peerId),
        ),
      );
    },
  );
})
```

#### Remover Técnico (Função privada)

```dart
Future<void> _removeTechnician(String peerId) async {
  await _model.removeTrustedTechnician(peerId);
  widget.onTechniciansChanged?.call();
}

Future<void> _clearAll() async {
  // Loop remover todos
  for (String peerId in _model.trustedPeerIds.toList()) {
    await _model.removeTrustedTechnician(peerId);
  }
  widget.onTechniciansChanged?.call();
}
```

---

### 5. Traduções

#### Português Brasileiro

**Arquivo:** `src/lang/ptbr.rs` (Linha ~278-288)

```rust
("Remember this technician", "Lembrar deste técnico"),
("Auto-approve this technician on next connection", "Auto-aprovar este técnico na próxima conexão"),
("Trusted Technicians", "Técnicos Confiáveis"),
("trusted_technicians_description", "Gerencie técnicos remotos que podem se conectar automaticamente sem diálogos de confirmação."),
("No trusted technicians yet", "Nenhum técnico confiável ainda"),
("trusted_technicians_list", "Lista de Técnicos Confiáveis"),
("from trusted technicians?", "dos técnicos confiáveis?"),
("Clear All Trusted Technicians", "Limpar Todos os Técnicos Confiáveis"),
("Are you sure you want to remove all trusted technicians?", "Tem certeza que deseja remover todos os técnicos confiáveis?"),
```

#### English

**Arquivo:** `src/lang/en.rs` (Linha ~84-94)

```rust
("Remember this technician", "Remember this technician"),
("Auto-approve this technician on next connection", "Auto-approve this technician on next connection"),
("Trusted Technicians", "Trusted Technicians"),
("trusted_technicians_description", "Manage remote technicians that can connect automatically without confirmation dialogs."),
("No trusted technicians yet", "No trusted technicians yet"),
("Check the checkbox when accepting a connection to add to trusted list", "Check the checkbox when accepting a connection to add to trusted list"),
("from trusted technicians?", "from trusted technicians?"),
("Clear All Trusted Technicians", "Clear All Trusted Technicians"),
("Are you sure you want to remove all trusted technicians?", "Are you sure you want to remove all trusted technicians?"),
```

---

## 🔄 Fluxo de Execução (Passo a Passo)

### Quando Técnico Se Conecta (1ª Vez)

```
┌─────────────────────────────────────────────────────────┐
│ 1. RustDesk detecta conexão remota                      │
│    → Chama: showLoginDialog(client)                     │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (server_model.dart, linha ~615)
┌─────────────────────────────────────────────────────────┐
│ 2. Verifica: isTrustedTechnician(client.peerId)?         │
│    ❌ Resultado: NÃO (primeira vez)                     │
│    → Continua para o diálogo                            │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (server_page.dart, linha ~1023)
┌─────────────────────────────────────────────────────────┐
│ 3. Constrói UI: buildUnAuthorized()                     │
│    - Mostra: CheckboxListTile (Remember)                │
│    - Botão: Accept / Cancel                             │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (Usuário marca ☑ e clica Accept)
┌─────────────────────────────────────────────────────────┐
│ 4. onClick handler chamado (linha ~1089):               │
│    if (rememberTechnician.value) {                      │
│        model.setRememberTechnician(client.peerId, true) │
│    }                                                    │
│    handleAccept(context)                               │
│    windowManager.minimize()                            │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (server_model.dart, linha ~717)
┌─────────────────────────────────────────────────────────┐
│ 5. sendLoginResponse(client, true) executado            │
│    if (_rememberTechnicianFlags[peerId] == true) {       │
│        await _trustedTechnicianModel.addTrustedTechnician(│
│            peerId: peerId,                              │
│            technicianName: name                         │
│        )                                                │
│    }                                                    │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (trusted_technician_model.dart, linha ~69)
┌─────────────────────────────────────────────────────────┐
│ 6. addTrustedTechnician() executa:                       │
│    - trustedPeerIds.add(peerId)                         │
│    - mainSetLocalOption(key, value) → salva no disco    │
│    - Armazena nome + timestamp                          │
└────────────┬────────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────────┐
│ ✅ RESULTADO: Técnico salvo como CONFIÁVEL              │
│    App minimiza e técnico consegue acesso              │
└─────────────────────────────────────────────────────────┘
```

### Quando Técnico Se Conecta (2ª Vez+)

```
┌─────────────────────────────────────────────────────────┐
│ 1. RustDesk detecta conexão remota                      │
│    → Chama: showLoginDialog(client)                     │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (server_model.dart, linha ~615)
┌─────────────────────────────────────────────────────────┐
│ 2. Verifica: isTrustedTechnician(client.peerId)?         │
│    ✅ Resultado: SIM (está na lista)                    │
│    → Auto-aprova silenciosamente                        │
│    → return (não mostra diálogo)                        │
└────────────┬────────────────────────────────────────────┘
             │
             ▼ (server_model.dart, linha ~617)
┌─────────────────────────────────────────────────────────┐
│ 3. Chama: sendLoginResponse(client, true)               │
│    ✅ Auto-aprovação automática                         │
│    ✅ App minimiza (não há código aqui, mas foi antes)  │
│    ✅ Técnico consegue acesso                           │
└────────────┬────────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────────┐
│ ✅ RESULTADO: Acesso INSTANTÂNEO                        │
│    - Sem diálogo                                        │
│    - Sem confirmação                                    │
│    - Em background                                      │
│    - Silencioso                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 Como Modificar a Funcionalidade

### Adicionar Nova Permissão ao Técnico

**Editar:** `trusted_technician_model.dart`

```dart
// Adicionar novo campo
final trustedMap = RxMap<String, Map<String, dynamic>>({});

// Modificar addTrustedTechnician para incluir permissões
Future<void> addTrustedTechnician({
  required String peerId,
  required String technicianName,
  Map<String, dynamic>? permissions,  // ← NOVO
}) async {
  // ... código existente ...

  // ← ADICIONAR
  if (permissions != null) {
    await bind.mainSetLocalOption(
      key: '${kTrustedTechNamePrefix}${peerId}_permissions',
      value: jsonEncode(permissions),
    );
  }
}
```

### Adicionar Expiração de Autorização

**Editar:** `trusted_technician_model.dart`

```dart
// Verificar se expirou (exemplo: 90 dias)
bool isTrustedTechnician(String peerId) {
  if (!trustedPeerIds.contains(peerId)) return false;

  final timestamp = getTechnicianTimestamp(peerId);
  if (timestamp.isEmpty) return false;

  final authDate = DateTime.parse(timestamp);
  final now = DateTime.now();
  final daysDiff = now.difference(authDate).inDays;

  // Expirar após 90 dias
  if (daysDiff > 90) {
    removeTrustedTechnician(peerId);
    return false;
  }

  return true;
}
```

### Adicionar Notificação quando Técnico Conecta

**Editar:** `server_model.dart`, função `showLoginDialog()`

```dart
void showLoginDialog(Client client) {
  if (_trustedTechnicianModel.isTrustedTechnician(client.peerId)) {
    debugPrint('Auto-aprovando técnico confiável: ${client.name}');

    // ← NOVO: Mostrar notificação
    parent.target?.invokeMethod("show_notification", {
      "title": "Conexão Remota",
      "message": "${client.name} conectou como técnico confiável",
      "timeout": 3000,
    });

    sendLoginResponse(client, true);
    return;
  }
  showClientDialog(...);
}
```

---

## 📊 Diagrama de Dados

```
Estrutura em Disco (config.toml):
┌────────────────────────────────────────┐
│ [Settings]                             │
├────────────────────────────────────────┤
│ trusted_technicians_list = [           │
│   "peer_id_abc123",                    │
│   "peer_id_def456"                     │
│ ]                                      │
│                                        │
│ trusted_tech_peer_id_abc123_name =     │
│   "João - Suporte Técnico"             │
│                                        │
│ trusted_tech_peer_id_abc123_timestamp =│
│   "2026-04-04T15:30:00.000Z"           │
│                                        │
│ trusted_tech_peer_id_def456_name =     │
│   "Maria - TI"                         │
│                                        │
│ trusted_tech_peer_id_def456_timestamp =│
│   "2026-04-03T10:15:00.000Z"           │
└────────────────────────────────────────┘
```

---

## 🚀 Linhas de Código Críticas

| Função                     | Arquivo                       | Linha | O que faz                            |
| -------------------------- | ----------------------------- | ----- | ------------------------------------ |
| `loadTrustedTechnicians()` | trusted_technician_model.dart | 27    | Carrega lista do disco               |
| `isTrustedTechnician()`    | trusted_technician_model.dart | 111   | **Verificação de auto-aprovação**    |
| `addTrustedTechnician()`   | trusted_technician_model.dart | 69    | Salva técnico como confiável         |
| `showLoginDialog()`        | server_model.dart             | ~615  | **PONTO DE AUTO-APROVAÇÃO**          |
| `sendLoginResponse()`      | server_model.dart             | ~717  | Processa resposta e salva se marcado |
| `CheckboxListTile`         | server_page.dart              | ~1059 | Renderiza checkbox na UI             |
| `setRememberTechnician()`  | server_model.dart             | ~737  | Marca intenção do usuário            |

---

## 🔗 Relacionamentos entre Arquivos

```
server_model.dart
    ├─→ TrustedTechnicianModel (contains)
    │   └─→ Usa bind.mainGetLocalOption/SetLocalOption
    ├─→ server_page.dart (references)
    │   ├─→ buildUnAuthorized() usa checkbox
    │   └─→ Chama setRememberTechnician() do model
    └─→ Chama sendLoginResponse() que salva ao model

trusted_technicians_widget.dart
    ├─→ TrustedTechnicianModel (obtém via Provider)
    └─→ Renderiza lista de técnicos
```

---

## 📝 Resumo para Modificações

1. **Lógica de Auto-Aprovação:** `server_model.dart`, `showLoginDialog()`
2. **UI de Checkbox:** `server_page.dart`, `buildUnAuthorized()`
3. **Armazenamento:** `trusted_technician_model.dart`, todas as funções
4. **Gerenciamento:** `trusted_technicians_widget.dart`, renderização
5. **Tradução:** `src/lang/ptbr.rs` e `src/lang/en.rs`

---

**Documento criado para facilitar manutenção e desenvolvimento futuro. 🚀**
