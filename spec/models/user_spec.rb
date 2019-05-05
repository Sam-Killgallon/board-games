# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User do
  let(:instance) { create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:role) }

  describe '#role' do
    it 'sets correct default role' do
      expect(instance).to be_user
      expect(instance).not_to be_admin
    end

    it 'can be created with a different role' do
      instance = create(:user, role: :admin)
      expect(instance).to be_admin
    end

    it 'only sets the role on new records' do
      instance = create(:user, role: :admin)
      expect(User.find(instance.id)).to be_admin
    end
  end

  describe '#past_game_sessions' do
    subject { instance.past_game_sessions }

    let!(:past_sessions) { create_list(:game_session, 2, :past, users: [instance]) }
    before do
      # Upcoming game sessions
      create_list(:game_session, 2, :upcoming, users: [instance])
      # Unscheduled game sessions
      create_list(:game_session, 2, :unscheduled, users: [instance])
      # Past game sessions which don't include the user
      create_list(:game_session, 2, :past, users: [])
    end

    it 'returns all past game sessions the user was invited to' do
      expect(subject).to match_array(past_sessions)
    end
  end

  describe '#past_game_sessions' do
    subject { instance.upcoming_game_sessions }

    let!(:upcoming_sessions)    { create_list(:game_session, 2, :upcoming, users: [instance]) }
    let!(:unscheduled_sessions) { create_list(:game_session, 2, :unscheduled, users: [instance]) }
    before do
      # Past game sessions
      create_list(:game_session, 2, :past, users: [instance])
      # Upcoming game sessions which don't include the user
      create_list(:game_session, 2, :past, users: [])
    end

    it 'returns all upcoming and unscheduled game sessions the user has been invited to' do
      expect(subject).to match_array(unscheduled_sessions + upcoming_sessions)
    end
  end
end
