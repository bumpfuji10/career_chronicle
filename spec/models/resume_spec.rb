require 'rails_helper'

RSpec.describe Resume, type: :model do
  describe 'アソシエーション' do
    it 'ユーザーに属する（任意）' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
    end

    it 'ゲストユーザーに属する（任意）' do
      association = described_class.reflect_on_association(:guest_user)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
    end
  end

  describe 'バリデーション' do
    it 'ユーザーまたはゲストユーザーのいずれかが必須である' do
      resume = Resume.new(
        company: 'テスト企業',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'テスト実装',
        achievements: '成功'
      )
      
      expect(resume).not_to be_valid
      expect(resume.errors[:base]).to include("Either user or guest_user must be present")
    end

    it 'ゲストユーザーがあれば有効である' do
      guest_user = GuestUser.create!(session_token: SecureRandom.hex(16))
      resume = Resume.new(
        guest_user: guest_user,
        company: 'テスト企業',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'テスト実装',
        achievements: '成功'
      )
      
      expect(resume).to be_valid
    end

    it 'ユーザーがあれば有効である' do
      user = User.create!(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      resume = Resume.new(
        user: user,
        company: 'テスト企業',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'テスト実装',
        achievements: '成功'
      )
      
      expect(resume).to be_valid
    end

    it 'ユーザーとゲストユーザーの両方に属することができる' do
      guest_user = GuestUser.create!(session_token: SecureRandom.hex(16))
      user = User.create!(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      
      resume = Resume.new(
        user: user,
        guest_user: guest_user,
        company: 'テスト企業',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'テスト実装',
        achievements: '成功'
      )
      
      expect(resume).to be_valid
    end
  end

  describe '作成' do
    let(:guest_user) { GuestUser.create!(session_token: SecureRandom.hex(16)) }

    it 'すべての必要な属性を持つ職務経歴書が作成できる' do
      resume = Resume.create!(
        guest_user: guest_user,
        company: 'テック株式会社',
        position: 'シニア開発者',
        tasks: 'Webアプリケーション開発',
        improvements: '自動テストの実装',
        achievements: 'バグを80%削減',
        summary: '生成されたサマリーテキスト'
      )

      expect(resume).to be_persisted
      expect(resume.company).to eq('テック株式会社')
      expect(resume.position).to eq('シニア開発者')
      expect(resume.tasks).to eq('Webアプリケーション開発')
      expect(resume.improvements).to eq('自動テストの実装')
      expect(resume.achievements).to eq('バグを80%削減')
      expect(resume.summary).to eq('生成されたサマリーテキスト')
    end
  end
end