# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /users/sign_in' do
    subject { get new_user_session_url }

    context 'when not signed in' do
      it 'responds with a 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'when signed in' do
      before { sign_in create(:user) }

      it 'redirects to the homepage' do
        subject
        expect(response).to have_http_status(302)
        expect(response.location).to eql(root_url)
      end
    end
  end

  describe 'POST /users/sign_in' do
    subject { post user_session_url, params: params }
    let(:user) { create(:user) }

    context 'with valid log in details' do
      let(:params) { { user: { email: user.email, password: user.password } } }

      it 'signs in the user' do
        subject
        expect(response).to have_http_status(302)
        expect(response.location).to eql(root_url)
      end
    end

    context 'with invalid log in details' do
      let(:params) { { user: { email: user.email, password: 'INCORRECT' } } }

      it 'does not sign in the user' do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    subject { delete destroy_user_session_url }

    let(:user) { create(:user) }
    before { sign_in user }

    it 'signs out the user' do
      subject
      expect(response).to have_http_status(302)
      expect(response.location).to eql(root_url)
    end
  end
end
