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
  BOX_IMAGE_DIMENSIONS = { width: 450, height: 300 }.freeze

  validates :title, presence: true, uniqueness: true
  validates :min_players, presence: true
  validates :max_players, presence: true
  validates :max_players, numericality: {
    greater_than_or_equal_to: ->(game) { game.min_players },
    message: ->(game, _data) { "must be greater than or equal to min players (#{game.min_players})" }
  }

  # This destroys the join record, not the actual user
  has_many :ownerships, dependent: :destroy
  has_many :users, through: :ownerships
  has_many :game_sessions, dependent: :restrict_with_exception
  has_one_attached :box_image

  scope :by_title, -> { order(:title) }
  scope :random, ->(count) { order(Arel.sql('RANDOM()')).limit(count) }

  def box_image_thumbnail
    box_image.variant(resize_to_fit: [120, 80])
  end
end
