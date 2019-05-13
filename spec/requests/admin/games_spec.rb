# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Games' do
  describe 'GET /admin/games' do
    subject { get admin_games_url }

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

  describe 'GET /admin/games/:id' do
    subject { get admin_game_url(game) }
    let(:game) { create(:game, :with_box_image) }

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

  describe 'GET /admin/games/new' do
    subject { get new_admin_game_url }

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

  describe 'GET /admin/games/:id/edit' do
    subject { get edit_admin_game_url(game) }
    let(:game) { create(:game) }

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

  describe 'POST /admin/games/' do
    subject { post admin_games_url, params: { game: game_params } }
    let(:game_params) { { title: title, min_players: min_players, max_players: max_players } }
    let(:title)       { 'some-title' }
    let(:min_players) { 4 }
    let(:max_players) { 6 }

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
        new_game = Game.order(created_at: :desc).last
        expect(response).to have_http_status(302)
        expect(response.location).to eql(admin_game_url(new_game))
      end

      it 'creates a game with the supplied attributes' do
        subject
        new_game = Game.order(created_at: :desc).last
        expect(new_game).to have_attributes(title: title, min_players: min_players, max_players: max_players)
      end

      context 'with invalid attributes' do
        let(:game_params) { { title: 'foo' } }

        it 'renders the edit page' do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context 'with an uploaded image' do
        let(:game_params) do
          {
            title: title,
            min_players: min_players,
            max_players: max_players,
            box_image: fixture_file_upload('spec/fixtures/image.jpg')
          }
        end

        it 'uploads the box image' do
          subject
          new_game = Game.order(created_at: :desc).last
          expect(new_game.box_image).to be_attached
          expect(new_game.box_image.checksum).to eql('qi15ImxQ/Tg0MbUMlmQIgw==')
        end
      end

      context 'without a box image uploaded' do
        it 'generates a placeholder' do
          subject
          new_game = Game.order(created_at: :desc).last
          expect(new_game.box_image).to be_attached
        end
      end
    end
  end

  describe 'PATCH /admin/games/:id' do
    subject { patch admin_game_url(game), params: { game: game_params } }
    let(:game)            { create(:game) }
    let(:game_params)     { { title: new_title, min_players: new_min_players, max_players: new_max_players } }
    let(:new_title)       { 'some new title' }
    let(:new_min_players) { 3 }
    let(:new_max_players) { 6 }

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
        expect(response).to have_http_status(302)
        expect(response.location).to eql(admin_game_url(game))
      end

      it 'updates the allowed attributes' do
        original_attributes = {
          'title' => game.title,
          'min_players' => game.min_players,
          'max_players' => game.max_players
        }
        new_attributes = {
          'title' => new_title,
          'min_players' => new_min_players,
          'max_players' => new_max_players
        }
        expect { subject }.to change { game.reload.attributes }
          .from(hash_including(original_attributes))
          .to(hash_including(new_attributes))
      end

      context 'with unpermitted attributes' do
        let(:game_params) { { created_at: 1.week.ago, updated_at: 2.days.ago, id: 9_999_999 } }

        it 'does not update unpermitted attributes' do
          expect { subject }.not_to change { game.reload.attributes }
        end
      end
    end
  end

  describe 'DELETE /admin/games/:id' do
    subject { delete admin_game_url(game) }
    let(:game) { create(:game) }

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
        expect(response).to have_http_status(302)
        expect(response.location).to eql(admin_games_url)
      end
    end
  end
end
