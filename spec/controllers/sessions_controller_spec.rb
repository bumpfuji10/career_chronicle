require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#destroy' do
    context 'when user is logged in' do
      let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password123') }

      before do
        session[:user_id] = user.id
      end

      it 'clears the session' do
        delete :destroy
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to root path' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it 'sets a logout notice' do
        delete :destroy
        expect(flash[:notice]).to eq('ログアウトしました。')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to root path' do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end
    end
  end
end