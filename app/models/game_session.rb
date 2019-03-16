# frozen_string_literal: true
# == Schema Information
#
# Table name: game_sessions
#
#  id           :bigint(8)        not null, primary key
#  scheduled_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  game_id      :bigint(8)
#
# Indexes
#
#  index_game_sessions_on_game_id       (game_id)
#  index_game_sessions_on_scheduled_at  (scheduled_at)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

class GameSession < ApplicationRecord
  belongs_to :game, optional: true
  has_many :user_game_sessions, dependent: :destroy
  has_many :users, through: :user_game_sessions

  scope :past, -> { where('scheduled_at <= ?', Time.current) }
  scope :upcoming, -> { where('scheduled_at >= ?', Time.current) }
  scope :unscheduled, -> { where(scheduled_at: nil) }

  def available_games
    users.includes(:games).flat_map(&:games).uniq
  end
end