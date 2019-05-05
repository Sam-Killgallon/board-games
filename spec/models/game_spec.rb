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

require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:min_players) }
  it { is_expected.to validate_presence_of(:max_players) }

  it 'should validate that max_players cannot be greater than min_players' do
    game = Game.new(min_players: 3, max_players: 2)
    expect(game).not_to be_valid
    expect(game.errors[:max_players]).to include('must be greater than or equal to min players (3)')
  end

  it 'should be ordered by title' do
    beta = create(:game, title: 'Beta')
    charlie = create(:game, title: 'Charlie')
    alpha = create(:game, title: 'Alpha')

    expect(described_class.all).to eq([alpha, beta, charlie])
  end
end
