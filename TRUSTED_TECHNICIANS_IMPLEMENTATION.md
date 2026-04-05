# RustDesk - Funcionalidade de Técnicos Confiáveis (Trusted Technicians)

## 📋 Visão Geral

Esta implementação permite que o usuário host de uma máquina RustDesk autorize técnicos/máquinas remotas para acessarem **sem confirmação de permissão repetida**, com a aplicação rodando em background. Após autorizar uma vez e marcar "Lembrar este técnico", as próximas conexões deste técnico serão **auto-aprovadas silenciosamente**.

## 🎯 Objetivo Educacional

Esta funcionalidade foi implementada para fins educacionais, permitindo demonstrar:

1. **Gerenciamento de permissões permanentes** em aplicações de controle remoto
2. **Persistência de dados** em aplicações Flutter
3. **Auto-aprovação de conexões** baseada em histórico confiável
4. **Integração Flutter-Rust** para armazenamento seguro

## 🚀 Como Funciona

### Fluxo de Uso:

```
┌─────────────────────────────────────────────────────┐
│ Técnico tenta se conectar pela 1ª vez              │
└────────────┬────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────┐
│ Diálogo de Aceitação apareça com novo checkbox:     │
│ ☐ "Lembrar este técnico"                            │
│ [Aceitar] [Cancelar]                                │
└────────────┬────────────────────────────────────────┘
             │
             ▼ (Se marcar checkbox e clicar Aceitar)
┌─────────────────────────────────────────────────────┐
│ Sistema salva peer_id do técnico como "confiável"  │
│ - Armazena em disco (config local)                 │
│ - Minimiza/App vai para background                 │
└────────────┬────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────┐
│ Próxima conexão do MESMO técnico:                   │
│ - Sistema detecta peer_id conhecido                │
│ - ✅ AUTO-APROVA SILENCIOSAMENTE                    │
│ - Sem diálogo de confirmação                        │
│ - Sessão iniciada imediatamente                     │
└─────────────────────────────────────────────────────┘
```

## 📁 Arquivos Implementados

### 1. **Novo: Modelo de Técnicos Confiáveis**
- **Arquivo**: `flutter/lib/models/trusted_technician_model.dart`
- **Responsabilidade**: 
  - Gerenciar lista de técnicos confiáveis
  - Persistir dados de autorização
  - Verificar se um técnico é confiável

**Classe Principal**: `TrustedTechnicianModel`
- `addTrustedTechnician()` - Adiciona técnico à lista
- `removeTrustedTechnician()` - Remove de confiáveis
- `isTrustedTechnician()` - Verifica se é confiável
- `loadTrustedTechnicians()` - Carrega do armazenamento

### 2. **Novo: Widget de Gerenciamento**
- **Arquivo**: `flutter/lib/desktop/widgets/trusted_technicians_widget.dart`
- **Responsabilidade**: 
  - Listar técnicos confiáveis
  - Permitir remover da lista
  - Limpar todos os técnicos

**Widget**: `TrustedTechniciansWidget`
- Exibe lista visual de técnicos
- Permite remover individual ou em lote
- Mostra data de autorização

### 3. **Modificado: Server Model**
- **Arquivo**: `flutter/lib/models/server_model.dart`
- **Mudanças**:
  - Integração com `TrustedTechnicianModel`
  - Modified `showLoginDialog()` - Auto-aprovação para técnicos confiáveis
  - Modified `sendLoginResponse()` - Salva técnico se checkbox marcado
  - Nova flag tracking: `_rememberTechnicianFlags`

### 4. **Modificado: Server Page (Desktop)**
- **Arquivo**: `flutter/lib/desktop/pages/server_page.dart`
- **Mudanças**:
  - Added checkbox "Lembrar este técnico" ao diálogo `buildUnAuthorized()`
  - Integração com servidor para salvar ao aceitar

### 5. **Modificado: Arquivos de Tradução**
- **Arquivo**: `src/lang/template.rs` (template master)
- **Arquivo**: `src/lang/ptbr.rs` (português brasileiro)
- **Arquivo**: `src/lang/en.rs` (English)

**Strings adicionadas**:
- "Remember this technician"
- "Auto-approve this technician on next connection"
- "Trusted Technicians"
- "trusted_technicians_description"
- E mais para UI do gerenciamento

## 🔧 Como Compilar

### Requisitos:
- Flutter SDK (última versão)
- Rust toolchain (para o bridge)
- Cargo

### Passos:

```bash
# 1. Entrar no diretório do projeto
cd /home/dodo/Downloads/rustdesk

# 2. Listar linguagens disponíveis para atualização
python3 res/lang.py

# 3. Compilar versão desktop Flutter
python3 build.py --flutter --release

# ou para modo debug (mais rápido)
python3 build.py --flutter

# 4. Alternativa: Build direto com cargo
cargo build --release --features flutter
```

## 📱 Como Usar

### Como Host (Máquina Compartilhada):

1. **Primeira conexão de um técnico**:
   - Técnico tenta conectar via seu ID/código
   - Você vê diálogo: "Do you accept?"
   - ✅ Marque: "Lembrar este técnico"
   - Clique "Accept"
   - Aplicação minimiza e funciona em background

2. **Próxima conexão do mesmo técnico**:
   - Nenhum diálogo
   - Acesso automático
   - App minimiza automaticamente

3. **Gerenciar técnicos confiáveis**:
   - Vá para Configurações → Técnicos Confiáveis
   - Veja lista de técnicos autorizados
   - Remova individual ou limpe todos

### Identificação de Técnico:

O sistema usa o **peer_id** (ID único da máquina remota):
- Gerado automaticamente pelo RustDesk
- Identificador permanente
- Pode ser visualizado em Configurações → Meu ID

Exemplo armazenagem:
```
trusted_technicians_list = ["peer_id_1", "peer_id_2", "peer_id_3"]
trusted_tech_peer_id_1_name = "João - Técnico"
trusted_tech_peer_id_1_timestamp = "2026-03-28T15:30:00.000000Z"
```

## 🔐 Segurança & Considerações

### ⚠️ Riscos:

1. **Permissão Permanente**: Uma vez adicionado, técnico sempre conseguirá acessar
   - Solução: Rever regularmente lista de técnicos
   - Solução: Remover da lista quando não mais necessário

2. **Sem Confirmação Visual**: Host não vê diálogo
   - Tecnicamente seguro, mas sem feedback
   - Sessão remota aparecerá normalmente

3. **Fingerprint Spoofing**: Se alguém falsificar peer_id
   - Mitigado pelo protocolo de autenticação RustDesk
   - Recomendado usar com senhas fortes também

### ✅ Boas Práticas:

1. **Permitir apenas técnicos confiáveis**
2. **Revisar lista regularmente**
3. **Remover quando não mais necessário**
4. **Usar em combinação com senhas**
5. **Monitor conexões remotas**

## 🔍 Localização de Dados

Os dados são armazenados na configuração local do RustDesk:

```bash
# Linux
~/.config/rustdesk/config.toml

# Windows
C:\Users\{USER}\AppData\Roaming\RustDesk\config.toml

# macOS
~/Library/Application Support/rustdesk/config.toml
```

Chaves armazenadas:
- `trusted_technicians_list` → JSON array de peer_ids
- `trusted_tech_{peer_id}_name` → Nome do técnico
- `trusted_tech_{peer_id}_timestamp` → Data autorização

## 🧪 Testando a Funcionalidade

### Teste Manual:

```bash
# 1. Compilar
python3 build.py --flutter

# 2. Rodar desktop mode (listen)
./target/release/rustdesk  # ou executável correspondente

# 3. Em outra máquina, conectar e testar:
# - Primeira conexão: marque checkbox
# - Segunda conexão: auto-aprovar
# - Verificar em Configurações: deve aparecer técnico
```

### Debug Logs:

O sistema printa logs quando auto-aprova:
```
Auto-aprovando técnico confiável: João - Técnico (abc123)
```

## 🎓 Educacional - Pontos-Chave Aprendidos

1. **Persistência em Flutter**:
   - Uso de `bind.mainSetLocalOption()` / `bind.mainGetLocalOption()`
   - Serialização JSON

2. **Padrão Observer (Getx)**:
   - Uso de `RxList`, `RxMap` para reatividade
   - `Obx()` para rebuilds automáticos

3. **Integração Bridge Flutter-Rust**:
   - Como Flutter chama funções Rust
   - Como passar dados entre camadas

4. **Segurança de Aplicação**:
   - Fingerprinting de devices
   - Tokens persistentes

5. **UX/UI**:
   - Checkboxes com confirmação
   - Listas com ações (remover)
   - Dialogs de confirmação

## 📝 Próximas Melhorias Sugeridas

1. **Criptografia**: Criptografar dados salvos em disco
2. **Expires**: Adicionar expiração de autorização (ex: 90 dias)
3. **Notificações**: Notificar host quando técnico confiável conecta
4. **Controle de Permissões**: Diferentes níveis por técnico
5. **Auditoria**: Log de todas as conexões de técnicos confiáveis
6. **Mobile**: Implementar em Android/iOS também

## 📚 Referências

- **RustDesk Repository**: https://github.com/rustdesk/rustdesk
- **Flutter Documentation**: https://flutter.dev/docs
- **RustDesk Architecture**: Veja [CLAUDE.md](./CLAUDE.md)

## 💬 Perguntas Frequentes

**P: Como remover um técnico da lista de confiáveis?**
R: Vá para Configurações → Técnicos Confiáveis → Clique no ícone de remover

**P: Um técnico removido consegue conectar de novo?**
R: Sim, mas com diálogo de confirmação novamente

**P: Posso ver quando um técnico se conectou?**
R: Sim, a data está em "Added" na lista

**P: E se esquecer de desmarcar o checkbox?**
R: Nenhum problema, apenas significa que será auto-aprovado próxima vez

**P: Funciona em mobile também?**
R: Não na versão atual, apenas desktop. Mobile pode ser adicionado depois.

---

## 🎉 Conclusão

Esta funcionalidade simplifica **muito** o acesso remoto para técnicos de suporte, eliminando a necessidade de cliques repetitivos de confirmação enquanto mantém a segurança através da identificação única de device (peer_id).

**Para fins educacionais**, demonstra práticamente como implementar:
- Persistência de dados
- Auto-aprovação baseada em histórico
- Integração Flutter-Rust
- Gerenciamento de permissões

Qualquer dúvida ou sugestão, consulte o código implementado nos arquivos listados acima! 🚀
