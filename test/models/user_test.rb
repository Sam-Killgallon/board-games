# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("user"), not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid factory' do
    user = build(:user)
    assert user.valid?
  end

  test 'valid user' do
    password = 'a' * 6
    user = User.new(email: 'sam@example.com', password: password, password_confirmation: password)
    assert user.valid?
  end

  test 'invalid without email' do
    user = User.new(email: nil)
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test 'invalid without password' do
    user = User.new(password: nil)
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test 'invalid with short password' do
    password = 'a' * 5
    user = User.new(password: password)
    assert_not user.valid?
    assert_includes user.errors[:password], 'is too short (minimum is 6 characters)'
  end

  test 'invalid without a role' do
    user = User.new
    user.role = nil
    assert_not user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test 'sets correct default role' do
    user = User.new
    assert user.user?
    assert_not user.admin?
  end

  test 'role can be overriden' do
    assert User.new(role: :admin).admin?
  end

  test 'only sets the role on new records' do
    user = create(:user, role: :admin)
    assert User.find(user.id).admin?
  end
end
