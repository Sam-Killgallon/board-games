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

FactoryBot.define do
  factory :game do
    title { 'MyString' }
    min_players { 1 }
    max_players { 1 }
  end
end
