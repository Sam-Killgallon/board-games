# frozen_string_literal: true
# == Schema Information
#
# Table name: games
#
#  id          :bigint(8)        not null, primary key
#  max_players :integer          not null
#  min_players :integer          not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_games_on_title  (title) UNIQUE
#

require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'valid factory' do
    game = build(:game)
    assert game.valid?
  end

  test 'valid game' do
    game = Game.new(title: 'Foo', min_players: 1, max_players: 2)
    assert game.valid?
  end

  test 'invalid without title' do
    game = Game.new(title: nil)
    assert_not game.valid?
    assert_includes game.errors[:title], "can't be blank"
  end

  test 'invalid without min_players' do
    game = Game.new(min_players: nil)
    assert_not game.valid?
    assert_includes game.errors[:min_players], "can't be blank"
  end

  test 'invalid without max_players' do
    game = Game.new(max_players: nil)
    assert_not game.valid?
    assert_includes game.errors[:max_players], "can't be blank"
  end
end
