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
    sequence(:title) { |n| "game_title_#{n}" }
    min_players { 1 }
    max_players { 1 }
  end

  trait :with_box_image do
    after(:create) do |game|
      File.open(Rails.root.join('spec', 'fixtures', 'image.jpg'), 'r') do |file|
        game.box_image.attach(io: file, filename: 'image.jpg', content_type: 'image/jpg')
      end
    end
  end
end
