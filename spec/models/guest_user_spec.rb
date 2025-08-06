require 'rails_helper'

RSpec.describe GuestUser, type: :model do
  describe 'アソシエーション' do
    it '複数の職務経歴書を持つことができる' do
      association = described_class.reflect_on_association(:resumes)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    it 'セッショントークンが必須である' do
      guest_user = GuestUser.new
      expect(guest_user).not_to be_valid
      expect(guest_user.errors[:session_token]).to include("can't be blank")
    end

    it 'セッショントークンが一意である' do
      token = SecureRandom.hex(16)
      GuestUser.create!(session_token: token)
      
      duplicate_user = GuestUser.new(session_token: token)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:session_token]).to include("has already been taken")
    end
  end

  describe 'ゲストユーザーの作成' do
    it 'セッショントークンを持つゲストユーザーが作成できる' do
      guest_user = GuestUser.create!(session_token: SecureRandom.hex(16))
      expect(guest_user).to be_persisted
      expect(guest_user.session_token).to be_present
    end

    it 'セッショントークンなしでは作成に失敗する' do
      guest_user = GuestUser.new
      expect(guest_user).not_to be_valid
      expect(guest_user.errors[:session_token]).to include("can't be blank")
    end

    it '重複したセッショントークンでは作成に失敗する' do
      token = SecureRandom.hex(16)
      GuestUser.create!(session_token: token)
      
      duplicate_user = GuestUser.new(session_token: token)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:session_token]).to include("has already been taken")
    end
  end

  describe '職務経歴書との関連' do
    let(:guest_user) { GuestUser.create!(session_token: SecureRandom.hex(16)) }

    it '複数の職務経歴書を持つことができる' do
      resume1 = guest_user.resumes.create!(
        company: '株式会社A',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'パフォーマンス最適化',
        achievements: 'ロード時間を50%削減'
      )
      resume2 = guest_user.resumes.create!(
        company: '株式会社B',
        position: 'シニア開発者',
        tasks: 'チームリード',
        improvements: 'コードレビュープロセス',
        achievements: 'コード品質向上'
      )

      expect(guest_user.resumes.count).to eq(2)
      expect(guest_user.resumes).to include(resume1, resume2)
    end

    it 'ゲストユーザーが削除されると関連する職務経歴書も削除される' do
      guest_user.resumes.create!(
        company: '株式会社A',
        position: '開発者',
        tasks: 'コーディング',
        improvements: 'パフォーマンス最適化',
        achievements: 'ロード時間を50%削減'
      )

      expect { guest_user.destroy }.to change { Resume.count }.by(-1)
    end
  end
end