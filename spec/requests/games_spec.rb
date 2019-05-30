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

  describe 'GET /games/:id' do
    subject { get game_url(game) }
    let(:game) { create(:game, :with_box_image) }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when the user owns the game' do
        before { user.games << game }

        it 'returns a success status code' do
          subject
          expect(response).to be_successful
        end
      end

      context 'when the user does not own the game' do
        it 'returns a success status code' do
          subject
          expect(response).to be_successful
        end
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

      it 'redirects to the new games list' do
        subject
        expect(response).to have_http_status(302)
        expect(response.location).to eql(new_game_url)
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
end
