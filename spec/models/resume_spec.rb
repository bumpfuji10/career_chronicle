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
    let(:user) { create(:registered_user) }

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
        user2 = create(:registered_user)

        resume1 = Resume.create!(user: user)
        resume2 = Resume.new(user: user2)

        expect(resume1).to be_valid
        expect(resume2).to be_valid
      end
    end

    context 'summaryのバリデーション' do
      it 'summaryは任意項目である' do
        resume = Resume.new(user: user, summary: nil)
        expect(resume).to be_valid
      end

      it 'summaryは空文字列でも有効' do
        resume = Resume.new(user: user, summary: '')
        expect(resume).to be_valid
      end

      it 'summaryは10,000文字まで保存できる' do
        resume = Resume.new(user: user, summary: 'あ' * 10_000)
        expect(resume).to be_valid
      end

      it 'summaryが10,000文字を超える場合は無効' do
        resume = Resume.new(user: user, summary: 'あ' * 10_001)
        expect(resume).to be_invalid
        expect(resume.errors[:summary]).to include("は10000文字以内で入力してください")
      end
    end
  end

  describe '作成' do
    context 'Memberユーザーの場合' do
      let(:user) { create(:registered_user) }

      it '職務経歴書が正常に作成できる' do
        resume = Resume.create!(user: user)

        expect(resume).to be_persisted
        expect(resume.user).to eq(user)
        expect(resume.companies).to be_empty
        expect(resume.summary).to be_nil
      end
    end

    context 'Guestユーザーの場合' do
      let(:guest) { create(:guest_user) }

      it '職務経歴書が正常に作成できる' do
        resume = Resume.create!(user: guest)

        expect(resume).to be_persisted
        expect(resume.user).to eq(guest)
        expect(resume.companies).to be_empty
        expect(resume.summary).to be_nil
      end

      it 'Guestユーザーもresumeを保有できる' do
        resume = Resume.new(user: guest)
        expect(resume).to be_valid
      end
    end

    context 'summaryを含む場合' do
      let(:user) { create(:registered_user) }

      it 'summaryと一緒に作成できる' do
        resume = Resume.create!(user: user, summary: '私は株式会社ABCで営業として働きました。')

        expect(resume).to be_persisted
        expect(resume.summary).to eq('私は株式会社ABCで営業として働きました。')
      end
    end
  end
end