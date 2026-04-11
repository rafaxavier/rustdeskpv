# macOS Build Warnings - Explicação Técnica

## Problema

O build no GitHub Actions para macOS está gerando warnings de APIs deprecadas que vêm da biblioteca **Sciter** usada em `src/platform/macos.mm`:

### APIs Deprecadas

1. **`AuthorizationExecuteWithPrivileges`** (macOS 10.7+)
   - Usado em: `src/platform/macos.mm:103`
   - Deprecado desde: macOS 10.7
   - Motivo: Segurança - Apple recomenda usar `AuthorizationCopyRights` + `AuthorizationExecuteWithFlags`

2. **`CGDisplayModeCopyPixelEncoding`** (macOS 10.11+)
   - Usado em: `src/platform/macos.mm:141`
   - Deprecado desde: macOS 10.11
   - Motivo: Display management modernizado em versões recentes

## Por que funciona no Ubuntu local?

- Ubuntu não tem essas APIs do macOS
- O build local provavelmente está **apenas para Linux** (`./build-final.sh` é Linux-only)
- O GitHub Actions tenta compilar para **múltiplas plataformas** incluindo macOS

## Por que é um problema?

1. Os warnings são emitidos pelo compilador macOS (Xcode 15.4)
2. O build pode **falhar** se o projeto estiver configurado para tratar warnings como erros
3. Pode impedir releases automáticas

## Solução

Existem 3 abordagens:

### ✅ **Abordagem 1: Suprimir os warnings no build (RECOMENDADO)**

Modificar `build.py` para adicionar flags de compilação que suprimem esses warnings específicos.

### ✅ **Abordagem 2: Atualizar o código para APIs modernas**

Substituir as APIs deprecadas por suas alternativas modernas:
- `AuthorizationExecuteWithPrivileges` → `AuthorizationCopyRights` + `AuthorizationExecuteWithFlags`
- `CGDisplayModeCopyPixelEncoding` → APIs modernas de display

### ✅ **Abordagem 3: Desabilitar builds macOS no GitHub Actions**

Se o projeto é focado em Linux/Windows, remover os targets macOS do CI.

## Recomendação para você

Como você está focado no **Ubuntu/Linux** e o build funciona perfeitamente aí, recomendo:

1. **Curto prazo**: Suprimir os warnings no workflow (Abordagem 1)
2. **Longo prazo**: Contribuir com atualizações de API ao upstream RustDesk

