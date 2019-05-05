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

FactoryBot.define do
  factory :game_session do
    trait :unscheduled do
      scheduled_at { nil }
    end

    trait :past do
      scheduled_at { 15.days.ago }
    end

    trait :upcoming do
      scheduled_at { 5.days.from_now }
    end
  end
end
