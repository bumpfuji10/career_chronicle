#!/bin/bash

echo "=== Ruby LSP Diagnostic Script ==="
echo ""

echo "1. Ruby version:"
ruby --version
echo ""

echo "2. Ruby path:"
which ruby
echo ""

echo "3. Bundle path:"
which bundle
echo ""

echo "4. Ruby LSP gem info:"
bundle info ruby-lsp
echo ""

echo "5. Ruby LSP executable:"
which ruby-lsp || echo "ruby-lsp command not found"
echo ""

echo "6. Bundle exec ruby-lsp version:"
bundle exec ruby-lsp --version
echo ""

echo "7. Environment variables:"
echo "BUNDLE_PATH: $BUNDLE_PATH"
echo "GEM_HOME: $GEM_HOME"
echo "GEM_PATH: $GEM_PATH"
echo ""

echo "8. Testing ruby-lsp initialization:"
cd /rails
bundle exec ruby-lsp --help | head -20
echo ""

echo "=== Diagnostic Complete ==="
