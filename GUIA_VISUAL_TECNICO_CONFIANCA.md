# 📸 Guia Visual - Como Usar Técnicos de Confiança

**Passo-a-passo com screenshots simulados**

---

## 🎬 Cenário 1: Primeira Conexão (Seu Técnico Conectando)

### Passo 1️⃣ - Seu Técnico Tenta Conectar

**O que você vê no seu computador (Host):**

```
┌─────────────────────────────────────────────────────────────┐
│  RustDesk - Aguardando Conexão                              │
│                                                             │
│  Seu ID: 1 975 331 036                                      │
│  Senha: ••••••••••                                          │
│                                                             │
│  Status: ⏳ Conectando com João - TechSupport (192.168.1.50)│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Passo 2️⃣ - Diálogo de Aceitação Aparece

**O diálogo que você vê:**

```
╔═════════════════════════════════════════════════════════╗
║           Do you accept?                        [X]     ║
╠═════════════════════════════════════════════════════════╣
║                                                         ║
║  From: João - TechSupport                              ║
║  IP: 192.168.1.50                                      ║
║  Request: Share screen                                 ║
║                                                         ║
║  ☐ Remember this technician                             ║
║    Auto-approve this technician on next connection     ║
║                                                         ║
║           [Accept]         [Cancel]                     ║
║           [Accept and Elevate]                          ║
║                                                         ║
╚═════════════════════════════════════════════════════════╝
```

### Passo 3️⃣ - Você Marca o Checkbox

**Seu ação:**

```
Você vê o checkbox vazio:
┌─────────────────────────────────────────────────────────┐
│ ☐ Remember this technician                              │
│   Auto-approve this technician on next connection      │
└─────────────────────────────────────────────────────────┘

Você clica no checkbox:
┌─────────────────────────────────────────────────────────┐
│ ☑ Remember this technician ← MARCADO                    │
│   Auto-approve this technician on next connection      │
└─────────────────────────────────────────────────────────┘
```

### Passo 4️⃣ - Você Clica "Accept"

**Sua ação:**

```
Antes:
╔══════════════════════════════════╗
║ [Accept]   [Cancel]              ║
╚══════════════════════════════════╝

Você clica em "Accept" ← COM O CHECKBOX MARCADO

Resultado:
✅ Diálogo fecha
✅ Acesso concedido
✅ App minimiza
✅ Técnico consegue acessar sua máquina
```

### Resultado Final da Primeira Conexão

```
┌─────────────────────────────────────────────────────────┐
│  ✅ SUCESSO                                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  • Diálogo desapareceu                                  │
│  • João tem acesso à sua máquina                        │
│  • RustDesk foi minimizado para a bandeja               │
│  • "João - TechSupport" foi salvo como técnico confiável│
│                                                         │
│  Dados armazenados:                                      │
│  ├─ peer_id: abc123xyz789                              │
│  ├─ name: João - TechSupport                           │
│  └─ timestamp: 2026-04-04 15:30:00                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🎬 Cenário 2: Segunda Conexão (Automática)

### Passo 1️⃣ - Seu Técnico Conecta Novamente

**O que você vê no seu computador (Host):**

```
┌─────────────────────────────────────────────────────────────┐
│  RustDesk - Aguardando Conexão                              │
│                                                             │
│  Seu ID: 1 975 331 036                                      │
│  Senha: ••••••••••                                          │
│                                                             │
│  Status: ⏳ Conectando com João - TechSupport (192.168.1.50)│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Passo 2️⃣ - NÃO HÁ DIÁLOGO

**O que diferente desta vez:**

```
❌ NENHUM DIÁLOGO APARECE

Diretamente:
┌─────────────────────────────────────────────────────────┐
│  ✅ CONECTADO                                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Status: João - TechSupport está conectado              │
│  Tempo conectado: 0:05                                  │
│                                                         │
│  [Abrir Sessão] [Desconectar] [Informações]            │
│                                                         │
│  Nota: App minimizou automaticamente                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Resultado: Fluxo Automático

```
Sistema:
1. João conecta → 
2. Sistema verifica "é técnico confiável?" → 
3. ✅ SIM → 
4. Auto-aprova imediatamente → 
5. Nenhum diálogo → 
6. App fica em background → 
7. João consegue acessar

⏱️ Tempo total: < 1 segundo
👤 Intervenção do usuário: NENHUMA
```

---

## 🎬 Cenário 3: Gerenciar Técnicos Confiáveis

### Passo 1️⃣ - Abrir Configurações

**Localização:** Menu → Settings

```
┌───────────────────────┐
│ ☰ Menu                │
├───────────────────────┤
│ • Preferences         │
│ • Settings ← CLIQUE   │
│ • About               │
│ • Help                │
└───────────────────────┘
```

### Passo 2️⃣ - Procurar "Técnicos Confiáveis"

**Na janela de Settings:**

```
╔═════════════════════════════════════════════════════╗
║  RustDesk Settings                          [X]    ║
╠═════════════════════════════════════════════════════╣
║                                                    ║
║  Left Panel:                                       │
║  ├─ General                                        │
║  ├─ Security                                       │
║  ├─ Connection                                     │
║  ├─ Keyboard                                       │
║  ├─ Display                                        │
║  └─ Trusted Technicians ← AQUI                    ║
║                                                    │
│  Right Panel: [Conteúdo muda]                      │
│                                                    │
╚═════════════════════════════════════════════════════╝
```

### Passo 3️⃣ - Ver Lista de Técnicos

**O que você vê ao clicar:**

```
╔═════════════════════════════════════════════════════╗
║  Trusted Technicians                        [X]    ║
╠═════════════════════════════════════════════════════╣
║                                                    ║
║  Manage remote technicians that can connect      ║
║  automatically without confirmation dialogs.     ║
║                                                    ║
║  ┌───────────────────────────────────────────────┐ ║
║  │ 👤 João - TechSupport           [X] Remover  │ ║
║  │    Added: 2026-04-04 15:30:00                │ ║
║  │                                               │ ║
║  │ 👤 Maria - IT Support           [X] Remover  │ ║
║  │    Added: 2026-04-03 10:15:00                │ ║
║  │                                               │ ║
║  │ 👤 Carlos - Server Team         [X] Remover  │ ║
║  │    Added: 2026-04-01 09:45:00                │ ║
║  └───────────────────────────────────────────────┘ ║
║                                                    ║
║  [Clear All Trusted Technicians]                 ║
║                                                    ║
╚═════════════════════════════════════════════════════╝
```

### Passo 4️⃣ - Remover Um Técnico

**Se quer remover João:**

```
1. Clique em [X] próximo a "João - TechSupport"
   ↓
2. Confirmação? "Remover João?"
   ↓
3. Clique "Sim" ou "Confirmar"
   ↓
4. João removido da lista
   ↓
5. Próxima conexão de João: 
   → Diálogo aparecerá novamente
   → Precisará clicar "Accept" manualmente
```

### Passo 5️⃣ - Limpar Todos os Técnicos

**Se quer remover todos de uma vez:**

```
1. Clique em [Clear All Trusted Technicians]
   ↓
2. Confirmação: "Tem certeza que deseja remover 
   todos os técnicos confiáveis?"
   ↓
3. Clique "Sim" ou "Confirmar"
   ↓
4. ✅ Todos removidos
   ↓
5. Próximas conexões: 
   → Todos precisarão confirmar manualmente novamente
```

---

## 🎬 Cenário 4: Diferentes Modos de Aceitar

### Opção 1: Apenas "Accept"

```
Diálogo:
┌─────────────────────────────┐
│ ☑ Remember this technician  │
│                             │
│ [Accept]      [Cancel]      │
└─────────────────────────────┘

Resultado:
✅ Técnico conecta
✅ Auto-aprovará próxima vez
✅ Sem elevação de privilégio
```

### Opção 2: "Accept and Elevate" (Windows/Admin)

```
Diálogo:
┌──────────────────────────────────┐
│ ☑ Remember this technician       │
│                                  │
│ [Accept and Elevate] [Cancel]    │
│ [Accept]                         │
└──────────────────────────────────┘

Resultado:
✅ Técnico conecta COM privilégios elevados
✅ Auto-aprovará próxima vez (com elevação)
✅ Máxima permissão para o técnico
```

### Opção 3: Rejeitar (Sem Marcar)

```
Diálogo:
┌─────────────────────────────┐
│ ☐ Remember this technician  │
│                             │
│ [Accept]      [Cancel]      │
│   ↑ Clique aqui
└─────────────────────────────┘

Resultado:
❌ Técnico não conecta
❌ Não será salvo como técnico
❌ Próxima vez: diálogo aparecerá novamente
```

### Opção 4: Aceitar SEM Marcar o Checkbox

```
Diálogo:
┌─────────────────────────────┐
│ ☐ Remember this technician  │ ← NÃO MARCADO
│                             │
│ [Accept]      [Cancel]      │
│   ↑ Clique aqui
└─────────────────────────────┘

Resultado:
✅ Técnico conecta AGORA
❌ NÃO será salvo como técnico confiável
❌ Próxima vez: diálogo aparecerá novamente
   (Você precisará confirmar manualmente cada vez)
```

---

## 🔄 Fluxograma Visual Completo

```
                    ┌─────────────────────┐
                    │ Técnico Tenta       │
                    │ Conectar            │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │ Sistema Verifica:   │
                    │ É técnico           │
                    │ confiável?          │
                    └──────┬───────┬──────┘
                           │       │
                ┌──────────┘       └──────────┐
                │ ✅ SIM                       │ ❌ NÃO
                │                             │
                ▼                             ▼
    ┌──────────────────────┐    ┌───────────────────────────┐
    │ AUTO-APROVA          │    │ MOSTRA DIÁLOGO            │
    │ • Sem diálogo        │    │ • Checkbox "Remember"     │
    │ • Silencioso         │    │ • Botões: Accept/Cancel   │
    │ • Background         │    │ • Aguarda decisão         │
    │ • Acesso imediato    │    │                           │
    └──────────┬───────────┘    └────────┬──────────────────┘
               │                         │
               │              ┌──────────┼──────────┐
               │              │          │          │
               │    ┌─────────┘  ┌──────┴─┐  ┌────┴─────┐
               │    │            │        │  │          │
               │    ▼            ▼        ▼  ▼          ▼
               │  Accept    Cancel   Reject Accept&  Cancel
               │  + Remember              Elevate
               │    │                │      │
               │    ▼                ▼      ▼
               │  ┌──────┐      ┌────────┐ ┌───┐
               │  │ Salva│      │Desconec│ │Sal│
               │  │Técni-│      │ta      │ │va │
               │  │co    │      │        │ │ + │
               │  └──────┘      └────────┘ │Ele│
               │                           │va │
               │                           └───┘
               │
               └──────────────┬───────────────────┐
                              │                   │
                              ▼                   ▼
                    ┌────────────────┐  ┌──────────────┐
                    │ Próxima Conexão│  │ Próxima      │
                    │ AUTO (Silencio)│  │ Conexão      │
                    │ Sem diálogo    │  │ Com Diálogo  │
                    └────────────────┘  └──────────────┘
```

---

## 📋 Checklist de Uso

### ✅ Primeira Vez Usando

- [ ] Instale RustDesk atualizado
- [ ] Abra em modo Listen/Server
- [ ] Aguarde técnico conectar
- [ ] Veja diálogo de aceitação aparecer
- [ ] Marque checkbox "Remember"
- [ ] Clique "Accept"
- [ ] App minimiza automaticamente
- [ ] Técnico tem acesso

### ✅ Segunda Conexão do Mesmo Técnico

- [ ] Técnico conecta novamente
- [ ] Verifique: Nenhum diálogo aparece ✓
- [ ] Acesso é concedido automaticamente
- [ ] App fica em background

### ✅ Gerenciar Técnicos

- [ ] Abra Settings
- [ ] Vá para "Trusted Technicians"
- [ ] Veja lista de todos autorizados
- [ ] Teste remover um técnico
- [ ] Teste "Clear All"
- [ ] Verifique que próxima conexão pede confirmação

### ✅ Segurança

- [ ] Revise lista de técnicos mensalmente
- [ ] Remova técnicos não mais necessários
- [ ] Use senhas fortes também
- [ ] Monitore conexões incomuns

---

## 🚀 Dicas Profissionais

### ✨ Melhor Prática 1: Nomes Descritivos
```
❌ Ruim:
   client_1
   remote_user
   
✅ Bom:
   João - TechSupport
   Maria - IT Specialist - São Paulo
   Carlos - Database Admin
```

### ✨ Melhor Prática 2: Revisa Periódica
```
Recomendação:
├─ Mensal: Verifique lista
├─ A cada 3 meses: Remova técnicos inativos
├─ Anual: Limpe e reconfigure
└─ Sempre que mudar equipe: Atualize
```

### ✨ Melhor Prática 3: Combinação de Segurança
```
✅ Use em conjunto com:
├─ Senha permanente forte
├─ 2FA (se disponível)
├─ VPN ou rede privada
├─ Firewall
└─ Logs de conexão
```

### ✨ Melhor Prática 4: Testes
```
Sempre teste:
1. Primeira conexão: Diálogo aparece? ✓
2. Marcar checkbox: Salva? ✓
3. Segunda conexão: Automático? ✓
4. Remover técnico: Diálogo volta? ✓
```

---

## ❌ Problemas Comuns & Soluções

### Problema 1: Diálogo não aparece na primeira conexão

**Possível causa:** Técnico já está na lista confiável

**Solução:**
1. Abra Settings → Trusted Technicians
2. Procure pelo técnico
3. Clique "Remove"
4. Tente conectar novamente

### Problema 2: Segunda conexão ainda pede confirmação

**Possível causa:** Checkbox não foi marcado

**Solução:**
1. Na próxima conexão do técnico
2. Marque o checkbox
3. Clique "Accept"

### Problema 3: Não vejo "Trusted Technicians" em Settings

**Possível causa:** Versão antiga do RustDesk

**Solução:**
1. Atualize para versão mais recente
2. Ou recompile o projeto

### Problema 4: App não minimiza

**Possível causa:** Settings de minimização desabilitadas

**Solução:**
1. Verifique se auto-minimize está habilitada
2. Ou minimize manualmente

---

## 📞 Support Rápido

| Pergunta | Resposta |
|----------|----------|
| **Posso ter múltiplos técnicos?** | ✅ Sim, quantos precisar |
| **Posso remover individual?** | ✅ Sim, clique X ao lado do nome |
| **Posso remover todos de uma vez?** | ✅ Sim, "Clear All" |
| **Um técnico removido consegue conectar novamente?** | ✅ Sim, com diálogo |
| **Muda a senha permanente?** | ❌ Não, independente |
| **Funciona em mobile?** | ❌ Não, apenas desktop |

---

**Aproveite a funcionalidade! Qualquer dúvida, consulte o guia completo. 🎉**
