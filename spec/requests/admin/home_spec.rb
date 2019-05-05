# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Homes' do
  describe 'GET /admin' do
    subject { get admin_root_url }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in as a normal user' do
      before { sign_in create(:user) }
      it_behaves_like 'not found'
    end

    context 'when signed in as an admin' do
      before { sign_in create(:user, :admin) }

      it 'returns a success status code' do
        subject
        expect(response).to be_successful
      end
    end
  end
end
