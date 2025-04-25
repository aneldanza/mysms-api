require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /me' do
    let(:user) { create(:user) }

    context 'when authenticated' do
      let(:token) do
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end

      it 'returns the current user data' do
        get '/me', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json['id']).to eq({"$oid"=>user.id.to_s})
        expect(json['email']).to eq(user.email)
        expect(json['username']).to eq(user.username)
        expect(json).to have_key('created_at')
        expect(json).to have_key('updated_at')
      end
    end

    context 'when not authenticated' do
      it 'returns error' do
        get '/me'
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end
end
