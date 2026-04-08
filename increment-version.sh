#!/bin/bash
# Script para incrementar versão patch no Cargo.toml e gerar novo .deb

set -e

CARGO_FILE="Cargo.toml"
CURRENT_VERSION=$(grep '^version = ' "$CARGO_FILE" | sed 's/version = "\(.*\)"/\1/')

echo "Versão atual: $CURRENT_VERSION"

# Extrair major.minor e patch
MAJOR_MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f1-2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)

# Incrementar patch
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR_MINOR.$NEW_PATCH"

echo "Nova versão: $NEW_VERSION"

# Atualizar Cargo.toml
sed -i "s/^version = \"$CURRENT_VERSION\"/version = \"$NEW_VERSION\"/" "$CARGO_FILE"

# Git commit
git add "$CARGO_FILE"
git commit -m "chore: versão $NEW_VERSION"

echo "✅ Versão atualizada para $NEW_VERSION"
echo "✅ Commit realizado"
