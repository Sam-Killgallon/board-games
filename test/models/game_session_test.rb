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
#  index_game_sessions_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

require 'test_helper'

class GameSessionTest < ActiveSupport::TestCase
end
