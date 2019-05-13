# frozen_string_literal: true

# == Schema Information
#
# Table name: ownerships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_ownerships_on_game_id              (game_id)
#  index_ownerships_on_user_id              (user_id)
#  index_ownerships_on_user_id_and_game_id  (user_id,game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :ownership do
  end
end
