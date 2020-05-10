# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :role, presence: true
  # This destroys the join record, not the actual game
  has_many :ownerships, dependent: :destroy
  has_many :games, -> { readonly }, through: :ownerships
  has_many :invitations, dependent: :destroy
  has_many :game_sessions, through: :invitations

  def created_game_sessions
    game_sessions.where(invitations: { creator: true })
  end

  def past_game_sessions
    game_sessions.past
  end

  def upcoming_game_sessions
    game_sessions.upcoming.or(game_sessions.unscheduled)
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
