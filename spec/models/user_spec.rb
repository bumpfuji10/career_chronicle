require "rails_helper"

RSpec.describe User, type: :model do

  describe "validation" do

  end

  describe "methods" do
    describe "is_guest?" do
      context "userがゲストの場合" do
        let(:user) { FactoryBot.create(:guest_user) }
        it "return true" do
          expect(user.is_guest?).to be_truthy
        end
      end

      context "userがメンバーの場合" do
        let(:user) { FactoryBot.create(:registered_user) }
        it "return false" do
          expect(user.is_guest?).to be_falsey
        end
      end
    end
  end

end