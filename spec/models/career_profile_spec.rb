require 'rails_helper'

RSpec.describe CareerProfile, type: :model do
  describe 'アソシエーション' do
    it 'ユーザーに属する' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it '職務経歴を多数持つ' do
      association = described_class.reflect_on_association(:work_experiences)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe '削除時の連動削除' do
    it '紐づく職務経歴を削除する' do
      career_profile = create(:career_profile)
      create(:work_experience, career_profile: career_profile)

      expect { career_profile.destroy }.to change { WorkExperience.count }.by(-1)
    end
  end
end
