require 'rails_helper'

RSpec.describe Resume, type: :model do
  describe 'アソシエーション' do
    it 'ユーザーに属する' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it '複数の企業を持つ' do
      association = described_class.reflect_on_association(:companies)
      expect(association.macro).to eq(:has_many)
    end

    it '企業が削除されると、関連する企業も削除される' do
      association = described_class.reflect_on_association(:companies)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }

    it 'user_idが必須である' do
      resume = Resume.new(user_id: nil)
      expect(resume).not_to be_valid
      expect(resume.errors[:user_id]).to include("を入力してください")
    end

    it '1ユーザーは1つの経歴書のみ作成できる（一意性制約）' do
      Resume.create!(user: user)
      duplicate_resume = Resume.new(user: user)

      expect(duplicate_resume).not_to be_valid
      expect(duplicate_resume.errors[:user_id]).to include("はすでに存在します")
    end

    it '有効な属性で作成できる' do
      resume = Resume.new(user: user)
      expect(resume).to be_valid
    end
  end

  describe '作成' do
    context 'Memberユーザーの場合' do
      let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }

      it '職務経歴書が正常に作成できる' do
        resume = Resume.create!(user: user)

        expect(resume).to be_persisted
        expect(resume.user).to eq(user)
        expect(resume.companies).to be_empty
      end
    end

    context 'Guestユーザーの場合' do
      let(:guest) { Guest.create!(session_token: SecureRandom.hex(16)) }

      it '職務経歴書が正常に作成できる' do
        resume = Resume.create!(user: guest)

        expect(resume).to be_persisted
        expect(resume.user).to eq(guest)
        expect(resume.companies).to be_empty
      end

      it 'Guestユーザーもresumeを保有できる' do
        resume = Resume.new(user: guest)
        expect(resume).to be_valid
      end
    end
  end
end