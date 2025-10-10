require 'rails_helper'

RSpec.describe Improvement, type: :model do
  describe 'バリデーション' do
    it '内容が必須である' do
      improvement = described_class.new
      expect(improvement).not_to be_valid
      expect(improvement.errors[:content]).to include("can't be blank")
    end
  end

  describe 'アソシエーション' do
    it '職務経歴に属する' do
      association = described_class.reflect_on_association(:work_experience)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
