# frozen_string_literal: true

# == Schema Information
#
# Table name: invitations
#
#  id              :bigint(8)        not null, primary key
#  rsvp            :integer          default("not_responded"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_session_id :bigint(8)
#  user_id         :bigint(8)
#
# Indexes
#
#  index_invitations_on_game_session_id              (game_session_id)
#  index_invitations_on_user_id                      (user_id)
#  index_invitations_on_user_id_and_game_session_id  (user_id,game_session_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_session_id => game_sessions.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Invitation do
end
