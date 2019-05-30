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
  has_many :invitations, dependent: :destroy
  has_many :users, through: :invitations
  has_many :games, through: :users

  scope :past,        -> { where('scheduled_at <= ?', Time.current) }
  scope :upcoming,    -> { where('scheduled_at >= ?', Time.current) }
  scope :unscheduled, -> { where(scheduled_at: nil) }

  def available_games
    # Return all distinct games which are owned by a user in this session
    games.distinct.by_title
  end

  def suitable_games
    available_games.where(suitable_query)
  end

  def unsuitable_games
    available_games.where.not(suitable_query)
  end

  def attending_users
    users.where(invitations: { rsvp: :attending })
  end

  def not_responded_users
    users.where(invitations: { rsvp: :not_responded })
  end

  def declined_users
    users.where(invitations: { rsvp: :declined })
  end

  private

  def suitable_query
    min_players_condition = Game.arel_table[:min_players].lteq(users.size)
    max_players_condition = Game.arel_table[:max_players].gteq(users.size)

    min_players_condition.and(max_players_condition)
  end
end
