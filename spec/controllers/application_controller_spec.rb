require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_member' do
    controller do
      def index
        render plain: current_member&.id || 'no user'
      end
    end

    context 'when user is logged in' do
      let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password123') }

      before do
        session[:user_id] = user.id
      end

      it 'returns the logged-in user' do
        get :index
        expect(controller.send(:current_member)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        get :index
        expect(controller.send(:current_member)).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    controller do
      def index
        render plain: logged_in?
      end
    end

    context 'when user is logged in' do
      let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password123') }

      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        get :index
        expect(controller.send(:logged_in?)).to be true
      end
    end

    context 'when user is not logged in' do
      it 'returns false' do
        get :index
        expect(controller.send(:logged_in?)).to be false
      end
    end
  end
end