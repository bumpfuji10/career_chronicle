require 'rails_helper'

RSpec.describe JsonResponseGenerator do
  describe '#generate' do
    context 'リソースが保存されている場合' do
      let(:user) { create(:user) }
      let(:resume) { create(:resume, user: user) }
      let(:generator) { described_class.new(resume, user: user) }

      it '成功レスポンスを返す' do
        response = JSON.parse(generator.generate)
        expect(response['status']).to eq('success')
        expect(response['data']).to be_present
        expect(response['data']['id']).to eq(resume.id)
      end
    end

    context 'リソースが保存されていない場合' do
      let(:resume) { build(:resume) }
      let(:generator) { described_class.new(resume) }

      before do
        resume.valid?
      end

      it 'エラーレスポンスを返す' do
        response = JSON.parse(generator.generate)
        expect(response['status']).to eq('error')
        expect(response['message']).to eq('保存に失敗しました')
      end
    end

    context 'リソースがnilの場合' do
      let(:generator) { described_class.new(nil) }

      it 'エラーレスポンスを返す' do
        response = JSON.parse(generator.generate)
        expect(response['status']).to eq('error')
        expect(response['message']).to eq('保存に失敗しました')
      end
    end
  end

  describe '#success' do
    let(:generator) { described_class.new }

    context 'カスタムデータを渡した場合' do
      it 'カスタムデータを含む成功レスポンスを返す' do
        response = JSON.parse(generator.success({ message: 'カスタムデータ' }))
        expect(response['status']).to eq('success')
        expect(response['data']['message']).to eq('カスタムデータ')
      end
    end

    context '履歴書リソースの場合' do
      let(:user) { create(:user) }
      let(:resume) { create(:resume, user: user) }
      let(:generator) { described_class.new(resume, user: user) }

      it 'シリアライズされた履歴書データを返す' do
        response = JSON.parse(generator.success)
        expect(response['status']).to eq('success')
        expect(response['data']['id']).to eq(resume.id)
        expect(response['data']['summary']).to eq(resume.summary)
        expect(response['data']['user']).to be_present
      end
    end
  end

  describe '#error' do
    let(:generator) { described_class.new }

    context 'メッセージとエラー詳細を渡した場合' do
      it '詳細を含むエラーレスポンスを返す' do
        response = JSON.parse(generator.error('カスタムエラー', ['エラー1', 'エラー2']))
        expect(response['status']).to eq('error')
        expect(response['message']).to eq('カスタムエラー')
        expect(response['errors']).to eq(['エラー1', 'エラー2'])
      end
    end

    context 'パラメータなしの場合' do
      it 'デフォルトのエラーレスポンスを返す' do
        response = JSON.parse(generator.error)
        expect(response['status']).to eq('error')
        expect(response['message']).to eq('An error occurred')
        expect(response).not_to have_key('errors')
      end
    end
  end

  describe 'ユーザーのシリアライズ' do
    context 'ゲストユーザーの場合' do
      let(:guest_user) { create(:guest_user) }
      let(:resume) { create(:resume, user: guest_user) }
      let(:generator) { described_class.new(resume, user: guest_user) }

      it '限定的なユーザーデータをシリアライズする' do
        response = JSON.parse(generator.success)
        user_data = response['data']['user']
        expect(user_data['type']).to eq('guest')
        expect(user_data['id']).to eq(guest_user.id)
        expect(user_data).not_to have_key('email')
        expect(user_data).not_to have_key('name')
      end
    end

    context '登録済みユーザーの場合' do
      let(:registered_user) { create(:registered_user) }
      let(:resume) { create(:resume, user: registered_user) }
      let(:generator) { described_class.new(resume, user: registered_user) }

      it '完全なユーザーデータをシリアライズする' do
        response = JSON.parse(generator.success)
        user_data = response['data']['user']
        expect(user_data['type']).to eq('registered')
        expect(user_data['id']).to eq(registered_user.id)
        expect(user_data['email']).to eq(registered_user.email)
        expect(user_data['name']).to eq(registered_user.name)
      end
    end

    context '通常のユーザーの場合' do
      let(:user) { create(:user) }
      let(:resume) { create(:resume, user: user) }
      let(:generator) { described_class.new(resume, user: user) }

      it '完全なユーザーデータをシリアライズする' do
        response = JSON.parse(generator.success)
        user_data = response['data']['user']
        expect(user_data['type']).to eq('registered')
        expect(user_data['id']).to eq(user.id)
        expect(user_data['email']).to eq(user.email)
        expect(user_data['name']).to eq(user.name)
      end
    end
  end
end