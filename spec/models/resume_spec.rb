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

    it '経歴書が削除されると、関連する企業も削除される' do
      association = described_class.reflect_on_association(:companies)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'バリデーション' do
    let(:user) { Member.create!(name: 'テストユーザー', email: 'test@example.com', password: 'password123') }

    context 'userの存在確認' do
      it 'userが紐づいていない場合、作成に失敗する' do
        resume = Resume.new(user: nil)
        expect(resume).to be_invalid
        expect(resume.errors[:user]).to be_present
      end

      it 'userが紐づいている場合、作成できる' do
        resume = Resume.new(user: user)
        expect(resume).to be_valid
      end
    end

    context 'user_idの一意性' do
      it 'resumeが保有するuser_idはuniqueである' do
        Resume.create!(user: user)
        duplicate_resume = Resume.new(user: user)

        expect(duplicate_resume).to be_invalid
        expect(duplicate_resume.errors[:user_id]).to include("はすでに存在します")
      end

      it '異なるuserであれば、それぞれresumeを作成できる' do
        user2 = Member.create!(name: 'テストユーザー2', email: 'test2@example.com', password: 'password123')

        resume1 = Resume.create!(user: user)
        resume2 = Resume.new(user: user2)

        expect(resume1).to be_valid
        expect(resume2).to be_valid
      end
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