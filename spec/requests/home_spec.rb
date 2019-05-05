# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home' do
  describe 'GET /' do
    subject { get root_url }
    context 'with a logged in user' do
      before { sign_in create(:user) }

      it 'responds with a 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'without a logged in user' do
      it 'responds with a 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end
end
