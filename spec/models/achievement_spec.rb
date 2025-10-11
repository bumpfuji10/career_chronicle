require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe 'バリデーション' do
    it '内容が必須である' do
      achievement = described_class.new
      expect(achievement).not_to be_valid
      expect(achievement.errors[:content]).to include("can't be blank")
    end
  end

  describe 'アソシエーション' do
    it '職務経歴に属する' do
      association = described_class.reflect_on_association(:work_experience)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
