# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。
出力される言語は日本語で統一してください。

## プロジェクト概要

Career Chronicle(通称キャリクロ！)は、職務経歴書を簡単に作成・管理するためのRails 7.1.5アプリケーションです。データベースにPostgreSQL、フロントエンドにVue.js 3とViteを使用し、ゲストユーザーサポート付きのユーザー認証を含んでいます。

## 技術スタック

- Ruby 3.2.3
- Rails 7.1.5
- PostgreSQL
- Vue.js 3 with Vite
- Slimテンプレート
- SCSSスタイリング
- Dockerコンテナ化

## 開発コマンド

### 依存関係のセットアップ
```bash
bundle install           # Ruby依存関係のインストール
npm install             # Node依存関係のインストール
```

### データベースセットアップ
```bash
bundle exec rails db:create    # データベース作成
bundle exec rails db:migrate   # マイグレーション実行
bundle exec rails db:seed      # シードデータ投入（必要に応じて）
```

### 開発サーバー
```bash
# Dockerを使用する場合
docker-compose up       # PostgreSQLとRailsアプリを起動
# bundle コマンドを使用する場合
docker compose exec app bundle # install など

# Dockerを使用しない場合（ローカルPostgreSQLが必要）
bundle exec rails server  # Railsサーバーをポート3000で起動
npm run dev              # フロントエンドアセット用のVite開発サーバーを起動
```

### フロントエンドビルド
```bash
npm run build           # Viteで本番用アセットをビルド
```

### Railsコンソール
```bash
bundle exec rails console  # Railsコンソールにアクセス
bundle exec rails c        # 省略形
```

### データベースコンソール
```bash
bundle exec rails db      # データベースコンソールにアクセス
```

### ルーティング
```bash
bundle exec rails routes  # 全アプリケーションルートを表示
```

## アーキテクチャ

### モデル
- **User**: bcryptによる認証、メールバリデーション、has_secure_password
- **GuestUser**: ゲストユーザーサポート（開発中の新機能）
- **Resume**: キャリア履歴レコード

### コントローラー
- **ApplicationController**: ベースコントローラー
- **HomeController**: ランディングページ
- **UsersController**: ユーザー登録
- **SessionsController**: ログイン/ログアウト
- **ResumesController**: 履歴書管理

### フロントエンドコンポーネント (Vue)
`app/frontend/components/`に配置：
- 認証コンポーネント (AuthTab, LoginIcon, SignupIcon)
- 履歴書フォームコンポーネント
- UI用の各種アイコンコンポーネント
- ヘッダーコンポーネント

### データベース設定
PostgreSQL設定は環境変数を使用：
- DATABASE_HOST (デフォルト: career_chronicle-db)
- DATABASE_USER (デフォルト: career_chronicle_developer)
- DATABASE_PASSWORD (デフォルト: career_chronicle_password)
- DATABASE_NAME (デフォルト: career_chronicle_development)

### 現在のブランチコンテキスト
`guest_users`ブランチで作業中、未コミットの変更あり：
- 変更済み: `app/controllers/resumes_controller.rb`
- 変更済み: `db/schema.rb`
- 新規: `app/models/guest_user.rb`
- 新規: ゲストユーザー機能用のマイグレーションファイル

## テスト
プロジェクトはRailsデフォルトのMinitestフレームワークを使用：
```bash
bundle exec rails test
```

## 開発上の重要事項

1. **Vite統合**: プロジェクトはモダンなフロントエンドツーリングのためにVite Railsを使用。フロントエンドアセットは従来のRailsアセットパイプラインではなくViteを通じて処理される。

2. **Slimテンプレート**: ビューはよりクリーンなHTML生成のためにSlimテンプレート言語を使用。

3. **Docker開発**: Docker ComposeがローカルPostgreSQL開発用に設定済み。データベースはコンテナで実行され、RailsアプリはDockerまたはローカルで実行可能。

4. **認証**: bcryptとhas_secure_passwordを使用したカスタム認証実装（Deviseは不使用）。

5. **Vueコンポーネント**: VueコンポーネントはRailsビューに統合され、Viteパイプラインを通じてインポート可能。

## 確認事項
1. RSpecのテスト実行によって欠落したspecは、欠落理由を調査し、欠落した原因を出力してください。
2. また、欠落した部分のspecの修正について、修正方針を提示してください。
3. デプロイコマンドはkamal deployで実行してください。docker コンテナに入る必要はありません。また、bundleなどの接頭辞も不要です。
4. デプロイで失敗となった場合、原因を究明し、問題だった箇所と、修正内容を出力してください。
5. claudeが実装を行う場合、コードに手を加える前に、実装方針と実装内容を出力してください。