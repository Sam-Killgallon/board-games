# frozen_string_literal: true

require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  extend AuthenticationHelpers

  setup do
    @game = create(:game)
    @user = create(:user, games: [@game])
    sign_in(@user)
  end

  not_found_without_user('get /games') { get '/games' }
  not_found_without_user('get /games/new') { get '/games/new' }
  not_found_without_user('patch /games/:id') { patch "/games/#{@game.id}" }
  not_found_without_user('delete /games/:id') { delete "/games/#{@game.id}" }
  not_found_without_user('get /games/search') { get '/games/search' }

  test 'lists games' do
    get '/games'
    assert_response :success
  end

  test 'only includes games associated with the user' do
    games = create_list(:game, 3)
    get '/games'
    assert_match @game.title, @response.body

    games.each do |game|
      assert_no_match game.title, @response.body
    end
  end

  test 'add new games' do
    get '/games/new'
    assert_response :success
  end

  test 'associate game with current user' do
    assert_difference('@user.reload.games.size', 1) do
      patch "/games/#{create(:game).id}"
    end
  end

  test 'remove game from current user' do
    assert_difference('@user.reload.games.size', -1) do
      delete "/games/#{@game.id}"
    end
  end

  test 'search' do
    game = create(:game, title: 'Awesomeness')
    get '/games/search?q=awes', xhr: true
    assert_match game.title, @response.body
    assert_no_match @game.title, @response.body
  end

  test 'only includes games not associated with the user' do
    create_list(:game, 3)
    get "/games/search?q=#{@game.title}", xhr: true

    assert_no_match @game.title, @response.body
  end
end
