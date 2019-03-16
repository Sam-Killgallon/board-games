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

class Game < ApplicationRecord
  validates :title, presence: true
  validates :min_players, presence: true
  validates :max_players, presence: true
  validates :max_players, numericality: {
    greater_than_or_equal_to: ->(game) { game.min_players },
    message: ->(game, _data) { "must be greater than or equal to min players (#{game.min_players})" }
  }

  # This destroys the join record, not the actual user
  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games
  has_many :game_sessions, dependent: :restrict_with_exception
end