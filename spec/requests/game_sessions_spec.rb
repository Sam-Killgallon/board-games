# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GameSessions' do
  describe 'GET /game_sessions' do
    subject { get game_sessions_url }

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

  describe 'GET /game_sessions/:id' do
    subject { get game_session_url(game_session) }
    let(:game_session) { create(:game_session) }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when the user is not part of the game session' do
        it_behaves_like 'not found'
      end

      context 'when the user is part of the game session' do
        let(:game_session) { create(:game_session, users: [user]) }

        it 'returns a success status code' do
          subject
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'POST /game_sessions' do
    subject { post game_sessions_url }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      it 'redirects to the new game session' do
        subject
        expect(response).to have_http_status(302)
        new_game_session = GameSession.last
        expect(response.location).to eql(game_session_url(new_game_session))
      end

      it 'creates a new game session' do
        expect { subject }.to change { GameSession.count }.by(1)
      end

      it 'adds the signed in user to the game session' do
        subject
        new_game_session = GameSession.last
        expect(new_game_session.users).to contain_exactly(user)
      end
    end
  end

  describe 'PATCH /game_sessions/:id' do
    subject { patch game_session_url(game_session), params: { game_session: game_session_params } }
    let(:game_session) { create(:game_session) }
    let(:game)         { create(:game) }
    let(:scheduled_at) { Time.new(2019, 0o2, 13, 14, 30).in_time_zone }
    let(:game_session_params) { { game_id: game.id, scheduled_at: scheduled_at } }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when the user is not part of the game session' do
        it_behaves_like 'not found'
      end

      context 'when the user is part of the game session' do
        let(:game_session) { create(:game_session, users: [user]) }

        it 'redirects to the game session' do
          subject
          expect(response).to have_http_status(302)
          expect(response.location).to eql(game_session_url(game_session))
        end

        it 'updates the allowed attributes' do
          expect { subject }.to change { game_session.reload.attributes }
            .from(hash_including('game_id' => nil, 'scheduled_at' => nil))
            .to(hash_including('game_id' => game.id, 'scheduled_at' => scheduled_at))
        end

        context 'with unpermitted attributes' do
          let(:game_session_params) { { created_at: 1.week.ago, updated_at: 2.days.ago, id: 9_999_999 } }

          it 'does not update unpermitted attributes' do
            expect { subject }.not_to change { game_session.reload.attributes }
          end
        end
      end
    end
  end
end
