# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GameSessions::Users' do
  let(:game_session) { create(:game_session) }

  describe 'POST /game_sessions/:game_session_id/users' do
    subject { post game_session_users_url(game_session), params: { user: user_params } }
    let(:new_user)    { create(:user) }
    let(:user_params) { { email: new_user.email } }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when the signed in user is not part of the game session' do
        it_behaves_like 'not found'
      end

      context 'when the signed in user is part of the game session' do
        let(:game_session) { create(:game_session, users: [user]) }

        it 'redirects to the game session' do
          subject
          expect(response).to have_http_status(302)
          expect(response.location).to eql(game_session_url(game_session))
        end

        it 'adds the new user to the session' do
          expect { subject }.to change { game_session.reload.users }
            .from(contain_exactly(user))
            .to(contain_exactly(user, new_user))
        end

        context 'when the new user email is not found' do
          let(:new_user) { build(:user) }

          it 'raises an error' do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find User")
          end
        end
      end
    end
  end

  describe 'PATCH /game_sessions/:game_session_id/users/:user_id' do
    subject { patch game_session_user_url(game_session, updated_user), params: { user: user_params } }
    let(:updated_user) { create(:user) }
    let(:user_params)  { { rsvp: 'attending' } }

    context 'when not signed in' do
      it_behaves_like 'not found'
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when the signed in user is not part of the game session' do
        it_behaves_like 'not found'
      end

      context 'when the signed in user is part of the game session' do
        let(:game_session) { create(:game_session, users: [user, updated_user]) }

        def invitation_for(user)
          Invitation.find_by!(user: user, game_session: game_session)
        end

        it 'redirects to the game session' do
          subject
          expect(response).to have_http_status(302)
          expect(response.location).to eql(game_session_url(game_session))
        end

        it 'updates the allowed attributes' do
          expect { subject }.to change { invitation_for(updated_user).rsvp }
            .from('not_responded')
            .to('attending')
        end

        context 'when the updated user is not part of the session' do
          let(:game_session) { create(:game_session, users: [user]) }

          it 'raises an error' do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Invitation")
          end
        end
      end
    end
  end
end
