# == Schema Information
#
# Table name: game_sessions
#
#  id           :bigint(8)        not null, primary key
#  scheduled_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  game_id      :bigint(8)
#
# Indexes
#
#  index_game_sessions_on_game_id       (game_id)
#  index_game_sessions_on_scheduled_at  (scheduled_at)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe GameSession do
  let(:instance) { create(:game_session) }

  shared_context "with rsvp'd users" do
    def invitation_for(user)
      Invitation.find_by!(user: user, game_session: instance)
    end

    let(:user_1)   { create(:user, game_sessions: [instance]) }
    let(:user_2)   { create(:user, game_sessions: [instance]) }
    let(:user_3)   { create(:user, game_sessions: [instance]) }
    let(:user_4)   { create(:user, game_sessions: [instance]) }

    before do
      invitation_for(user_1).attending!
      invitation_for(user_2).declined!
      invitation_for(user_3).attending!
      invitation_for(user_4).not_responded!
    end
  end

  shared_context 'with game sessions in different states' do
    let!(:past_sessions)        { create_list(:game_session, 3, :past) }
    let!(:upcoming_sessions)    { create_list(:game_session, 3, :upcoming) }
    let!(:unscheduled_sessions) { create_list(:game_session, 3, :unscheduled) }
  end

  describe '.past' do
    subject { described_class.past }
    include_context 'with game sessions in different states'

    it 'returns sessions that have already happened' do
      expect(subject).to match_array(past_sessions)
    end
  end

  describe '.upcoming' do
    subject { described_class.upcoming }
    include_context 'with game sessions in different states'

    it 'returns sessions that are scheduled in the future' do
      expect(subject).to match_array(upcoming_sessions)
    end
  end

  describe '.unscheduled' do
    subject { described_class.unscheduled }
    include_context 'with game sessions in different states'

    it 'returns sessions that have not been scheduled' do
      expect(subject).to match_array(unscheduled_sessions)
    end
  end

  describe '#available_games' do
    subject { instance.available_games }
    let(:game_1) { create(:game) }
    let(:game_2) { create(:game) }
    let(:game_3) { create(:game) }

    before do
      # Create two users with identical games
      create_list(:user, 2, games: [game_1, game_3], game_sessions: [instance])
      # Create user with a different game
      create(:user, games: [game_2], game_sessions: [instance])
      # Create some games which no one owns
      create_list(:game, 3)
    end

    it 'returns unique games owned by the users' do
      expect(subject).to contain_exactly(game_1, game_2, game_3)
    end
  end

  describe '#attending_users' do
    subject { instance.attending_users }
    include_context "with rsvp'd users"

    it 'returns the users who are attending' do
      expect(subject).to contain_exactly(user_1, user_3)
    end
  end

  describe '#declined_users' do
    subject { instance.declined_users }
    include_context "with rsvp'd users"

    it 'returns the users who have declined' do
      expect(subject).to contain_exactly(user_2)
    end
  end

  describe '#not_responded_users' do
    subject { instance.not_responded_users }
    include_context "with rsvp'd users"

    it 'returns the users who have not responded' do
      expect(subject).to contain_exactly(user_4)
    end
  end
end
