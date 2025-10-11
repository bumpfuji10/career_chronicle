# Ruby LSP トラブルシューティングチェックリスト

## 問題: VSCodeの出力パネルに何も表示されない

この問題は、Ruby LSP拡張機能が正しくインストールされていないか、起動していないことを示しています。

### ステップ1: 拡張機能の確認

1. **VSCodeの拡張機能パネルを開く** (Cmd+Shift+X)

2. **以下の拡張機能がインストールされているか確認**
   - ✅ `Shopify.ruby-lsp` (Ruby LSP) - **これが必要**

3. **以下の古い拡張機能がある場合はアンインストール**
   - ❌ `rebornix.Ruby` (古いRuby拡張)
   - ❌ `castwide.solargraph` (Solargraph)
   - ❌ `wingrunr21.vscode-ruby` (VSCode Ruby)

### ステップ2: Shopify.ruby-lspをインストール

もし`Shopify.ruby-lsp`がインストールされていない場合：

1. 拡張機能パネルで「ruby lsp」と検索
2. 「Ruby LSP」by Shopify を見つける
3. 「Install」をクリック
4. **重要**: Dev Containerで開いている場合は「Install in Container」を選択

### ステップ3: Dev Containerを再起動

```
コマンドパレット (Cmd+Shift+P) → "Dev Containers: Rebuild Container"
```

### ステップ4: Rubyファイルを開く

1. プロジェクト内の任意の`.rb`ファイルを開く（例: `test_ruby_lsp.rb`）
2. 数秒待つ
3. VSCode右下のステータスバーを確認

   **正常な場合**:
   - ステータスバーに「Ruby LSP」と表示される
   - 出力パネルに「Ruby LSP」が選択肢として表示される

   **異常な場合**:
   - 何も表示されない
   - エラーメッセージが表示される

### ステップ5: 出力パネルを確認

1. View → Output (または Cmd+Shift+U)
2. 右上のドロップダウンから「Ruby LSP」を選択
3. ログが表示されるはず

### ステップ6: マニュアル起動を試す

VSCode内で以下を実行：

1. コマンドパレット (Cmd+Shift+P) を開く
2. 「Ruby LSP: Restart」と入力して選択
3. 出力パネルでログを確認

### ステップ7: コンテナ内での動作確認

ターミナルで以下を実行して、コンテナ内でRuby LSPが動作するか確認：

```bash
docker compose exec app bash -c "cd /rails && bundle exec ruby-lsp --help"
```

正常に動作していれば、ヘルプメッセージが表示されます。

## よくある原因と解決方法

### 原因1: 古いRuby拡張機能との競合

**症状**: Ruby LSPが起動しない、または動作が不安定

**解決方法**:
- `rebornix.ruby`、`castwide.solargraph` などの古い拡張機能をアンインストール
- VSCodeをリロード (コマンドパレット → "Developer: Reload Window")

### 原因2: Ruby LSP拡張機能がコンテナにインストールされていない

**症状**: ローカルでは動作するが、Dev Container内で動作しない

**解決方法**:
- 拡張機能パネルで「Ruby LSP」を探す
- 「Install in Container」ボタンをクリック
- Dev Containerを再起動

### 原因3: Gemfileにruby-lsp gemが含まれていない

**症状**: 「ruby-lsp gem not found」エラー

**解決方法**:
```bash
# コンテナ内で確認
docker compose exec app bundle info ruby-lsp

# 見つからない場合
docker compose exec app bundle install
```

### 原因4: 設定ファイルの不整合

**症状**: 設定はあるのに動作しない

**解決方法**:
`.vscode/settings.json` を確認して、以下の設定があることを確認：

```json
{
  "rubyLsp.enabled": true,
  "rubyLsp.useBundler": true,
  "rubyLsp.bundleGemfile": "/rails/Gemfile"
}
```

### 原因5: VSCodeのバージョンが古い

**症状**: Ruby LSP拡張機能がインストールできない

**解決方法**:
- VSCodeを最新バージョンに更新
- 最小要件: VSCode 1.75.0以降

## デバッグ用コマンド

### Ruby LSPのバージョン確認
```bash
docker compose exec app bundle exec ruby-lsp --version
```

### Ruby LSPの診断実行
```bash
docker compose exec app bash -c "cd /rails && bundle exec ruby-lsp --doctor"
```

### Bundlerの状態確認
```bash
docker compose exec app bundle list | grep ruby-lsp
```

### Rubyのパス確認
```bash
docker compose exec app which ruby
docker compose exec app ruby --version
```

## それでも解決しない場合

以下の情報を収集してください：

1. VSCodeのバージョン: Help → About
2. Ruby LSP拡張機能のバージョン: 拡張機能パネルで確認
3. 出力パネルの「Ruby LSP」タブの内容（あれば）
4. コンテナ内での `bundle exec ruby-lsp --doctor` の出力

これらの情報があれば、より詳細なサポートが可能です。
