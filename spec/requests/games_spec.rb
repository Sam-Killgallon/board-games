# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games' do
  describe 'GET /games' do
    subject { get games_url }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      before { sign_in create(:user) }

      it 'returns a success status code' do
        subject
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /games/new' do
    subject { get new_game_url }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      before { sign_in create(:user) }

      it 'returns a success status code' do
        subject
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /games/:id' do
    subject { patch game_url(game) }
    let(:game) { create(:game) }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:original_user_games) { create_list(:game, 2) }
      let(:user)                { create(:user, games: original_user_games) }
      before { sign_in user }

      it 'returns a success status code' do
        subject
        expect(response).to be_successful
      end

      it 'associates the game with the signed in user' do
        expect { subject }.to change { user.reload.games }
          .from(match_array(original_user_games))
          .to(match_array(original_user_games.including(game)))
      end
    end
  end

  describe 'DELETE /games/:id' do
    subject { delete game_url(game) }
    let(:game) { create(:game) }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:original_user_games) { create_list(:game, 2) }
      let(:user)                { create(:user, games: original_user_games) }
      let(:game) { original_user_games[0] }
      before { sign_in user }

      it 'redirects to the games list' do
        subject
        expect(response).to have_http_status(302)
        expect(response.location).to eql(games_url)
      end

      it 'removes the game from the signed in user' do
        expect { subject }.to change { user.reload.games }
          .from(match_array(original_user_games))
          .to(match_array(original_user_games.excluding(game)))
      end
    end
  end

  describe 'GET /games/search' do
    subject { get games_url(q: 'foo') }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      before { sign_in create(:user) }

      it 'returns a success status code' do
        subject
        expect(response).to be_successful
      end
    end
  end
end
