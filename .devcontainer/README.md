# Dev Container セットアップ

このプロジェクトはVSCode Dev Containerを使用して、Ruby LSPによる定義ジャンプや補完機能を提供します。

## 初回セットアップ

1. VSCodeを開く
2. 拡張機能「Remote - Containers」をインストール
3. コマンドパレット（Cmd+Shift+P / Ctrl+Shift+P）を開く
4. 「Dev Containers: Reopen in Container」を選択
5. 初回はgemとnpmのインストールが自動実行されます（数分かかります）

## Ruby LSPの機能

- **定義ジャンプ**: Cmd+クリック（Macの場合）またはF12で定義元にジャンプ
- **補完**: 入力時に自動的にメソッドや変数の補完が表示される
- **ホバー情報**: コードの上にカーソルを置くとドキュメントが表示される
- **リファクタリング**: コードの改善提案を受け取れる
- **シンボル検索**: Cmd+T でプロジェクト内のクラス・メソッドを検索

## テスト方法

プロジェクトルートに `test_ruby_lsp.rb` というテストファイルがあります。
このファイルを開いて以下を試してください：

1. `User` クラスの定義にカーソルを置いて Cmd+クリック
2. `user.greet` の `greet` にカーソルを置いて Cmd+クリック
3. `user.` と入力して補完が表示されるか確認
4. `User.new` にカーソルを置いて引数情報が表示されるか確認

## インストールされる拡張機能

- **Shopify.ruby-lsp**: Ruby言語サーバー
- **Vue.volar**: Vue.js 3サポート
- **GitLens**: Git履歴の可視化
- **Docker**: Docker管理
- **Slim**: Slimテンプレートサポート
- **Sass**: SCSS/Sassサポート
- **ESLint**: JavaScriptリンター

## ポート転送

以下のポートが自動的に転送されます：

- **3000**: Rails Server
- **3036**: Vite Dev Server
- **5432**: PostgreSQL

## トラブルシューティング

### Ruby LSPが動作しない場合の確認手順

#### 1. VSCodeのOutput パネルでログを確認

- View → Output → ドロップダウンから「Ruby LSP」を選択
- エラーメッセージがあれば内容を確認

#### 2. 他のRuby拡張機能との競合を確認

以下の拡張機能がインストールされている場合は無効化してください：
- Solargraph
- Ruby (古いバージョンの拡張機能)
- VSCode Ruby

無効化方法：
- 拡張機能パネルを開く
- 該当の拡張機能を右クリック
- 「無効にする (ワークスペース)」を選択

#### 3. コンテナを完全に再ビルド

```
コマンドパレット（Cmd+Shift+P） → "Dev Containers: Rebuild Container Without Cache"
```

#### 4. Ruby LSPの診断を実行

コンテナ内で以下のコマンドを実行：

```bash
docker compose exec app bash -c "cd /rails && bundle exec ruby-lsp --doctor"
```

正常に動作していれば、プロジェクトファイルのインデックス作成が表示されます。

#### 5. Gemfile.lockを確認

```bash
docker compose exec app bundle info ruby-lsp
```

ruby-lsp (0.26.1) が表示されればOKです。

#### 6. VSCodeをリロード

```
コマンドパレット → "Developer: Reload Window"
```

### Ruby LSPが起動しているか確認する方法

VSCodeの右下のステータスバーに「Ruby LSP」と表示されていれば起動しています。
表示されていない場合は、Rubyファイルを開いてから数秒待ってください。

### それでも動作しない場合

1. VSCodeのバージョンを最新に更新
2. Shopify.ruby-lsp 拡張機能を最新バージョンに更新
3. `.vscode/settings.json` の内容を確認：

```json
{
  "rubyLsp.enabled": true,
  "rubyLsp.useBundler": true,
  "rubyLsp.bundleGemfile": "/rails/Gemfile",
  "rubyLsp.customRubyCommand": "/usr/local/bin/ruby"
}
```

### コンテナが起動しない場合

```bash
# ローカルでDockerコンテナを起動
docker compose up --build

# コンテナの状態を確認
docker compose ps

# コンテナのログを確認
docker compose logs app
```

## 参考リンク

- [Ruby LSP 公式ドキュメント](https://shopify.github.io/ruby-lsp/)
- [VSCode Dev Containers ドキュメント](https://code.visualstudio.com/docs/devcontainers/containers)
