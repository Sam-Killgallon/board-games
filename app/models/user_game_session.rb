# frozen_string_literal: true
# == Schema Information
#
# Table name: user_game_sessions
#
#  id              :bigint(8)        not null, primary key
#  rsvp            :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_session_id :bigint(8)
#  user_id         :bigint(8)
#
# Indexes
#
#  index_user_game_sessions_on_game_session_id              (game_session_id)
#  index_user_game_sessions_on_user_id                      (user_id)
#  index_user_game_sessions_on_user_id_and_game_session_id  (user_id,game_session_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_session_id => game_sessions.id)
#  fk_rails_...  (user_id => users.id)
#

class UserGameSession < ApplicationRecord
  enum rsvp: %i[not_responded attending declined]
  belongs_to :user
  belongs_to :game_session
end
