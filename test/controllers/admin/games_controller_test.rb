# frozen_string_literal: true

require 'test_helper'

class Admin::GamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  setup do
    sign_in(create(:user, :admin))
    @game = create(:game)
  end

  not_found_for_normal_users('admin game index')  { get admin_games_url }
  not_found_for_normal_users('admin new game')    { get new_admin_game_url }
  not_found_for_normal_users('admin create game') { post admin_games_url }
  not_found_for_normal_users('admin show game')   { get admin_game_url(@game) }
  not_found_for_normal_users('admin edit game')   { get edit_admin_game_url(@game) }
  not_found_for_normal_users('admin update game') { patch admin_game_url(@game) }
  not_found_for_normal_users('admin delete game') { delete admin_game_url(@game) }

  test 'should get index' do
    get admin_games_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_game_url
    assert_response :success
  end

  test 'should create game' do
    assert_difference('Game.count') do
      post admin_games_url, params: {
        game: { title: 'Foo', min_players: 1, max_players: 2 }
      }
    end

    game = Game.find_by(title: 'Foo')
    assert_redirected_to admin_game_url(game)
  end

  test 'should show game' do
    get admin_game_url(@game)
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_game_url(@game)
    assert_response :success
  end

  test 'should update game' do
    patch admin_game_url(@game), params: { game: { title: 'bar' } }
    assert_redirected_to admin_game_url(@game)
  end

  test 'should destroy game' do
    assert_difference('Game.count', -1) do
      delete admin_game_url(@game)
    end

    assert_redirected_to admin_games_url
  end
end
