# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
end
