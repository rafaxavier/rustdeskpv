#!/bin/bash

# Pre-flight checklist for RustDesk compilation
# Verifies that all prerequisites are met before attempting build

echo "🔍 RustDesk Build Pre-flight Checklist"
echo "======================================"
echo ""

CHECKS_PASSED=0
CHECKS_FAILED=0

check_command() {
    local cmd=$1
    local name=$2
    
    if command -v $cmd &> /dev/null; then
        echo "✅ $name found"
        ((CHECKS_PASSED++))
        return 0
    else
        echo "❌ $name NOT found"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_directory() {
    local dir=$1
    local name=$2
    
    if [ -d "$dir" ]; then
        echo "✅ $name found at $dir"
        ((CHECKS_PASSED++))
        return 0
    else
        echo "❌ $name NOT found at $dir"
        ((CHECKS_FAILED++))
        return 1
    fi
}

check_package() {
    local pkg=$1
    local name=$2
    
    if dpkg -l | grep -q "^ii.*$pkg"; then
        echo "✅ System package $name installed"
        ((CHECKS_PASSED++))
        return 0
    else
        echo "⚠️  System package $name NOT installed (will be needed)"
        ((CHECKS_FAILED++))
        return 1
    fi
}

# Check Rust
echo "Checking Rust toolchain..."
check_command rustc "Rust compiler"
check_command cargo "Cargo package manager"

# Get Rust version
RUST_VERSION=$(rustc --version 2>/dev/null)
echo "   Version: $RUST_VERSION"
echo ""

# Check Flutter
echo "Checking Flutter SDK..."
if [ -d "/home/dodo/flutter" ]; then
    echo "✅ Flutter SDK found at /home/dodo/flutter"
    ((CHECKS_PASSED++))
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version 2>&1 | head -1)
        echo "   Version: $FLUTTER_VERSION"
    fi
else
    echo "⚠️  Flutter SDK not in PATH but may be available"
fi
echo ""

# Check VCPKG
echo "Checking VCPKG..."
check_directory "/home/dodo/vcpkg" "VCPKG"
echo ""

# Check system packages
echo "Checking system packages..."
check_package "libxcb-randr0-dev" "libxcb-randr0-dev"
check_package "libxcb-dev" "libxcb-dev"
check_package "libx11-dev" "libx11-dev"
check_package "libgtk-3-dev" "libgtk-3-dev"
echo ""

# Check disk space
echo "Checking disk space..."
DISK_FREE=$(df -BG /home/dodo/Downloads/rustdesk | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$DISK_FREE" -gt 20 ]; then
    echo "✅ Free disk space: ${DISK_FREE}GB (needed: 20GB)"
    ((CHECKS_PASSED++))
else
    echo "❌ Low disk space: ${DISK_FREE}GB (needed: 20GB)"
    ((CHECKS_FAILED++))
fi
echo ""

# Summary
echo "======================================"
echo "Summary:"
echo "  ✅ Passed: $CHECKS_PASSED"
echo "  ❌ Failed: $CHECKS_FAILED"
echo ""

if [ $CHECKS_FAILED -eq 0 ]; then
    echo "🎉 All checks passed! Ready to compile."
    echo ""
    echo "Next step: bash build.sh"
    exit 0
else
    echo "⚠️  Some checks failed. Please address above issues."
    echo ""
    if ! dpkg -l | grep -q "^ii.*libxcb-randr0-dev"; then
        echo "Quick fix - install missing packages:"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install -y libxcb-randr0-dev libxcb-dev libx11-dev libgtk-3-dev libpulse-dev"
        echo ""
    fi
    echo "Then try again: bash preflight.sh"
    exit 1
fi
