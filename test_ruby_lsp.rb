# Ruby LSP動作確認用テストファイル
# このファイルでRuby LSPの機能をテストできます

class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def greet
    "Hello, #{@name}!"
  end
end

# 使用例
user = User.new("Taro", "taro@example.com")
puts user.greet

# テスト方法：
# 1. User クラスの定義にカーソルを置いて Cmd+クリック → 定義にジャンプできるはず
# 2. user.greet の greet にカーソルを置いて Cmd+クリック → greetメソッドの定義にジャンプできるはず
# 3. user. と入力すると、name, email, greet の補完が表示されるはず
# 4. User.new にカーソルを置くと、initializeメソッドの引数情報が表示されるはず
